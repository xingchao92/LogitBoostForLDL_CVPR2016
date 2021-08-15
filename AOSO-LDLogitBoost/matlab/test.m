%% prepare train/testdata
Xtr = [...
  0.1, 0.2;
  0.2, 0.3;
  0.6, 0.3;
  0.7, 0.2;
  0.1, 0.4;
  0.2, 0.6...
 ];
Xtr = Xtr';
Xtr = single(Xtr);
% Xtr should be 2X6, single

Ytr = [...
  1.0;
  1.0;
  2.0;
  2.0;
  3.0;
  3.0;
];
Ytr = Ytr';
Ytr = single(Ytr);
% Ytr should be 1X6,single
% K = 3 classes(0,1,2)

Xte = [...
  0.1, 0.2;
  0.6, 0.3;
  0.2, 0.6...
];
Xte = Xte';
Xte = single(Xte);

test_num=3;
test_data=[1 0 0;0 1 0;0 0 1];

%% parameters
T = 100; % #iterations
v = 0.1; % shrinkage factor
J = 4; % #terminal nodes
nodesize = 1; % node size. 1 is suggested
catmask = uint8([0,0,0,0]); % all features are NOT categorical data
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
for i=1:test_num
    result(i,:)=p(i,:)/sump(i,1);
end
result
dist(1,:)=K_L_dist(test_data(1:test_num,:),result);
dist(2,:)=Euc_L2_dist(test_data(1:test_num,:),result);  
dist(3,:)=sorensen_dist(test_data(1:test_num,:),result);
dist(4,:)=Squared_X_dist(test_data(1:test_num,:),result);
dist(5,:)=Fidelity(test_data(1:test_num,:),result);
dist(6,:)=Intersection(test_data(1:test_num,:),result);
dist
%% error and error rate
% [~,yy] = max(F);
% yy = yy - 1; % index should be 0-base
% err_rate = sum(yy~=Yte)/length(Yte)