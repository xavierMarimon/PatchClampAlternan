%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Statistics 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Create uniform signals index
Uidx=find(strcmp(tableFeatures.type,'U')==1);
Create alternant signals index
Aidx=find(strcmp(tableFeatures.type,'A')==1);

Acces all uniform tau features   
mtxAlltau_U=tableFeatures.tau(Uidx,1:end);
Rashape matrix to 1d column vector
Alltau_U=mtxAlltau_U(:);
Acces all alternant capPeakVal features   
mtxAlltau_A=tableFeatures.tau(Aidx,1:end);
Rashape matrix to 1d column vector
Alltau_A=mtxAlltau_A(:);

figure(200);
plot(tableFeatures.tau(2,:));
hold on;
plot(tableFeatures.tau(3,:));
legend('uniform', 'alternant');
title('tau');

figure(400);
plot(tableFeatures.tau1(2,:));
hold on;
plot(tableFeatures.tau1(3,:));
legend('uniform', 'alternant');
title('tau 1');

figure(300);
plot(tableFeatures.tau2(2,:));
hold on;
plot(tableFeatures.tau2(3,:));
legend('uniform', 'alternant');
title('tau 2');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Create uniform signals index
Uidx=find(strcmp(tableFeatures.type,'U')==1);
Create alternant signals index
Aidx=find(strcmp(tableFeatures.type,'A')==1);

Create type index
typeIdx=zeros(height(tableFeatures),1);
typeIdx(Uidx)=1;
typeIdx(Aidx)=2;

-------------------------------------------------------------------------%
Acces all uniform capPeakVal features   
mtxAllcapPeakVal_U=tableFeatures.capPeakVal(Uidx,1:end);
Rashape matrix to 1d column vector
AllcapPeakVal_U=mtxAllcapPeakVal_U(:);
Acces all alternant capPeakVal features   
mtxAllcapPeakVal_A=tableFeatures.capPeakVal(Aidx,1:end);
Rashape matrix to 1d column vector
AllcapPeakVal_A=mtxAllcapPeakVal_A(:);

Acces all uniform tailPeakVal features   
mtxAllTailPeakVal_U=tableFeatures.tailPeakVal(Uidx,1:end);
Rashape matrix to 1d column vector
AllTailPeakVal_U=mtxAllTailPeakVal_U(:);
Acces all alternant tailPeakVal features   
mtxAllTailPeakVal_A=tableFeatures.tailPeakVal(Aidx,1:end);
Rashape matrix to 1d column vector
AllTailPeakVal_A=mtxAllTailPeakVal_A(:);

-------------------------------------------------------------------------%
Acces all uniform diffcapPeakVal features   
mtxAlldiffcapPeakVal_U=tableFeatures.diffcapPeakVal(Uidx,1:end);
Rashape matrix to 1d column vector
AlldiffcapPeakVal_U=mtxAlldiffcapPeakVal_U(:);
Acces all alternant capPeakVal features   
mtxAlldiffcapPeakVal_A=tableFeatures.diffcapPeakVal(Aidx,1:end);
Rashape matrix to 1d column vector
AlldiffcapPeakVal_A=mtxAlldiffcapPeakVal_A(:);

Acces all uniform diffcapPeakVal features   
mtxAlldiffTailPeakVal_U=tableFeatures.diffTailPeakVal(Uidx,1:end);
Rashape matrix to 1d column vector
AlldiffTailPeakVal_U=mtxAlldiffTailPeakVal_U(:);
Acces all alternant capPeakVal features   
mtxAlldiffTailPeakVal_A=tableFeatures.diffTailPeakVal(Aidx,1:end);
Rashape matrix to 1d column vector
AlldiffTailPeakVal_A=mtxAlldiffTailPeakVal_A(:);

% Histogram

