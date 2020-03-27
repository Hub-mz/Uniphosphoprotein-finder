% Copyright 2019 MOMEI ZHOU, ARVIN LAB, STANFORD UNIVERSITY

clear; clc;
close all;
file_path=pwd;
file_name{1}='20191004_MZhou_seedgrant_10187_ZrIMAC_std_enriched_DMSO1.raw_20191007_Byonic (1)';
file_name{2}='20191004_MZhou_seedgrant_10187_ZrIMAC_std_enriched_DMSO2.raw_20191007_Byonic (1)';
file_name{3}='20191004_MZhou_seedgrant_10187_ZrIMAC_std_enriched_DMSO3.raw_20191007_Byonic (1)';
file_name{4}='20191004_MZhou_seedgrant_10187_ZrIMAC_std_enriched_Pim1.raw_20191008_Byonic (1)';
file_name{5}='20191004_MZhou_seedgrant_10187_ZrIMAC_std_enriched_Pim2.raw_20191008_Byonic (1)';
file_name{6}='20191004_MZhou_seedgrant_10187_ZrIMAC_std_enriched_Pim3.raw_20191008_Byonic (1)';

cd(file_path);

all_names_raw=[];
all_values_raw=[];
come_from=[];
dup_names=[];
dup_names_from=[];

for(ii=1:length(file_name))
    file_name{ii}=[file_name{ii} '.xlsx'];
    if(ii==1)
        opts=detectImportOptions([file_name{ii}]);
        opts.DataRange='A2';
    end;
    AA=readtable(file_name{ii},opts,'Sheet','Proteins');
    
    A=AA(:,[2 7 8 9]);

    % Remove the data whose name begin with ">Reverse"
    REV=[];
    for(jj=1:size(A,1))
        a=char(A{jj,1});
        flag=find(a=='R');
        if(length(flag)>0)
            if(flag(1)==2)
                REV=[REV jj];
            end;
        end;
    end;
    A(REV,:)=[];
    % End
    
    for(jj=1:size(A,1))
        a=char(A{jj,1});
        flag=find(a=='|');
        A{jj,1}=textscan(a([flag(1)+1:flag(2)-1]),'%s');
    end;
    [NN,NV,DN]=MM_NoDupNames_from_facility_file(A);
    % NN: New names
    % NV: New values
    % DN: duplicated names
    all_names_raw=[all_names_raw; NN];
    all_values_raw=[all_values_raw; NV];
    come_from=[come_from; ii*ones(size(A,1),1)];
    dup_names=[dup_names; DN];
    dup_names_from=[dup_names_from; ii*ones(size(DN,1),1)];
end;

[new_names2,ind]=sortrows(all_names_raw);
new_values2=all_values_raw(ind,:);
come_from2=come_from(ind);

[unik_names,~,ind]=unique(new_names2);
y=hist(ind,unique(ind))';

new_names3=unik_names;
new_values3=-100*ones(length(y),3*length(file_name));
count=1;
for(ii=1:length(y))
    for(jj=1:y(ii))
        new_values3(ii,[-2:0]+3*come_from2(count))=new_values2(count,:);
        count=count+1;
    end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write data to Excel file
save_file_name=[input('File name for saving a new file? (Make sure you close the file first, before over-writing it)  ','s') '.xlsx'];

protein=new_names3;
writetable(table(protein),save_file_name,'Sheet',1);

% Format column names
all_col = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
for(ii=1:length(file_name))
    a=file_name{ii};
    ind1=find(a=='_');
    ind2=find(a=='.');
    ind1=ind1(max(find(ind1<ind2(1))))+1;
    ind2=ind2(1)-1;
    data1=[a(ind1:ind2) '_spectra'];
    data2=[a(ind1:ind2) '_unique_peptides'];
    data3=[a(ind1:ind2) '_mod_peptides'];
    eval([data1 '=new_values3(:,3*ii-2);']);
    eval([data2 '=new_values3(:,3*ii-1);']);
    eval([data3 '=new_values3(:,3*ii);']);
    
    F=eval(['table(' data1 ')']);
    writetable(F,save_file_name,'Sheet',1,'Range',[all_col(3*ii-2+1) '1']);
    F=eval(['table(' data2 ')']);
    writetable(F,save_file_name,'Sheet',1,'Range',[all_col(3*ii-2+2) '1']);
    F=eval(['table(' data3 ')']);
    writetable(F,save_file_name,'Sheet',1,'Range',[all_col(3*ii-2+3) '1']);
end;