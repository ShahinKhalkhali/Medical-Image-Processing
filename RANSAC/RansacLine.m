% RANSAC PROJECT ELEC 444
% Name: Shahin Khalkhali
% Student ID: 40057384

%   lines = RansacLine(edgeImageIn, noIter, fitDistance, noPts, minD)
%   -   lines is an n by 3 matrix parameterizing lines in the plane
%   -   edgeImageIn is a binary edge image
%   -   noIter is the number of iterations that you have to pick 2 points at random
%   -   fitDistance is the maximum distance a pixel may lie from a line
%   -   noPts is the minimum number of points that should vote for a line. Note that this is different
%       from the implementation discussed in class where we pick the line with max votes. Here, we
%       pick lines that have votes greater than noPts
%   -   minD is the minimum distance between the 2 randomly selected points. This improves
%       RANSAC’s performance because if the 2 original points are close, the line fitted can have
%       inaccurate slope.

% Hint hints for your RansacLine function: Use the matlab function "find" to get the
% coordinates of all of the pixel locations corresponding to an edge.

% Note that the number of lines can be different if you run the code again. For example, if we run
% the same code without changing anything, we might get 6 lines.
% To make sure your code is correct, you can test your code with other images, such as:
% inIM = imread('circuit.tif');
% inIM = imread('gantrycrane.png');

% -------------------------------------------------------------------------------------------------------
% > Referenced Sources
% > W08_3Regression_Least_Squares_KMeans
% > W08_4K_means by Hassan Rivaz
% > find function: https://www.mathworks.com/help/releases/R2021a/matlab/ref/find.html
% > Dealing with Outliers: RANSAC | Image Stitching : https://www.youtube.com/watch?v=EkYXjmiolBg&t=331s
% > Feature Detection, Extraction, and Matching with RANSAC : https://www.youtube.com/watch?v=QDiheqzZv4s
% -------------------------------------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% noIter:       the number of iterations that you have to pick 2 points at random
% fitDistance:  the maximum distance a pixel may lie from a line
% noPts:        the minimum number of points that should vote for a line
% minD:         the minimum distance between the 2 randomly selected points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function lines = RansacLine(edgeImageIn, noIter, fitDistance, noPts, minD)

% get the image size
[M, N] = size(edgeImageIn);
% get coordinates of all of the pixel locations corresponding to an edge
edgeInd = find(edgeImageIn);
[eIi, eIj] = ind2sub([M N], edgeInd);

lineArr = zeros(noIter, 3); % Array to store the identified lines
len = length(edgeInd); % Total number of edge pixels

for attempt_i = 1:noIter
    minDistanceSquared = minD^2;

    % Select two random points that meet the minimum distance condition
    while true
        point_1 = randi(len);
        point_2 = randi(len);
        dx = eIi(point_1) - eIi(point_2);
        dy = eIj(point_1) - eIj(point_2);
        if point_1 ~= point_2 && (dx^2 + dy^2 >= minDistanceSquared)
            % Found two points meeting the condition
            break;
        end
    end

    % Line fitting and inlier voting
    inlierCount = 0;
    if dx ~= 0
        m = dy / dx; % Slope of the line
        b = eIj(point_1) - m * eIi(point_1); % Calculate the y-intercept

        % Normalize the line equation coefficients
        a_norm = -m / b;
        b_norm = 1 / b;

        % Compute the number of inliers for the line
        for current_pixel = 1:len
            x0 = eIi(current_pixel);
            y0 = eIj(current_pixel);
            % Measure distance from pixel to line
            distance = abs(m * x0 - y0 + b) / sqrt(m^2 + 1);
            if distance < fitDistance
                inlierCount = inlierCount + 1;
            end
        end
    else
        % For vertical lines only
        x_const = eIi(point_1); % X-components

        % Normalize line equation coefficients
        a_norm = 1 / x_const;
        b_norm = 0; % If no y intercept

        % Count inliers for the vertical line
        for current_pixel = 1:len
            if abs(eIi(current_pixel) - x_const) < fitDistance
                inlierCount = inlierCount + 1;
            end
        end
    end

    % Update lineArr if current line has sufficient inliers
    if inlierCount >= noPts
        lineArr(attempt_i, :) = [a_norm, b_norm, 1];
    end
end

% Remove rows corresponding to invalid lines
lines = lineArr(any(lineArr, 2), :);

end