function [] = main()
    clear;
    clc;
    foldresult = zeros(10,6);
    for fold=1:1
        save foldresult_film foldresult fold;
        clear
        load foldresult_film;
        load('DataSet/film_10fold');
        %load('DataSet/label_norm_10fold');
        disp(['fold = ',num2str(fold)]);
        trainDistribution=[];
        trainFeature=[];
        testDistribution=[];
        testFeature=[];
        for i=1:10
            if i==fold
                testDistribution=film_data_10fold{i};
                testFeature=film_feature_10fold{i};
            else
                trainDistribution=[trainDistribution;film_data_10fold{i}];
                trainFeature=[trainFeature;film_feature_10fold{i}];
            end
        end

        trainNum=size(trainFeature,1);
        trainFeatureNum=size(trainFeature,2);
        trainDataNum=size(trainDistribution,2);
        testNum=size(testFeature,1);
        testDataNum=size(testDistribution,2);
        testFeaturenNum=size(testFeature,2);
        save trainData trainNum trainFeature trainDistribution;
        save testData testNum testFeature testDistribution;

        v = 0.05;
        %LogitBoost_LDL_Paper= {};
        for iteration = 10:10
            [F,p,g,scores]= train(trainNum,trainFeature,trainDistribution,trainFeatureNum,trainDataNum,iteration,v);
            distribution=zeros(testNum,testDataNum);
            for m=1:iteration 
                if m>1000
                    v=0.05; 
                end
                tmp=weak_cal(g,testNum,testFeature,testDataNum,m);
                tmpsum=sum(tmp,2)/testDataNum;
                tmpsum2=repmat(tmpsum,1,testDataNum);
                tmp2 = (testDataNum-1)/testDataNum*(tmp-tmpsum2);
                distribution = distribution + v * tmp2; 
            end
            distribution_final=calp(distribution,testNum,testDataNum);

            dist(1,:)=K_L_dist(testDistribution,distribution_final);
            dist(2,:)=Euc_L2_dist(testDistribution,distribution_final);
            dist(3,:)=sorensen_dist(testDistribution,distribution_final);
            dist(4,:)=Squared_X_dist(testDistribution,distribution_final);
            dist(5,:)=Fidelity(testDistribution,distribution_final);
            dist(6,:)=Intersection(testDistribution,distribution_final);
            dist
            %LogitBoost_LDL_Paper{iteration}.Scores = scores;
            %LogitBoost_LDL_Paper{iteration}.Dist = dist;

        end
        foldresult(fold,1)=K_L_dist(testDistribution,distribution_final);
        foldresult(fold,2)=Euc_L2_dist(testDistribution,distribution_final);
        foldresult(fold,3)=sorensen_dist(testDistribution,distribution_final);
        foldresult(fold,4)=Squared_X_dist(testDistribution,distribution_final);
        foldresult(fold,5)=Fidelity(testDistribution,distribution_final);
        foldresult(fold,6)=Intersection(testDistribution,distribution_final);
    end
    save foldresult_film foldresult;
    mean(foldresult)
end

function [F,p,g,scores] = train(trainNum,trainFeature,trainData,trainFeatureNum,trainDataNum,itnum,v)
    w=ones(trainNum,trainDataNum)/trainNum;
    p=ones(trainNum,trainDataNum)/trainDataNum;
    scores = K_L_dist(trainData,p)
    F=zeros(trainNum,trainDataNum);
	g={itnum,trainDataNum};
    z=zeros(trainNum,trainDataNum);
    for m=1:itnum 
        m
        if m>1000
            v=0.05; 
        end
        for j=1:trainDataNum
            for i=1:trainNum
                z(i,j)=(trainData(i,j)-p(i,j))/(p(i,j)*(1-p(i,j)));
                w(i,j)=p(i,j)*(1-p(i,j));
                w(i,j)=max(2*eps(0),w(i,j));
            end
            g{m,j}=lscov(trainFeature(:,:),z(:,j),w(:,j));
        end
        tmp=weak_cal(g,trainNum,trainFeature,trainDataNum,m);
        tmpsum=sum(tmp,2)/trainDataNum;
        tmpsum2=repmat(tmpsum,1,trainDataNum);
        tmp2 = (trainDataNum-1)/trainDataNum*(tmp-tmpsum2);
        F = F + v * tmp2;
        p=calp(F,trainNum,trainDataNum);
        scores = K_L_dist(trainData,p)
    end
end

function [result] = calp(F,trainNum,trainDataNum)
    result = zeros(trainNum,trainDataNum);
    tmpF = exp(F);
    for i=1:trainNum
        tmpsum=0;
        tmpsum=sum(tmpF(i,:),2);
        result(i,:)=tmpF(i,:)./tmpsum;
    end
end
function [result] =  weak_cal(weak_tree,trainNum,trainFeature,trainDataNum,cur)
    result = zeros(trainNum,trainDataNum);
    for j=1:trainDataNum
        result(:,j)=trainFeature*weak_tree{cur,j};
    end
end