
%-------------------------------------------------------------------------%
% Created by Xavier Marimon. 2020-2021. xavier.marimon@upc.edu
% This code is licensed under a Creative Commons License (CC).
%-------------------------------------------------------------------------%

function voltageRounded=roundVoltagePatchClamp(voltage)

%Target values
roundTargets=[0 -45 -80];
	
%Nearest neighbor interpolation
voltageRounded=interp1(roundTargets,roundTargets,voltage,'nearest','extrap');

end