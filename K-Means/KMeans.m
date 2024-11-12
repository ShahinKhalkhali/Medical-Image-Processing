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
%                     old_max_X = featureImageIn(i, j, k);  % Initialize peak of X-intensity axis for counter
%                     % Set new max of X-plane
%                     if new_max_X < old_max_X
%                         new_max_X = old_max_X;
%                     end
                    % Store pixel at current location
                    intensity_t1 = [intensity_t1, featureImageIn(i,j,k)];
                end

                if k == 2 % Layer 2 (t2)
%                     old_max_Y = featureImageIn(i, j, k);  % Initialize peak of Y-intensity axis for counter
%                     % Set new max of Y-plane
%                     if new_max_Y < old_max_Y
%                         new_max_Y = old_max_Y;
%                     end
                    % Store pixel at current location
                    intensity_t2 = [intensity_t2, featureImageIn(i,j,k)];
                end
                
                if k == 3 % Layer 3 (pd)
%                     old_max_Z = featureImageIn(i, j, k);  % Initialize peak of Z-intensity axis for counter
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
    points = intensity_array'                                          % Transposed to make all rows represent a pixel in space
    [lenght_point_X, length_point_Y] = size(points);                   % Dimensions of pixel data set
    
    convergence = false;
    i = 0;

    
    % Compare image's intensity with clusters and store them in updating toy array

    while ~convergence && (i < KMeanNo)
    
        for x = 1:lenght_point_X % Go along columns
            
            % Reset arrays for next point
            current_point = zeros(1, length_point_Y);
            
            for y = 1:length_point_Y % Go along rows
                
                % Store current point from points and go into findNearestCluster to test with one cluster at a time
                current_point(y) = points(x,y);
                
            end
            
            assign_cluster(x, y) = findNearestCluster(current_point, clusterCentersIn) % Test point with every cluster

        end
        
        % calculate the new cluster centers
        newClusterCenters = calculateClusterCenters(assign_cluster, points, numberofClusters);

        % check if converged
        if isequal(newClusterCenters, clusterCentersIn)
            convergence = true;
        else
            clusterCentersIn = newClusterCenters;
        end
        
    end
    end
end

function nearbyCluster = findNearestCluster(current_point, current_cluster)

    % Should test each point with 1 cluster at a time and
    % determine which are the nearest to current cluster and 
    % store them to calculate mean. Once the mean is obtained
    % place the cluster onto the newly found mean location

    cluster_array_height = height(current_cluster);
    distances = zeros(1, width(current_cluster));
    
    for k = 1:cluster_array_height
        
        euclidean = (current_point - current_cluster(k,:)).^2;
        distances(k) = sqrt(sum(euclidean));
        
    end

    % Store nearest clusters from storage into nearbyCluster
    [~, nearbyCluster] = min(distances);

end

function newCenters = calculateClusterCenters(assign_cluster, points, numberofClusters)
    [M, N, noFeatures] = size(points);
    newCenters = zeros(numberofClusters, noFeatures);
    
    for k = 1:numberofClusters
        for f = 1:noFeatures
            % get pixels for cluster k and feature f
            clusterPixels = points(:,:,f);
            clusterPixels = clusterPixels(assign_cluster == k);
            % calculate mean for clusters
            if ~isempty(clusterPixels)
                newCenters(k, f) = mean(clusterPixels);
            else
                newCenters(k, f) = 0;
            end
        end
    end
end
