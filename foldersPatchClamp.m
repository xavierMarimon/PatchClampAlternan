
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% foldersPatchClamp.m %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-------------------------------------------------------------------------%
% Created by Xavier Marimon. 2020-2021. xavier.marimon@upc.edu
% This code is licensed under a Creative Commons License (CC).
%-------------------------------------------------------------------------%

function [outputPathImages,outputPathFeatures, outputPathStatistics]=foldersPatchClamp


%Define ouput images path
outputPathImages=[pwd filesep 'output' filesep 'images'];
%Define ouput path features
outputPathFeatures=[pwd filesep 'output' filesep 'features'];
%Define ouput path events
outputPathStatistics=[pwd filesep 'output' filesep 'statistics'];

%Create folder if not exist
createFolder=exist(outputPathImages);
if createFolder~=7
    %Create ouput folder
    mkdir(outputPathImages);
end

createFolder=exist(outputPathFeatures);
if createFolder~=7
    %Create ouput folder
    mkdir(outputPathFeatures);
end

createFolder=exist(outputPathStatistics);
if createFolder~=7
    %Create ouput folder
    mkdir(outputPathStatistics);
end

clear createFolder;

end