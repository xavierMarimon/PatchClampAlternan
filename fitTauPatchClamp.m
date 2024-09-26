function kineticParams=fitTauPatchClamp(time, current,  NaPeaksPos, tailPeaksPos, sweepChange)

%Add new value
sweepChange(31)=length(current);

%Create table
kineticParams=array2table(zeros(30,5));
%Add names into the variables of the table
kineticParams.Properties.VariableNames={'RsqrNa', 'RsqrTail', 'tau', 'tau1', 'tau2'}; 

% %Plot current
% figure(1);
% plot(time, current);
% hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Loop over all peaks
for k=1:1:length(tailPeaksPos)
    
    %---------------------------------------------------------------------%
    %Na Peaks
    %---------------------------------------------------------------------%
    %Acces each Na peak
    IpeakPosNa=NaPeaksPos(k);
    
    %Window
    winLeftNa=IpeakPosNa; %samples
    WinRightNa=sweepChange(k+1)-1301; %samples
    WinMeanNa=20; 
    
    %Compute signal ROI Na peaks
    sigroiNa=extractsigroi(current, [winLeftNa WinRightNa]);
    %y-data
    yNa=(sigroiNa{1, 1})';
    %x-data
    xNa=time(winLeftNa:WinRightNa);
    
    %Final point tail current 
    PosFinNa=length(xNa);

    %Stationary Na current 
    IssNa=mean(yNa((PosFinNa-WinMeanNa):PosFinNa));
    
%     figure(2);
%     plot(xNa,yNa);
%     refline([0 IssNa]);
  
    %---------------------------------------------------------------------%
    %Tail Peaks
    %---------------------------------------------------------------------%
    %Acces each tail peak
    IpeakPosTail=tailPeaksPos(k);
    
    %Window
    winLeftTail=IpeakPosTail; %samples
    WinRightTail=sweepChange(k+1); %samples
    WinMeanTail=10;
    
    %Compute signal ROI tail peaks
    sigroiTail=extractsigroi(current, [winLeftTail WinRightTail]);
    %y-data
    yTail=(sigroiTail{1, 1})';
    %x-data
    xTail=time(winLeftTail:WinRightTail);
    
    %Final point tail current 
    PosFinTail=length(xTail)-1;
    
    %Stationary tail current 
    IssTail=mean(yTail((PosFinTail-WinMeanTail):PosFinTail));
    
%     figure(3);
%     plot(xTail,yTail);
%     refline([0 IssTail]);
    
    %---------------------------------------------------------------------%
    % Fit tau from exponential function (Na signal)
    %---------------------------------------------------------------------%
    
    %Amplitude or span
    a0Na=IssNa-yNa(1);
    %Initial x-point
    b0Na=xNa(1);
    %Bottom
    c0Na=yNa(1);
    
    %Define exponential function model
    funNa=fittype(@(tau,x) a0Na*(1-exp(-(x-b0Na)/tau))+c0Na);

    %Guess values to start with
    GuessValNa=3;

    %Compute fit
    [fitmdlNa, gofNa]=fit(xNa', yNa', funNa, 'Start', GuessValNa, 'Lower', -Inf);

    %Goodness of fit (gofNa) 
    RsqrNa=gofNa.rsquare;
    
%      %Plot tail fit
% %      figure(4);
%      hfitTail=plot(fitmdlNa, xNa, yNa);
%      legend off;
%      %hfitTail(1).Marker='none';
%      hfitTail(2).Color=[0.6350 0.0780 0.1840];
%      hfitTail(2).LineWidth=3;
    
    %---------------------------------------------------------------------%
    % Fit tau from exponential function (Tail signal)
    %---------------------------------------------------------------------%

    %Amplitude or span
    a0Tail=IssTail-yTail(1);
    %Initial x-point
    b0Tail=xTail(1);
    %Bottom
    c0Tail=yTail(1);
    
    %Define exponential funNaction model
    %f(x)=PerCentFast*0.01*a*(1-exp(-(x-b)/tau1))+(100-PerCentFast)*0.01*a*(1-exp(-(x-b)/tau2))+c  
    funTail=fittype(@(PerCentFast, tau1, tau2, x) PerCentFast*0.01*a0Tail*(1-exp(-(x-b0Tail)/tau1))+(100-PerCentFast)*0.01*a0Tail*(1-exp(-(x-b0Tail)/tau2))+c0Tail);
    
    %Guess values to start with
    GuessValTail=[10, 3, 3];
    
    %Compute fit
    [fitmdlTail, gofTail]=fit(xTail', yTail', funTail, 'Start', GuessValTail, 'Lower', [4, eps, eps]);

    %Goodness of fit (gofTail) 
    RsqrTail=gofTail.rsquare;
    
%      %Plot tail fit
%      %figure(5);
%      hfitTail=plot(fitmdlTail, xTail, yTail);
%      legend off;
%      %hfitTail(1).Marker='none';
%      hfitTail(2).Color=[0.6350 0.0780 0.1840];
%      hfitTail(2).LineWidth=3;
    
    %---------------------------------------------------------------------%
    %Save fit features
    %---------------------------------------------------------------------%
    %Save Rsquare
    kineticParams.RsqrNa(k)=RsqrNa;
    kineticParams.RsqrTail(k)=RsqrTail;
    %Save taus
    kineticParams.tau(k)=fitmdlNa.tau;
    kineticParams.tau1(k)=fitmdlTail.tau1;
    kineticParams.tau2(k)=fitmdlTail.tau2;
    %Save xdataTail
    kineticParams.xNa{k}=xNa;
    kineticParams.xTail{k}=xTail;
    %Save ydataTail
    kineticParams.yNa{k}=yNa;
    kineticParams.yTail{k}=yTail;
    %Save fit model
    kineticParams.fitmdlNa{k}=fitmdlNa;
    kineticParams.fitmdlTail{k}=fitmdlTail;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end