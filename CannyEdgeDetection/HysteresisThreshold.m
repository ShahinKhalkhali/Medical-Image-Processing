% ELEC 444 - Medical Image Processing
% Name: Shahin Khalkhali
% SID: 40057384
% Date: 09/10/2024

% ---------------------------------------------------------------------

% > Referenced Sources
% > Hysteresis: w05_Canny_NLM.pdf (p. 45, 46) by Dr. Hassan Rivaz
% > bwselect: https://www.mathworks.com/help/images/ref/bwselect.html
% > bwselect: https://www.youtube.com/watch?v=Eyy0BCb2GL0
% > find: https://www.mathworks.com/help/matlab/ref/find.html

% -----------------------------------------------------------------

function BinaryEdgeImage = HysteresisThreshold(magnitudeImage, minThresh, maxThresh)
    % Apply high threshold mask (strong edges)
    mask_high = magnitudeImage < maxThresh + 0.06;  % Increase maxThresh range to intensify more pixels
    
    % Apply low threshold mask (weak and strong edges)
    mask_low = magnitudeImage > minThresh - 0.02;   % Decrease minThresh range to intensify more pixels
    
    % Get the coordinates of the strong edge pixels
    [row, col] = find(mask_high);
    
    % Use bwselect to retain weak edges connected to strong edges
    BinaryEdgeImage = bwselect(mask_low, col, row, 8); % 8-connectivity
end