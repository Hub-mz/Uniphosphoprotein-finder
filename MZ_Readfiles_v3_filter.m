% Copyright 2019 MOMEI ZHOU, ARVIN LAB, STANFORD UNIVERSITY
clear; clc;
close all;

[FileName,PathName,FilterIndex] = uigetfile('.xlsx');
A=readtable([PathName FileName]);
names=table2cell(A(:,1));
values=table2array(A(:,2:end));

B=values(:,1:9)==-100*ones(1,9);
flag=find(all(B,2)==1);

names_filtered_1=names(flag,:);
values_filtered_1=values(flag,:);
B=values_filtered_1(:,10:18)>0;
flag=find(all(B,2)==1);

names_filtered_2=names_filtered_1(flag,:);
values_filtered_2=values_filtered_1(flag,:);

B=table(names_filtered_2,values_filtered_2);
openvar B;