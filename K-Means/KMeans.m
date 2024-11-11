% Implement k-means clustering. Do not use the built-in MATLAB function kmeans. Submit one file called KMeans.m (do not submit or modify Demo1.m).
% segmentedImage = KMeans(InIm, numberofClusters, clusterCentersIn)
% 
% where:
% segmentedImage is an image that codes each located cluster with a different intensity value. InIm is the input image, which can have 
% multiple values at each pixel. numberofClusters is the number of clusters to find in the image. clusterCentersIn is an optional parameter
% that specifies the starting centers of the clusters. If this is the empty list [], random initialization is used.
% 
% Hint: When random initialization is used, it is a good idea to run k-means several times (5 is good) with different random initializations
%       and keep the best result in terms of distance fit.
% 
% Hint: For debugging, a good idea is to make an artificial image that is easily segmented and to pass good cluster centers to the function 
%       to start from.
% 
% The script Demo1.m is provided, which does the following:
% 
% 1. Loads t1, t2, and pd images.
% 2. Applies k-means clustering with k=8 and random initialization.
% 3. Creates two new images that encode the x and y coordinates of each pixel in the image.
% 4. Adds these to the t1, t2, and pd values so that each feature vector includes both intensity and location.
% 5. Repeats k-means clustering on this new image and displays the results.

% ---------------------------------------------------------------------

% > Referenced Sources
% > W08_4K_means by Hassan Rivaz
% > 
% -----------------------------------------------------------------

% Do not change the function name. You have to write your code here
% you have to submit this function
function segmentedImage = KMeans(featureImageIn, numberofClusters, clusterCentersIn)

% Get the dimensions of the input feature image
[M, N, noF] = size(featureImageIn);
% some initialization
% if no clusterCentersIn or it is empty, randomize the clusterCentersIn
% and run kmeans several times and keep the best one
if (nargin == 3) && (~isempty(clusterCentersIn))
    NofRadomization = 1;
else
    NofRadomization = 5;    % Should be greater than one
end

segmentedImage = zeros(M, N); %initialize. This will be the output

BestDfit = 1e10;  % Just a big number!

% run KMeans NofRadomization times
for KMeanNo = 1 : NofRadomization    
%     % randomize if clusterCentersIn was empty
    if NofRadomization>1
        clusterCentersIn = rand(numberofClusters, noF); %randomize initialization
    end
    
    % Initialize intensity array based on the newly found boundaries
%     new_max_X = 0;
%     new_max_Y = 0;
%     new_max_Z = 0;
    intensity_t1 = [];
    intensity_t2 = [];
    intensity_pd = [];
    
    % Find 3D array's intensity boundaries
    for k = 1:noF
        for j = 1:N
            for i = 1:M
                
                if k == 1 % Layer 1 (t1)
%                     old_max_X = featureImageIn(i, j, k);  % Initialize peak of X-intensity for counter
%                     % Set new max of X-plane
%                     if new_max_X < old_max_X
%                         new_max_X = old_max_X;
%                     end
                    % Store pixel at current location
                    intensity_t1 = [intensity_t1, featureImageIn(i,j,k)];
                end

                if k == 2 % Layer 2 (t2)
%                     old_max_Y = featureImageIn(i, j, k);  % Initialize peak of Y-intensity for counter
%                     % Set new max of Y-plane
%                     if new_max_Y < old_max_Y
%                         new_max_Y = old_max_Y;
%                     end
                    % Store pixel at current location
                    intensity_t2 = [intensity_t2, featureImageIn(i,j,k)];
                end
                
                if k == 3 % Layer 3 (pd)
%                     old_max_Z = featureImageIn(i, j, k);  % Initialize peak of Z-intensity for counter
%                     % Set new max of Z-plane
%                     if new_max_Z < old_max_Z
%                         new_max_Z = old_max_Z;
%                     end
                    % Store pixel at current location
                    intensity_pd = [intensity_pd, featureImageIn(i,j,k)];
                end
                
            end
        end
    end
    
    % Checks maximum dimensions of 3D intensity array
%     intensities = [new_max_X; new_max_Y; new_max_Z];    % Checks max possible axis of intensity_array
    
    % Intensities in newly made 3D array
    intensity_array = [intensity_t1; intensity_t2; intensity_pd];       % Each column is a pixel in space
    clusterCentersIn
    points = intensity_array'
    [lenght_points_X, length_point_Y] = size(points);
    
    
    % Compare image's intensity with clusters and store them in updating toy array
    euclidean = zeros(lenght_points_X, length_point_Y);
    if lenght_points_X < numberofClusters
    
        for x = 1:lenght_points_X % Go along columns
        
            for y = 1:length_point_Y % Go along rows

                current_point = points(x,y)
                current_cluster = clusterCentersIn(x,y)
                euclidean(x,y) = abs((current_point - current_cluster)^2)

            end
            euclidean(x,:)
            distance_toy(x) = sqrt(sum(euclidean(x,:)))
            
        end
    
    % Compare image's intensity with clusters and store them in updating actual array
    else
        
        for x = 1:numberofClusters % Go along columns
            for y = 1:length_point_Y % Go along rows
                distance(x,y) = sqrt((clusterCentersIn(x,y))^2 + (points(x,y))^2)
            end
        end
        
    end
    
end
end