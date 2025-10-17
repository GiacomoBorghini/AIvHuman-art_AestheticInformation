clc
clear
close all;

rng(0)

sel_metrics =1:6;
dataset = readtable("HuID_wikiartDataset_InfoAest_DEF_v2.csv");

NumTestSets = 100;

for i = 1:NumTestSets

    c = cvpartition(height(dataset), 'HoldOut', 0.1); 
    trainIdx = c.training;
    testIdx = c.test;

    train_set = dataset(trainIdx, :);
    test_set = dataset(testIdx, :);

    train_true_labels = train_set.true_label;
    test_true_labels = test_set.true_label;


    SVM_Model_val = fitcsvm(train_set(:,sel_metrics), train_true_labels,...
        'Standardize',true, 'KernelFunction', 'gaussian','KernelScale', 'auto','KFold',5);

    train_pred_labels = kfoldPredict(SVM_Model_val);

    %derive the confusion matrix C_M of the i-th validated model
    trainC_M = confusionmat(train_true_labels,train_pred_labels);
   
    trainT_p(i) = trainC_M(1,1); %true positive
    trainF_p(i) = trainC_M(2,1); %false positive
    trainF_n(i) = trainC_M(1,2); %false negative
    trainT_n(i) = trainC_M(2,2); %true negatives

    %compute precision of i-th training set validation

    trainP(i) = trainT_p(i)/(trainT_p(i)+trainF_p(i));

    %compute recall of i-th training set validation

    trainR(i) = trainT_p(i)/(trainT_p(i)+trainF_n(i));

    %compute F-score of i-th training set validation

    trainF1(i) = 2*trainP(i)*trainR(i)/(trainP(i)+trainR(i));

    %compute accuracy of i-th training set validation

    trainAcc(i) = (trainT_p(i)+trainT_n(i))/size(train_true_labels,1);

    %test the trained model with the i-th test set
    
    SVM_Model = fitcsvm(train_set(:,sel_metrics), train_true_labels,...
        'Standardize',true, 'KernelFunction', 'gaussian', 'KernelScale', 'auto');


    [test_pred_labels, score] = predict(SVM_Model, test_set(:,sel_metrics));
    %derive the confusion matrix C_M of the i-th test set
    testC_M = confusionmat(test_true_labels,test_pred_labels);

    testT_p(i) = testC_M(1,1); %true positive
    testF_p(i) = testC_M(2,1); %false positive
    testF_n(i) = testC_M(1,2); %false negative
    testT_n(i) = testC_M(2,2); %true negatives

    %compute precision of i-th test set 

    testP(i) = testT_p(i)/(testT_p(i)+testF_p(i));

    %compute recall of i-th test set 

    testR(i) = testT_p(i)/(testT_p(i)+testF_n(i));

    %compute F-score of i-th test set 

    testF1(i) = 2*testP(i)*testR(i)/(testP(i)+testR(i));
    
    %compute accuracy of i-th test set

    testAcc(i) = (testT_p(i)+testT_n(i))/size(test_true_labels,1);


end



disp("TRAINING RESULTS:")
disp(strcat("Accuracy (mean): ",string(mean(trainAcc))," Accuracy (std:) ",string(std(trainAcc))));
disp(strcat("Precision (mean): ",string(mean(trainP))," Precision (std:) ",string(std(trainP))));
disp(strcat("Recall (mean): ",string(mean(trainR))," Recall (std:) ",string(std(trainR))));
disp(strcat("F-score (mean): ",string(mean(trainF1))," F-score (std:) ",string(std(trainF1))));

disp("TEST RESULTS:")
disp(strcat("Accuracy (mean): ",string(mean(testAcc))," Accuracy (std:) ",string(std(testAcc))));
disp(strcat("Precision (mean): ",string(mean(testP))," Precision (std:) ",string(std(testP))));
disp(strcat("Recall (mean): ",string(mean(testR))," Recall (std:) ",string(std(testR))));
disp(strcat("F-score (mean): ",string(mean(testF1))," F-score (std:) ",string(std(testF1))));

T_p = round(mean(testT_p));
T_n = round(mean(testT_n));
F_n = round(mean(testF_n));
F_p = round(mean(testF_p));

C_M = [T_p,F_n;F_p,T_n];


figure

cm = confusionchart(C_M,["Human","AI"], ...
    'ColumnSummary','column-normalized', ...
    'RowSummary','row-normalized');

cm.Normalization = 'row-normalized';
sortClasses(cm,'descending-diagonal');
cm.Normalization = 'absolute';