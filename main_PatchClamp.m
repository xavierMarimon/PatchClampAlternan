
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% main_PatchClamp.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialize
% close all;
% clear all;
% clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Input parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Define dataset file path
DatasetFolderPath='C:\Datasets\Dataset Patch Clamp\mat files';

%Current folder
currentFilePath=pwd;

%Change folder
cd(DatasetFolderPath);

%List folder contents
files=dir('*.mat');
files([files.isdir])=[]; 

%Change folder
cd(currentFilePath);

%Number of files
Nfiles=length(files);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Output folders
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Create output folders
[outputPathImages,outputPathFeatures, outputPathStatistics]=foldersPatchClamp;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Main processing loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
for i=1:1:Nfiles    

%Display file    
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% File ' num2str(i) ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']); 

%Create filename     
filename=[DatasetFolderPath filesep files(i).name];

%-------------------------------------------------------------------------%
%load data
load(filename);

%-------------------------------------------------------------------------%
%Round voltage
voltage=roundVoltagePatchClamp(voltage);

%-------------------------------------------------------------------------%
%Smooth data
current=smoothdata(current,'movmean','SmoothingFactor',0.02);

%-------------------------------------------------------------------------%
%Numbers of sweeps
Nsweep=length(sweepChange);

%Nsamples
Nsamples=length(voltage);

%-------------------------------------------------------------------------%
%Obtain experiment information
[expName, type]=expInfoPatchClamp(filename);

%-------------------------------------------------------------------------%
%Compute peaks
[capPeaksPos, capPeaksVal, ...
NaPeaksPos, NaPeaksVal, ...
tailPeaksPos, tailPeaksVal]=peaksDetectPatchClamp(current, sweepChange);

%-------------------------------------------------------------------------%
%Area
areaParams=areaPatchClamp(time, current, capPeaksPos, NaPeaksPos, tailPeaksPos, sweepChange);

%Compute kinetic parameters
kineticParams=fitTauPatchClamp(time, current,  NaPeaksPos, tailPeaksPos, sweepChange);

%Obtain size
[Nframes, Nblocks]=size(Fnorm);

%Initialize
transientParams_kBlock=cell(Nblocks,1);
transientFeatures_kBlock{kBlock, 1}

Create features matrix
F1{i,:}=expName;
F2{i,:}=type;
F3(i,:)=capPeaksVal';
F4(i,:)=NaPeaksVal';
F5(i,:)=tailPeaksVal';
F6(i,:)=kineticParams.tau';
F7(i,:)=kineticParams.tau1';
F8(i,:)=kineticParams.tau2';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plots
%Plot signals
%run figure_sigPatchClamp.m;

%-------------------------------------------------------------------------%
%Plot area
figure(1);
%Plot area Na
subplot(1,2,1);
hold on;
%Check if is uniform(U)
if  strcmp(type, 'U')
    plot(areaParams.QNa, 'b','LineWidth', 2); 
else
   plot(areaParams.QNa, 'r','LineWidth', 2); 
end
%Plot title
title('Area Na');

%Plot area tail
subplot(1,2,2);
hold on;
%Check if is uniform(U)
if  strcmp(type, 'U')
    plot(areaParams.QTail, 'b','LineWidth', 2); 
else
   plot(areaParams.QTail, 'r','LineWidth', 2); 
end 
%Plot title
title('Area tail');

%-------------------------------------------------------------------------%
%Plot taus

figure(2);
%Plot tau 1
subplot(1,2,1);
hold on;
%Check if is uniform(U)
if  strcmp(type, 'U')
    plot(kineticParams.tau, 'b','LineWidth', 2); 
else
   plot(kineticParams.tau, 'r','LineWidth', 2); 
end
%Plot title
title('tau');

%Plot tau 2
subplot(1,2,2);
hold on;
%Check if is uniform(U)
if  strcmp(type, 'U')
    plot(kineticParams.tau2, 'b','LineWidth', 2); 
else
   plot(kineticParams.tau2, 'r','LineWidth', 2); 
end 
%Plot title
title('tau 2');

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create table of features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Create feature table
tableFeatures=table(F2, F3, F4, F5, F6, F7, F8);
%Add names into the variables of the table
tableFeatures.Properties.VariableNames=...
{'type','capPeaksVal','NaPeaksVal','tailPeaksVal', 'tau','tau1','tau2'};
%Add rownames
tableFeatures.Properties.RowNames=F1;
  
%Clear variables
clearvars F1 F2 F3 F4 F5 F6 F7 F8 i k filename;

%Create feature matrix
mtxFeatures=table2array(tableFeatures(:,3:7));
