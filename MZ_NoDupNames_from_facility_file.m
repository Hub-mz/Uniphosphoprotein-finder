function [new_names,new_values,dup_names]=MM_eliminate_dup_names(A)
% Copyright 2019 MOMEI ZHOU, ARVIN LAB, STANFORD UNIVERSITY
% 1. The program make the protein names in a file unique, by adding [ * X ] for
%   the X-th duplicate
% 2. Parameters: A is a table

names=table2cell(A(:,1));
values=table2array(A(:,2:end));

data_type=class(values(1));
if(data_type(1)=='c')
    new_values=[];
    for(ii=1:size(values,1))
        a1=char(values{ii,1});
        a2=char(values{ii,2});
        a3=char(values{ii,3});
        if(length(a1)==0)
            a1='0'; a2='0'; a3='0';
        end;
        new_values=[new_values; [eval(a1) eval(a2) eval(a3)]];
    end;
elseif(data_type(1)=='d')
    new_values=values;
end;
for(ii=1:size(names,1))
    names{ii,1}=char(names{ii,1});
end;
[names,ind]=sortrows(names);
new_values=new_values(ind,:);


[names_unik,~,ind]=unique(names);
% Find duplicated names
flag=find(diff(ind)==0);
dup_names=names_unik(ind(flag));

% Make the protein names unique (eliminate duplicated names)
y=hist(ind,unique(ind))';

flag=[];
for(ii=2:length(names))
    if(strcmp(names{ii},names{ii-1})==1)
        flag=[flag; ii];
    end;
end;

new_names=[];
count=1;
for(ii=1:length(names_unik))
	new_names{count,1}=names_unik{ii};
    if(y(ii)>1)
        for(jj=2:y(ii))
            count=count+1;
            new_names{count,1}=[names_unik{ii} ' * ' num2str(jj)];
        end;
    end;
    count=count+1;
end;
        