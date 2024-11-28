% RANSAC PROJECT ELEC 444
% Name: Shahin Khalkhali
% Student ID: 40057384

function lines = RansacLine(edgeImageIn, noIter, fitDistance, noPts, minD)

% get the image size
[M, N] = size(edgeImageIn);
% Get coordinates of all of the pixel locations corresponding to an edge
edgeInd = find(edgeImageIn);
[eIi, eIj] = ind2sub([M N], edgeInd);

bestLines = zeros(noIter, 3); % where we want to store multiple lines

len = length(edgeInd); % total num of edge pixels

for attempt_i = 1:noIter
    minDistanceSquared = minD^2;

    % look for 2 random minD spaced points
    while true
        point1 = randi(len);
        point2 = randi(len);
        dx = eIi(point1) - eIi(point2);
        dy = eIj(point1) - eIj(point2);
        if point1 ~= point2 && (dx^2 + dy^2 >= minDistanceSquared)
            % 2 points found
            break;
        end
    end

    % line fitting & voting mechanism
    inlierCount = 0;
    if dx ~= 0
        m = dy/dx; % slope
        b = eIj(point1) - m*eIi(point1);  % calculation for y-intercept


        % normalize the line equation coefficients
        a_normalized = -m / b;
        b_normalized = 1 / b;

        for current_pixel = 1:len
            x0 = eIi(current_pixel);
            y0 = eIj(current_pixel);
            % calculating the distance from the point to the line
            distance = abs(m*x0 - y0 + b) / sqrt(m^2 + 1);
            if distance < fitDistance
                inlierCount = inlierCount + 1;
            end
        end

    else
        % in the case of vertical lines
        x_const = eIi(point1);  % x-coordinate of the vertical line

        % normalizing the line equation coefficients
        a_normalized = 1 / x_const;
        b_normalized = 0;  % Since it's a vertical line

        % voting for vertical lines
        for current_pixel = 1:len
            if abs(eIi(current_pixel) - x_const) < fitDistance
                inlierCount = inlierCount + 1;
            end
        end
    end

    % update the best line if the current line has more inliers
    if inlierCount >= noPts
        % fprintf('line itteration #%d has %d points close to line\n',attempt_i,inlierCount)
        bestLines(attempt_i, :,:) = [a_normalized, b_normalized,1];
    end
end


% filter out the zero rows which (dont meet the minimum number of points)
lines = bestLines(any(bestLines, 2), :,:);

end