figure(1);
Histogram step peaks
subplot(1,2,1);
hold on;
h1=histogram(AllcapPeakVal_U);
h2=histogram(AllcapPeakVal_A);
hold off;
Histogram legend
legend([h1, h2], 'Uniform','Alternant');
Histogram labels
xlabel('Current [nA]');
ylabel('Count');
Histogram title
title('Amplitude step peaks');
grid on;

Histogram tail peaks
subplot(1,2,2);
hold on;
h1=histogram(AllTailPeakVal_U);
h2=histogram(AllTailPeakVal_A);
hold off;
Histogram legend
legend([h1, h2], 'Uniform','Alternant');
Histogram labels
xlabel('Current [nA]');
ylabel('Count');
Histogram title
title('Amplitude Tail peaks');
grid on;

figure(2);
Histogram step peaks
subplot(1,2,1);
hold on;
h1=histogram(AlldiffcapPeakVal_U);
h2=histogram(AlldiffcapPeakVal_A);
hold off;
Histogram legend
legend([h1, h2], 'Uniform','Alternant');
Histogram labels
xlabel('Current [nA]');
ylabel('Count');
Histogram title
title('Amplitude difference step peaks');
grid on;

Histogram tail peaks
subplot(1,2,2);
hold on;
h1=histogram(AlldiffTailPeakVal_U);
h2=histogram(AlldiffTailPeakVal_A);
hold off;
Histogram legend
legend([h1, h2], 'Uniform','Alternant');
Histogram labels
xlabel('Current [nA]');
ylabel('Count');
Histogram title
title('Amplitude difference Tail peaks');
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mean plots

Compute mean
mean_data=([mean(AllcapPeakVal_U);...
            mean(AllcapPeakVal_A)]); 

Compute std
std_data=([std(AllcapPeakVal_U);...
           std(AllcapPeakVal_A)]);      

Compute Standard Error of the Mean (SEM)
sem_high=([mean(AllcapPeakVal_U)+(std(AllcapPeakVal_U)/sqrt(length(AllcapPeakVal_U))),...
          mean(AllcapPeakVal_A)+(std(AllcapPeakVal_A)/sqrt(length(AllcapPeakVal_A)))]);      

sem_low=([mean(AllcapPeakVal_U)-(std(AllcapPeakVal_U)/sqrt(length(AllcapPeakVal_U))),...
          mean(AllcapPeakVal_A)-(std(AllcapPeakVal_A)/sqrt(length(AllcapPeakVal_A)))]);     

sem=([(std(AllcapPeakVal_U)/sqrt(length(AllcapPeakVal_U))),...
     (std(AllcapPeakVal_A)/sqrt(length(AllcapPeakVal_A)))]);  

Confidence Interval 95%
p=95; 
T-Score. Search in "Critical Values of t" table
N=length(AllcapPeakVal_U);
Tscore=tinv([abs([0,1]-(1-p/100)/2)],N-1);   

Confidence Interval (95%) CI = mean(x)+Tscore*SEM; 
CI_AllcapPeakVal_U=mean_data(1)+Tscore*sem(1);
CI_AllcapPeakVal_A=mean_data(2)+Tscore*sem(2);

Create group
g=[1*ones(length(AllcapPeakVal_U),1);  ...
  2*ones(length(AllcapPeakVal_A),1)];

% Compute p-values     

Create an empty pMatrix
pMatrix=NaN(length(mean_data), length(mean_data));     

% Bar plot   

figure(3);
subplot(1,2,1);
Bar plot
x=1:length(mean_data); 
bar(x,mean_data);

Errorbar (sem option)
er=errorbar(x,mean_data,sem,'LineStyle', 'none','MarkerSize', 1);  
Errorbar (std option)
er=errorbar(x,mean_data,std_data,'LineStyle', 'none','MarkerSize', 1);      

Labels
labels={'Uniform','Alternant'};

Labels
xlabel('Step peaks');
l=ylabel('Current [nA]');
niceplot();
set(gca,'XTickLabel',labels, 'LineWidth',0.5);
Plot title
title('Amplitude step peaks');
grid on;

