clc
clear
close all;


s_metric = "M_NCD";

fit_limit_param = readtable("Fit_limit_param.csv");

dataset = readtable("HuID_wikiartDataset_InfoAest_DEF_v2.csv");
dataset_AI = dataset(dataset.true_label=="AI",:);
dataset_H = dataset(dataset.true_label=="H",:);

metricH = dataset_H.(s_metric);
metricAI = dataset_AI.(s_metric);
 
binEdges = linspace(min([metricAI;metricH]),max([metricAI;metricH]),51);

[binCountH,~] = histcounts(metricH,binEdges);
[binCountAI,~] = histcounts(metricAI,binEdges);

binCenter = (binEdges(1:end-1) + binEdges(2:end)) / 2;
 
% low_lim = [-inf 0 -inf];
% up_lim = [ 0.5 1];

low_lim = fit_limit_param.(s_metric)(1:3);
up_lim =  fit_limit_param.(s_metric)(4:6);

fit_H = fit(binCenter',binCountH','gauss1','Lower', low_lim ,'Upper', up_lim);%,'StartPoint',[7.9 0.35 0.2 2 0.75 0.1]);
fit_AI = fit(binCenter',binCountAI','gauss1','Lower', low_lim,'Upper', up_lim);%,'StartPoint',[7.9 0.35 0.2 2 0.75 0.1]);

%fit_limit_param.(s_metric) = [low_lim up_lim]'; 
figure
histogram(metricAI,binEdges);
hold on
histogram(metricH,binEdges);
plot(fit_AI,'b');%,binCenter,binCountH);
plot(fit_H,'r');

ax = gca;
ax.FontSize = 16;

ylabel("Occurences")
xlabel("M_{P,RGB}")
lgd = legend('AI pdf','H pdf','AI Fit','H Fit');
lgd.FontSize = 16;
%title(strcat(s_metric," - ","Distribution and Gaussian Fitting"))
hold off




T_p = sum(fit_AI(metricAI) > fit_H(metricAI));
F_n = sum(fit_AI(metricAI) < fit_H(metricAI));
T_n = sum(fit_H(metricH) > fit_AI(metricH));
F_p = sum(fit_H(metricH) < fit_AI(metricH));

C_M = [T_p F_n; T_n F_p];
 
figure
cm = confusionchart(C_M,["AI","Human"], ...
    'ColumnSummary','column-normalized', ...
    'RowSummary','row-normalized');

cm.Normalization = 'row-normalized';
sortClasses(cm,'descending-diagonal');
cm.Normalization = 'absolute';
title(strcat(s_metric," - Confusion Matrix"))

Acc = (T_p+T_n)/size(dataset.true_label,1);

P = T_p/(T_p+F_p);

R = T_p/(T_p+F_n);

F1 = 2*P*R/(P+R);

%writetable(fit_limit_param, 'Fit_limit_param.csv');

disp(strcat("Precision: ",string(P)));
disp(strcat("Recall: ",string(R)));
disp(strcat("F-score: ",string(F1)));
disp(strcat("Accuracy: ",string(Acc),"%"));

disp(mean(metricH));
disp(mean(metricAI));
disp(std(metricH));
disp(std(metricAI));

