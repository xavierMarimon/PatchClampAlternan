function [expName, type]=expInfoPatchClamp(filename)

%String split
C=strsplit(filename,'_');
CC=C(end);
CCC=strsplit(CC{1, 1},'.');
%Experiment type: Uniform  (U) or Alternat (A)
type=CCC{1, 1};

%Create experiment name
splitText=strsplit(filename,filesep);
expName=strrep(splitText{end},'.mat',char( [ ] ));

end