=========================================================================%
% Compute mean
mean_data=([mean(AllTailPeakVal_U);...
            mean(AllTailPeakVal_A)]); 

Compute std
std_data=([std(AllTailPeakVal_U);...
           std(AllTailPeakVal_A)]);      

Compute Standard Error of the Mean (SEM)
sem_high=([mean(AllTailPeakVal_U)+(std(AllTailPeakVal_U)/sqrt(length(AllTailPeakVal_U))),...
          mean(AllTailPeakVal_A)+(std(AllTailPeakVal_A)/sqrt(length(AllTailPeakVal_A)))]);      

sem_low=([mean(AllTailPeakVal_U)-(std(AllTailPeakVal_U)/sqrt(length(AllTailPeakVal_U))),...
          mean(AllTailPeakVal_A)-(std(AllTailPeakVal_A)/sqrt(length(AllTailPeakVal_A)))]);     

sem=([(std(AllTailPeakVal_U)/sqrt(length(AllTailPeakVal_U))),...
     (std(AllTailPeakVal_A)/sqrt(length(AllTailPeakVal_A)))]);  

Confidence Interval 95%
p=95; 
T-Score. Search in "Critical Values of t" table
N=length(AllTailPeakVal_U);
Tscore=tinv([abs([0,1]-(1-p/100)/2)],N-1);   

Confidence Interval (95%) CI = mean(x)+Tscore*SEM; 
CI_AllTailPeakVal_U=mean_data(1)+Tscore*sem(1);
CI_AllTailPeakVal_A=mean_data(2)+Tscore*sem(2);

Create group
g=[1*ones(length(AllTailPeakVal_U),1);  ...
  2*ones(length(AllTailPeakVal_A),1)];

% Compute p-values     

Create an empty pMatrix
pMatrix=NaN(length(mean_data), length(mean_data));     

% Bar plot   

subplot(1,2,2);
Bar plot
x=1:length(mean_data); 
bar(x,mean_data);

Errorbar (sem option)
er=errorbar(x,mean_data,sem,'LineStyle', 'none','MarkerSize', 1);  
Errorbar (std option)
er=errorbar(x,mean_data,std_data,'LineStyle', 'none','MarkerSize', 1);      

Labels
labels={'Uniform','Alternant'};

Labels
xlabel('Tail peaks');
l=ylabel('Current [nA]');
niceplot();
set(gca,'XTickLabel',labels, 'LineWidth',0.5);
Plot title
title('Amplitude Tail peaks');
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mean plots

Compute mean
mean_data=([mean(AlldiffcapPeakVal_U);...
            mean(AlldiffcapPeakVal_A)]); 

Compute std
std_data=([std(AlldiffcapPeakVal_U);...
           std(AlldiffcapPeakVal_A)]);      

Compute Standard Error of the Mean (SEM)
sem_high=([mean(AlldiffcapPeakVal_U)+(std(AlldiffcapPeakVal_U)/sqrt(length(AlldiffcapPeakVal_U))),...
          mean(AlldiffcapPeakVal_A)+(std(AlldiffcapPeakVal_A)/sqrt(length(AlldiffcapPeakVal_A)))]);      

sem_low=([mean(AlldiffcapPeakVal_U)-(std(AlldiffcapPeakVal_U)/sqrt(length(AlldiffcapPeakVal_U))),...
          mean(AlldiffcapPeakVal_A)-(std(AlldiffcapPeakVal_A)/sqrt(length(AlldiffcapPeakVal_A)))]);     

sem=([(std(AlldiffcapPeakVal_U)/sqrt(length(AlldiffcapPeakVal_U))),...
     (std(AlldiffcapPeakVal_A)/sqrt(length(AlldiffcapPeakVal_A)))]);  

Confidence Interval 95%
p=95; 
T-Score. Search in "Critical Values of t" table
N=length(AlldiffcapPeakVal_U);
Tscore=tinv([abs([0,1]-(1-p/100)/2)],N-1);   

