
%% Initialize
clear all;
clc;
close all;

%Current folder
currentFilePath=pwd;

%Change folder
dataFilePath='D:\Datasets\Dataset Patch Clamp\mat files';
cd(dataFilePath);


%List folder contents
files=dir('*.mat');
files([files.isdir])=[]; 

%Change folder
cd(currentFilePath);

%Number of files
Nfiles=length(files);

%% Load data

figure(1); 

%Loop over all files
for i=17:21%1:Nfiles    
    
i    
    
%Create filename     
filename=[dataFilePath filesep files(i).name];
   
filename

%load data
load(filename);

%Numbers of sweeps
Nsweep=length(sweepChange);

%Nsamples
Nsamples=length(voltage);

%String split
C=strsplit(filename,'_');
CC=C(end);
CCC=strsplit(CC{1, 1},'.');
type=CCC{1, 1};

%Voltage plot
ax1 = subplot(2,1,1);
hold on;
%Check if is uniform
if strcmp(type,'U')
   plot(time,voltage, 'b'); 
else
   plot(time,voltage, 'r'); 
end   
if i==1
   vertlinePatchClamp(voltage, sweepChange);
end
hold off;
title(['file' num2str(i)]);
%Plot labels
ylabel('Voltage [mV]');
xlabel('time [samples]');
%Plot limits
xlim([0 1500]);

%Current plot
ax2 =  subplot(2,1,2);
hold on;
%Check if is uniform
if strcmp(type,'U')
   plot(time,current, 'b');   
else
   plot(time,current, 'r');
end
if i==1
   vertlinePatchClamp(current, sweepChange);
end
%Plot labels
ylabel('Current [nA]');
xlabel('time [samples]');
%Plot limits
xlim([0 1500]);
%linkaxes([ax1,ax2],'x');

end

