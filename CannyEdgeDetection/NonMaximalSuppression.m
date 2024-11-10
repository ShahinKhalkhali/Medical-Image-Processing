% ELEC 444 - Medical Image Processing
% Name: Shahin Khalkhali
% SID: 40057384
% Date: 09/10/2024

% ---------------------------------------------------------------------

% > Referenced Sources
% > Spatial Filtering: w04_hist_Equaliz_Conv.pdf (p. 19-33) by Dr. Hassan Rivaz
% > Nonmaximal suppression: w05_Canny_NLM.pdf (p. 51-53) by Dr. Hassan Rivaz

% -----------------------------------------------------------------

function newMagnitudeImage = NonMaximalSuppression(magnitude,orientation) % Parameters contain mag1: 160x180 double & dir1: 160x180 double

[YY, XX] = size(magnitude);         % Storing mag1 into array [YY, XX]
newMagnitudeImage = zeros(YY, XX);  % Initializing newMagnitudeImage of empty array
temp = newMagnitudeImage;           % Using temp as storage for pixel manipulation

% Comaprison of orientation to find horizontal, vertical, and angled edges
mag_h   = ( (orientation > (-pi/8)   ) & (orientation <= (pi/8))   ) | ( (orientation > (7*pi/8)  ) & (orientation <= (-7*pi/8)) );
mag_45  = ( (orientation > (pi/8)    ) & (orientation <= (3*pi/8)) ) | ( (orientation > (7*pi/8)  ) & (orientation <= (-5*pi/8)) );
mag_v   = ( (orientation > (-3*pi/8) ) & (orientation <= (5*pi/8)) ) | ( (orientation > (-5*pi/8) ) & (orientation <= (-3*pi/8)) );
mag_n45 = ( (orientation > (5*pi/8)  ) & (orientation <= (7*pi/8)) ) | ( (orientation > (-3*pi/8) ) & (orientation <= (-pi/8))   );

% Horizontal shift
temp(:,2:XX) = magnitude(:,1:XX-1);         % Shift in x-direction
comp1 = mag_h & ( (magnitude - temp) > 0 ); % Comparison 1
temp(:,1:XX-1) = magnitude(:,2:XX);         % Shift in x-direction
comp2 = mag_h & ( (magnitude - temp) > 0);  % Comparison 2
newMagnitudeImage = newMagnitudeImage + magnitude .* (comp1 & comp2); % Implement new change onto image and returning to Assignment 2

% Diagonal shift of 45 degrees
temp(2:YY, 2:XX) = magnitude(1:YY-1, 1:XX-1); % shifts one row down and one column to the right
comp1 = mag_45 & ((magnitude - temp) > 0); 
temp(1:YY-1, 1:XX-1) = magnitude(2:YY, 2:XX); % shifts one row up and one column to the left
comp2 = mag_45 & ((magnitude - temp) > 0); 
newMagnitudeImage = newMagnitudeImage + magnitude .* (comp1 & comp2); % update new magnitude image

% Vertical shift
temp(2:YY,:) = magnitude(1:YY-1,:);         % Shift in y-direction
comp1 = mag_v & ( (magnitude - temp) > 0 ); % Comparison 1
temp(1:YY-1,:) = magnitude(2:YY,:);         % Shift in y-direction
comp2 = mag_v & ( (magnitude - temp) > 0);  % Comparison 2
newMagnitudeImage = newMagnitudeImage + magnitude .* (comp1 & comp2); % Implement new change onto image and returning to Assignment 2

% -45-degree direction
temp(2:YY, 1:XX-1) = magnitude(1:YY-1, 2:XX); % shifts one row down and one column to the left
comp1 = mag_n45 & ((magnitude - temp) > 0); 
temp(1:YY-1, 2:XX) = magnitude(2:YY, 1:XX-1); % shifts one row up and one column to the right
comp2 = mag_n45 & ((magnitude - temp) > 0);   
newMagnitudeImage = newMagnitudeImage + magnitude .* (comp1 & comp2); % update new magnitude image