Confidence Interval (95%) CI = mean(x)+Tscore*SEM; 
CI_AlldiffcapPeakVal_U=mean_data(1)+Tscore*sem(1);
CI_AlldiffcapPeakVal_A=mean_data(2)+Tscore*sem(2);

Create group
g=[1*ones(length(AlldiffcapPeakVal_U),1);  ...
  2*ones(length(AlldiffcapPeakVal_A),1)];

% Compute p-values     

Create an empty pMatrix
pMatrix=NaN(length(mean_data), length(mean_data));     

% Bar plot   

figure(4);
subplot(1,2,1);
Bar plot
x=1:length(mean_data); 
bar(x,mean_data);

Errorbar (sem option)
er=errorbar(x,mean_data,sem,'LineStyle', 'none','MarkerSize', 1);  
Errorbar (std option)
er=errorbar(x,mean_data,std_data,'LineStyle', 'none','MarkerSize', 1);      

Labels
labels={'Uniform','Alternant'};

Labels
xlabel('Step peaks');
l=ylabel('Current [nA]');
niceplot();
set(gca,'XTickLabel',labels, 'LineWidth',0.5);
Plot title
title('Amplitude difference step peaks');
grid on;

=========================================================================%
% Compute mean
mean_data=([mean(AlldiffTailPeakVal_U);...
            mean(AlldiffTailPeakVal_A)]); 

Compute std
std_data=([std(AlldiffTailPeakVal_U);...
           std(AlldiffTailPeakVal_A)]);      

Compute Standard Error of the Mean (SEM)
sem_high=([mean(AlldiffTailPeakVal_U)+(std(AlldiffTailPeakVal_U)/sqrt(length(AlldiffTailPeakVal_U))),...
          mean(AlldiffTailPeakVal_A)+(std(AlldiffTailPeakVal_A)/sqrt(length(AlldiffTailPeakVal_A)))]);      

sem_low=([mean(AlldiffTailPeakVal_U)-(std(AlldiffTailPeakVal_U)/sqrt(length(AlldiffTailPeakVal_U))),...
          mean(AlldiffTailPeakVal_A)-(std(AlldiffTailPeakVal_A)/sqrt(length(AlldiffTailPeakVal_A)))]);     

sem=([(std(AlldiffTailPeakVal_U)/sqrt(length(AlldiffTailPeakVal_U))),...
     (std(AlldiffTailPeakVal_A)/sqrt(length(AlldiffTailPeakVal_A)))]);  

Confidence Interval 95%
p=95; 
T-Score. Search in "Critical Values of t" table
N=length(AlldiffTailPeakVal_U);
Tscore=tinv([abs([0,1]-(1-p/100)/2)],N-1);   

Confidence Interval (95%) CI = mean(x)+Tscore*SEM; 
CI_AlldiffTailPeakVal_U=mean_data(1)+Tscore*sem(1);
CI_AlldiffTailPeakVal_A=mean_data(2)+Tscore*sem(2);

Create group
g=[1*ones(length(AlldiffTailPeakVal_U),1);  ...
  2*ones(length(AlldiffTailPeakVal_A),1)];

% Compute p-values     

Create an empty pMatrix
pMatrix=NaN(length(mean_data), length(mean_data));     

% Bar plot   

subplot(1,2,2);
Bar plot
x=1:length(mean_data); 
bar(x,mean_data);

Errorbar (sem option)
er=errorbar(x,mean_data,sem,'LineStyle', 'none','MarkerSize', 1);  
Errorbar (std option)
er=errorbar(x,mean_data,std_data,'LineStyle', 'none','MarkerSize', 1);      

Labels
labels={'Uniform','Alternant'};

Labels
xlabel('Tail peaks');
l=ylabel('Current [nA]');
niceplot();
set(gca,'XTickLabel',labels, 'LineWidth',0.5);
Plot title
title('Amplitude difference tail peaks');
grid on;


