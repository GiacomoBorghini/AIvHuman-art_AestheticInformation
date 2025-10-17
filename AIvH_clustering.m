clc
clear
close all;

dataset_raw = readtable("HuID_wikiartDataset_InfoAest_DEF.csv");
sel_metrics = [1,2,3,4,5,6];

size_array = dataset_raw.Size; 
min_s = min(size_array);
max_s = max(size_array);
norm_size = (size_array-min_s)./(max_s-min_s);
dataset_raw.Size = norm_size;


dataset_H = dataset_raw(string(dataset_raw.true_label) == 'H',:);
dataset_AI = dataset_raw(string(dataset_raw.true_label) == 'AI',:);

test_metricValues = [dataset_H{:, sel_metrics};dataset_AI{:, sel_metrics}];

test_setAll = [dataset_H;dataset_AI];

test_label = string([test_setAll{:,"true_label"}]);




[clust_label,C] = kmeans(test_metricValues,2,'Distance','cityblock','Replicates',20);

clust_label_str = cell(size(clust_label)); % Inizializzazione cell array


test_label_num = zeros(size(test_label,1),1);

test_label_num(strcmp(test_label, 'AI')) = 2; 
test_label_num(strcmp(test_label, 'H')) = 1;

C_M = confusionmat(test_label_num,clust_label);



figure

cm = confusionchart(C_M,["Human","AI"], ...
    'ColumnSummary','column-normalized', ...
    'RowSummary','row-normalized');

cm.Normalization = 'row-normalized';
sortClasses(cm,'descending-diagonal');
cm.Normalization = 'absolute';

T_p = C_M(1,1); %true positive
F_p = C_M(2,1); %false positive
F_n = C_M(1,2); %false negative
T_n = C_M(2,2); %true negatives

%compute precision

P = T_p/(T_p+F_p);

%compute recall

R = T_p/(T_p+F_n);

%compute F-score

F1 = 2*P*R/(P+R);

disp(strcat("Precision: ",string(P)));
disp(strcat("Recall: ",string(R)));
disp(strcat("F-score: ",string(F1)));
disp(strcat("Accuracy: ",string((T_p+T_n)/size(dataset_raw,1)*100),"%"));

