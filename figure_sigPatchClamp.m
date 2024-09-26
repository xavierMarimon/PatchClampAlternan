
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot Patch Clamp signals 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h1=figure(100);
%set(h1,'WindowState','fullscreen');

ax1=subplot(2,1,1);
hold on
%Voltage plot
plot(time,voltage, 'Color', 'magenta', 'LineWidth', 3); 
vertlinePatchClamp(voltage, sweepChange);
hold off;
%Plot labels
ylabel('Voltage [mV]');
%Plot limits
xlim([0 max(time)]);
%xlim([0 2500]);
grid on;
set(gca,'FontSize',14);
%Plot title
t=title(['File name: ' num2str(expName)],'Interpreter', 'none');

%Current plot
ax2=subplot(2,1,2);
hold on; 
if strcmp(type,'U')
   plot(time,current, 'Color', [0 0.4470 0.7410], 'LineWidth', 3);
else
   plot(time,current, 'Color', [0.8500 0.3250 0.0980], 'LineWidth', 3);  
end   
vertlinePatchClamp(current, sweepChange);

%Plot area
for k=1:1:size(areaParams,1)
    %Plot Na area
    NaFaceColor=[0.9290 0.6940 0.1250];
    NaEdgeColor='none';
    NaFaceAlpha=0.6;
    xNa=areaParams.xNa{k,1};
    yNa=areaParams.yNa{k,1};
    basevalue=areaParams.IssNa(k)*ones(size(xNa));
    areafill(xNa,yNa,basevalue,NaFaceColor,NaEdgeColor,0,NaFaceAlpha);
    
    %Plot tail area
    NaFaceColor=[0.6350 0.0780 0.1840];
    NaEdgeColor='none';
    NaFaceAlpha=0.6;
    xTail=areaParams.xTail{k,1};
    yTail=areaParams.yTail{k,1};
    basevalue=areaParams.IssTail(k)*ones(size(xTail));
    areafill(xTail,yTail,basevalue,NaFaceColor,NaEdgeColor,0,NaFaceAlpha);
end
%Fit model
for k=1:1:size(kineticParams,1)
     %Plot Na fit
     hfitNa=plot(kineticParams.fitmdlNa{k,1}, kineticParams.xdataNa{k,1},kineticParams.ydataNa{k,1});
     legend off;
     hfitNa(1).Marker='none';
     hfitNa(2).Color='k';
     hfitNa(2).LineWidth=3;
     %Plot tail fit
     hfitTail=plot(kineticParams.fitmdlTail{k,1}, kineticParams.xdataTail{k,1},kineticParams.ydataTail{k,1});
     legend off;
     hfitTail(1).Marker='none';
     hfitTail(2).Color='k';
     hfitTail(2).LineWidth=3;
end
%Plot step peaks
hs1=scatter(capPeaksPos,capPeaksVal, 'MarkerEdgeColor', 'none', 'MarkerFaceColor','yellow');
hs1.SizeData=60; 
%Plot tail peaks
hs2=scatter(NaPeaksPos,NaPeaksVal, 'MarkerEdgeColor', 'none', 'MarkerFaceColor',[0.9290 0.6940 0.1250]);
hs2.SizeData=60; 
%Plot tail peaks
hs3=scatter(tailPeaksPos,tailPeaksVal, 'MarkerEdgeColor', 'none', 'MarkerFaceColor',[0.6350, 0.0780, 0.1840]);
hs3.SizeData=60; 
%Plot legend
L1=plot(nan, nan, 'LineWidth',1,'Color','none' ,'Marker', 'o','MarkerSize', 15, 'MarkerFaceColor', 'yellow', 'MarkerEdgeColor', 'none');
L2=plot(nan, nan, 'LineWidth',1,'Color','none' ,'Marker', 'o','MarkerSize', 15, 'MarkerFaceColor', [0.9290 0.6940 0.1250], 'MarkerEdgeColor', 'none');
L3=plot(nan, nan, 'LineWidth',1,'Color','none' ,'Marker', 'o','MarkerSize', 15, 'MarkerFaceColor', [0.6350, 0.0780, 0.1840], 'MarkerEdgeColor', 'none');
hold off;
%Plot legend
legend([L1, L2, L3], {'Capacitive peak','Na peak','Tail peak'});
%Plot labels
ylabel('Current [nA]');
xlabel('time [samples]');
%Plot limits
xlim([0 max(time)]);
%xlim([0 2500]);
grid on;
set(gca,'FontSize',14);
linkaxes([ax1,ax2],'x');

% %% Save figure
% %File name 
% expNamePNG=[outputPathImages filesep 'figsig-' expName '.png'];
% h1.InvertHardcopy='on';
% %Save figure
% saveas(gcf, expNamePNG);
% %File name fig 
% expNameFIG=[outputPathImages filesep 'figsig-' expName '.fig'];
% %Save figure to fig file
% savefig(h1,expNameFIG);
% close(h1);

clearvars ax1 ax2 h1 hfitNa hfitTail L1 L2 L3 hs1 hs2 hs3;
