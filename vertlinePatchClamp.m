
%amplitude: current or voltage

function vertlinePatchClamp(amplitude, sweepChange)

%Numbers of sweeps
Nsweep=length(sweepChange);

%Nsamples
Nsamples=length(amplitude);

%y postion
ypos=-40;
%Loop over all sweeps
for i=1:Nsweep
    
    if i==Nsweep
        %x position
        xpos=((Nsamples+sweepChange(i))/2)-1;
    else
        %Median position
        medpos(i,1)=((sweepChange(i+1)+sweepChange(i))/2)-1;
        %x position
        xpos=medpos(i,1);
    end
    %Draw text  
    text(xpos,ypos, num2str(i), 'HorizontalAlignment', 'center', 'Color', 'k', 'FontSize',15);
    %Reference line
    hline=xline(sweepChange(i));
    hline.Color ='k';
    hline.LineWidth =1.5;
end

end