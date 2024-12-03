% RANSAC PROJECT ELEC 444
% Name: Shahin Khalkhali
% Student ID: 40057384

% ---------------------------------------------------------------------
% > Referenced Sources
% > W08_3Regression_Least_Squares_KMeans
% > W08_4K_means by Hassan Rivaz
% > Dealing with Outliers: RANSAC | Image Stitching : https://www.youtube.com/watch?v=EkYXjmiolBg&t=331s
% > Feature Detection, Extraction, and Matching with RANSAC : https://www.youtube.com/watch?v=QDiheqzZv4s
% -----------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% noIter:       total number of iterations that 2 points are selected at random
% fitDistance:  min distance of a point to a line to be considered as "on the line"
% noPts:        min number of votes that each line should get
% minD:         minimum allowed distance between pairs (in pixels). To improve line fitting

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
        a_normalized = -m / b;
        b_normalized = 1 / b;

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
        x_const = eIi(point_1); % X-components of the vertical line

        % Normalize line equation coefficients
        a_normalized = 1 / x_const;
        b_normalized = 0; % If no y intercept

        % Count inliers for the vertical line
        for current_pixel = 1:len
            if abs(eIi(current_pixel) - x_const) < fitDistance
                inlierCount = inlierCount + 1;
            end
        end
    end

    % Update lineArr if current line has sufficient inliers
    if inlierCount >= noPts
        lineArr(attempt_i, :) = [a_normalized, b_normalized, 1];
    end
end

% Remove rows corresponding to invalid lines
lines = lineArr(any(lineArr, 2), :);

end
