
function [capPeaksPos, capPeaksVal, NaPeaksPos, NaPeaksVal, tailPeaksPos, tailPeaksVal]=peaksDetectPatchClamp(current, sweepChange)

%Numbers of sweeps
Nsweep=length(sweepChange);

%Positive peaks
[positivePksVal,positivePksPos]=findpeaks(current, 'MinPeakProminence', 0.01, 'MinPeakHeight', 0.1);
%Negative peaks
[negativePksVal,negativePksPos]=findpeaks(current.*-1,'MinPeakProminence', 0.035, 'MinPeakHeight', 0.055, 'MinPeakDistance', 63, 'MinPeakWidth', 2);
%Sign correction
negativePksVal=negativePksVal*-1;

%Combine all peaks position
combPksPos=[positivePksPos(:);negativePksPos(:)];
%Sort all peaks position
[allPeaksPos, sortIndx]=sort(combPksPos);

%Combine all peaks values
combPksVal=[positivePksVal(:);negativePksVal(:)];
%Sort all peaks values
allPeaksVal=combPksVal(sortIndx,:);

% figure(1);
% plot(time,current, 'Color', 'blue', 'LineWidth', 3);  
% hold on;
% scatter(allPeaksPos, allPeaksVal); 

delIndx=[];
%Loop over all sweeps
for i=1:Nsweep
    %Obtain the index peaks values under -45mv stimulation
    if i==30
        tmpIndx=find((allPeaksPos>sweepChange(i)).*(allPeaksPos<(length(current)-1700))==1);
    else
        tmpIndx=find((allPeaksPos>sweepChange(i)).*(allPeaksPos<(sweepChange(i+1)-1700))==1);
    end
    delIndx=[delIndx; tmpIndx];
end

%Delete peaks under -45mv stimulation
allPeaksPos(delIndx)=[];
allPeaksVal(delIndx)=[];

%Obtain capacitive peaks
capPeaksVal=allPeaksVal(1:3:end);
capPeaksPos=allPeaksPos(1:3:end);

%Obtain Na peaks
NaPeaksVal=allPeaksVal(2:3:end);
NaPeaksPos=allPeaksPos(2:3:end);

%Obtain tail peaks
tailPeaksVal=allPeaksVal(3:3:end);
tailPeaksPos=allPeaksPos(3:3:end);

end

