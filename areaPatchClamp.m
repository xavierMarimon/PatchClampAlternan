
function areaParams=areaPatchClamp(time, current, capPeaksPos, NaPeaksPos, tailPeaksPos, sweepChange)

%Add new value
sweepChange(31)=length(current);

%Create table
areaParams=array2table(zeros(30,6));
%Add names into the variables of the table
areaParams.Properties.VariableNames={'QNa', 'QTail', 'IprevNa', 'IprevTail', ...
                                       'IssNa', 'IssTail'}; 
% %Plot current
% figure(1);
% plot(time, current);
% hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Loop over all peaks
for k=1:1:length(tailPeaksPos) 
    
    %---------------------------------------------------------------------%
    %Capacitive Peaks
    %---------------------------------------------------------------------%
    %Acces each Cap peak
    IpeakPosCap=capPeaksPos(k);

    %Window
    winLeftCap=IpeakPosCap-30; %samples
    WinRightCap=NaPeaksPos(k); %samples
    WinMeanCap=15;
    
    %Compute sigCapl ROI Cap peaks
    sigroiCap=extractsigroi(current, [winLeftCap WinRightCap]);
    %y-data
    yCap=(sigroiCap{1, 1})';
    %x-data
    xCap=time(winLeftCap:WinRightCap);

    %Initial point Capacitive current 
    [~,PosIniCap]=findpeaks(diff(yCap), 'MinPeakHeight', 0.099, 'NPeaks',1);
    
    %Previous Cap current 
    IprevCap=mean(yCap((PosIniCap-WinMeanCap):PosIniCap));

%     figure(2);
%     plot(xCap,yCap);
%     refline([0 IprevCap]);

    %---------------------------------------------------------------------%
    %Na Peaks
    %---------------------------------------------------------------------%
    %Acces each Cap peak
    IpeakPosCap=capPeaksPos(k);
    %Acces each Na peak
    IpeakPosNa=NaPeaksPos(k);
    
    %Window
    winLeftNa=IpeakPosCap; %samples
    WinRightNa=sweepChange(k+1)-1301; %samples
    WinMeanNa=20; 
    
    %Compute signal ROI Na peaks
    sigroiNa=extractsigroi(current, [winLeftNa WinRightNa]);
    %y-data
    yroiNa=(sigroiNa{1, 1})';
    %x-data
    xroiNa=time(winLeftNa:WinRightNa);

%     figure(5);
%     plot(xroiNa,yroiNa);

    %Final point tail current 
    PosFinNa=length(xroiNa);

    %Previous Na current
    IprevNa=IprevCap;
    %Stationary Na current 
    IssNa=mean(yroiNa((PosFinNa-WinMeanNa):PosFinNa));

    %Find position  yNa>=IssNa  
    r=(yroiNa>=IssNa);
    Ind=find(r==0);
    %Initial point Na current
    PosIniNa=Ind(1)-1;

    %Adjust limits
    xNa=xroiNa(PosIniNa:PosFinNa);
    yNa=yroiNa(PosIniNa:PosFinNa);
    
%     figure(6);
%     plot(xNa,yNa);
%     refline([0 IssNa]);

    %Compute area 
    QNa=abs(trapz(xNa,yNa-IssNa)); 
    
    %figure(7);
    %hold on;
    %Plot area
    yNaNeg=yNa;
    yNaNeg(yNaNeg>=IssNa)=nan;
%     NaFaceColor='green';
%     NaEdgeColor='none';
%     NaFaceAlpha=0.6;
    %areafill(xNa,yNa, IssNa*ones(size(xNa)),NaFaceColor,NaEdgeColor,0,NaFaceAlpha);
    %Plot Na current
    %plot(xNa,yNa, 'Color', [0 0.4470 0.7410], 'LineWidth', 3);
    %Iss Na line
%     hline2Na=refline([0 IssNa]);
%     hline2Na.Color='m';
%     hline2Na.LineWidth=2;

    %---------------------------------------------------------------------%
    %Tail Peaks
    %---------------------------------------------------------------------%
    %Acces each tail peak
    IpeakPosTail=tailPeaksPos(k);
 
    %Window
    winLeftTail=IpeakPosTail-50; %samples
    WinRightTail=sweepChange(k+1); %samples
    WinMeanTail=10;
    
    %Compute signal ROI tail peaks
    sigroiTail=extractsigroi(current, [winLeftTail WinRightTail]);
    %y-data
    yroiTail=(sigroiTail{1, 1})';
    %x-data
    xroiTail=time(winLeftTail:WinRightTail);
    
%     figure(3);
%     plot(xroiTail,yroiTail);
    
    %Initial point tail current 
    [~,PosIniTail0]=findpeaks(diff(yroiTail*-1), 'MinPeakHeight', 0.1, 'NPeaks',1);
    PosIniTail=PosIniTail0-1;
    %Final point tail current 
    PosFinTail=length(xroiTail)-1;

    %Previous tail current 
    IprevTail=mean(yroiTail((PosIniTail-WinMeanTail):PosIniTail));
    %Stationary tail current 
    IssTail=mean(yroiTail((PosFinTail-WinMeanTail):PosFinTail));
    
    %Adjust limits
    xTail=xroiTail(PosIniTail:PosFinTail);
    yTail=yroiTail(PosIniTail:PosFinTail);
    
%     figure(4);
%     plot(xTail,yTail);
%     refline([0 IssTail]);
    
    %Compute area 
    QTail=abs(trapz(xTail,yTail-IssTail));

%     %Compute area (alternative method)     
%     %Total area
%     Atotal=abs(trapz(xTail,yTail));     
%     %Rectangle area
%     b=PosFinTail-PosIniTail;
%     h=abs(IssTail-0);
%     Arect=b*h; 
%     %Tail transient area
%     QTail=Atotal-Arect

    %figure(4);
    %hold on;
    %Plot area
%     yTailNeg=yTail;
%     yTailNeg(yTailNeg>IssTail)=nan;
%     TailFaceColor='yellow';
%     TailEdgeColor='none';
%     TailFaceAlpha=0.6;
%     areafill(xTail,yTail, IssTail*ones(size(xTail)),TailFaceColor,TailEdgeColor,0,TailFaceAlpha);
%     %Plot tail current
%     plot(xTail,yTail, 'Color', 'red', 'LineWidth', 3);
%     %Iprev tail line
%     hline1Tail=refline([0 IprevTail]);
%     hline1Tail.Color='r';
%     hline1Tail.LineWidth=2;
%     %Iss tail line
%     hline2Tail=refline([0 IssTail]);
%     hline2Tail.Color='m';
%     hline2Tail.LineWidth=2;

    %---------------------------------------------------------------------%
    %Save area features
    %---------------------------------------------------------------------%
    %Save Area
    areaParams.QNa(k)=QNa;
    areaParams.QTail(k)=QTail;
    %Save Iprev
    areaParams.IprevNa(k)=IprevNa;
    areaParams.IprevTail(k)=IprevTail;
    %Save Iss
    areaParams.IssNa(k)=IssNa;
    areaParams.IssTail(k)=IssNa;
    %Save x
    areaParams.xNa{k}=xNa;
    areaParams.xTail{k}=xTail;
    %Save y
    areaParams.yNa{k}=yNa;
    areaParams.yTail{k}=yTail;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%hold off;
end

