load('DataSet\chalearn_age_data.mat');
foldresult = zeros(1,6);
for fold=1:1
    disp(['fold = ',num2str(fold)]);
	%trainDistribution=train_label;
    trainDistribution = zeros(size(train_label));
    for cnti = 1:size(train_label,1)
        trainDistribution(cnti,train_age(cnti))=1;
    end
    
	trainFeature=train_feature;
	%testDistribution=test_label;
    testDistribution = zeros(size(test_label));
    for cnti = 1:size(test_label,1)
        testDistribution(cnti,test_age(cnti))=1;
    end    
    
	testFeature=test_feature;

	trainNum=size(trainFeature,1);
	trainFeatureNum=size(trainFeature,2);
	trainDataNum=size(trainDistribution,2);
	testNum=size(testFeature,1);
	testDataNum=size(testDistribution,2);
	testFeaturenNum=size(testFeature,2);
	save trainData trainNum trainFeature trainDistribution;
	save testData testNum testFeature testDistribution;
    
    fid = fopen('train_data.txt', 'w');

    [max_row, max_col] = size(trainDistribution);
    fprintf(fid,'%d ', max_row);
    fprintf(fid,'%d\n', max_col);

    for row = 1:max_row
        for col = 1:max_col-1
            fprintf(fid,'%f ', trainDistribution(row, col));
        end
            fprintf(fid,'%f\n', trainDistribution(row, max_col));
    end

    fclose(fid);

    %% prepare train/testdata
    load trainData;
    train_feature = trainFeature;
    train_num=trainNum;
    train_data = trainDistribution;
    trainFeatureNum = size(train_feature,2);
    trainDataNum = size(train_data,2);

    load testData;
    test_num=testNum;
    test_feature = testFeature;
    test_data = testDistribution;
    testFeatureNum = size(test_feature,2);
    testDataNum = size(test_data,2);

    Xtr = train_feature(1:train_num,:);
    Xtr = Xtr';
    Xtr = single(Xtr);
    Ytr = (trainDataNum-1)*ones(train_num,1);
    Ytr = Ytr';
    Ytr = single(Ytr);


    Xte=test_feature(1:test_num,:);
    Xte = Xte';
    Xte = single(Xte);

    %% parameters
    T = 5000; % #iterations
    v = 0.05; % shrinkage factor
    J = 20; % #terminal nodes
    nodesize = 1; % node size. 1 is suggested

    nvar = size(Xtr,1);
    catmask = uint8( zeros(nvar,1) );
    %catmask = uint8([0,0,0,0]); % all features are NOT categorical data
                                % Currently only numerical data are supported:)
    %% train
    hboost = AOSOLogitBoost(); % handle
    hboost = train(hboost,...
      Xtr,Ytr,...
      'T', T,...
      'v', v,...
      'J',J,...
      'node_size',nodesize,...
      'var_cat_mask',catmask);
   %% predict
    F = predict(hboost, Xte);
    F_t = F';
    p = exp(F_t);
    sump = sum(p,2);
    result=zeros(test_num,testDataNum);
    for i=1:test_num
        result(i,:)=p(i,:)/sump(i,1);
    end
    %result
    foldresult(fold,1)=K_L_dist(test_data(1:test_num,:),result);
    foldresult(fold,2)=Euc_L2_dist(test_data(1:test_num,:),result);  
    foldresult(fold,3)=sorensen_dist(test_data(1:test_num,:),result);
    foldresult(fold,4)=Squared_X_dist(test_data(1:test_num,:),result);
    foldresult(fold,5)=Fidelity(test_data(1:test_num,:),result);
    foldresult(fold,6)=Intersection(test_data(1:test_num,:),result);
    foldresult
	[m1 n1] = max(test_data(1:test_num,:)');
    [m2 n2] = max(result');
	mae1 = sum(abs(n1-n2))/testNum;
    mae1
	mae2 = sum(abs(n2-test_age))/testNum;
    mae2
    
    evaluate(n2',test_age',test_val');

end