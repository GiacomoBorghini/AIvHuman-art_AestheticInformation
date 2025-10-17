clc
clear 
close all

sorted_metric = [5,3];%,1,6,2,4];
sorted_metric_str = ["M_{NCD}","M_K","M_{P,L}","M_H","M_J","M_{P,RGB}"];
dataset = readtable("HuID_wikiartDataset_InfoAest_DEF_v2.csv");

fid = fopen("ACCvCOMPL_results.csv",'a');
NumTestSets = 100;

sorted_metric_array = strings(1, length(sorted_metric) - 1);

for m_idx=2:length(sorted_metric)

    sel_metric = sorted_metric(1:m_idx);

    sorted_metric_array(m_idx-1) = strjoin(sorted_metric_str(1:m_idx),'/ ');

    acc = class_accuracy(sel_metric,NumTestSets,dataset);
    
    fprintf(fid,'%f,',acc);
    

end
fprintf(fid,'\n');

save("ACC.mat","sorted_metric_array");

sorted_metric = [6,3,2,1,4,5];
sorted_metric_str = ["M_{P,L}","M_J","M_K","M_H","M_{NCD}","M_{P,RGB}"];

for m_idx=2:length(sorted_metric)

    sel_metric = sorted_metric(1:m_idx);

    sorted_metric_array(m_idx-1) = strjoin(sorted_metric_str(1:m_idx),'/ ');

    acc = class_accuracy(sel_metric,NumTestSets,dataset);
    
    fprintf(fid,'%f,',acc);
    

end

fprintf(fid,'\n');

save("COMPL.mat","sorted_metric_array");

fclose(fid);