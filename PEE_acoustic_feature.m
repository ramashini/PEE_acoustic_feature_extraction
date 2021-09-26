clc;
clear;
close all;
list = dir ('path of the audio file\*.wav');
endianness='l';
fs=16000;
datatype='int16';
for i = 1 : length(list)
    filename=list(i).name;
    fid_R = fopen(filename,'r',endianness);
    signal = fread(fid_R,'int16'); % Raw data of input audio file. 
    fclose(fid_R);   
    %% Normalization
    ampMax = 1;ampMin = -1;
    sample = audioNormalization(signal, ampMax);
    %% Quantization
    partition = (-1:.1:1);
    codebook = (-1.1:.1:1);
    [partition2,codebook2] = lloyds(sample,codebook);
    [index,quants] = quantiz(sample,partition2,codebook2);
    %% count number of occurance
    x = unique(index);
    N = numel(x);
    count = zeros(N,1);
    for k = 1:N
        count(k) = sum(index==x(k));
    end
%     disp([ x(:) count ]);
    %% probability calculation 
    for k = 1:N
          prob(k) = (count(k))/sum(count);
    end
%        disp(prob');
    %% entropy calculation
    H = entropy(prob);
    %% writing to excel
    cellReference = sprintf('A%d', i);
    xlswrite('path for the xlswrite\test_entropy.xlsx',H', 'Sheet1', cellReference)
end 
