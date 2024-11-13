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
    
    %%%%%%%%%%%%%%%% Testing array sizes %%%%%%%%%%%%%%%%
    
%     % Initialize intensity array based on the newly found boundaries
% %     new_max_X = 0;
% %     new_max_Y = 0;
% %     new_max_Z = 0;
%     intensity_t1 = [];
%     intensity_t2 = [];
%     intensity_pd = [];
%     
%     % Find 3D array's intensity boundaries
%     for k = 1:noF
%         for j = 1:N
%             for i = 1:M
%                 
%                 if k == 1 % Layer 1 (t1)
% %                     old_max_X = featureImageIn(i, j, k);  % Initialize peak of X-intensity axis for counter
% %                     % Set new max of X-plane
% %                     if new_max_X < old_max_X
% %                         new_max_X = old_max_X;
% %                     end
%                     % Store pixel at current location
%                     intensity_t1 = [intensity_t1, featureImageIn(i,j,k)];
%                 end
% 
%                 if k == 2 % Layer 2 (t2)
% %                     old_max_Y = featureImageIn(i, j, k);  % Initialize peak of Y-intensity axis for counter
% %                     % Set new max of Y-plane
% %                     if new_max_Y < old_max_Y
% %                         new_max_Y = old_max_Y;
% %                     end
%                     % Store pixel at current location
%                     intensity_t2 = [intensity_t2, featureImageIn(i,j,k)];
%                 end
%                 
%                 if k == 3 % Layer 3 (pd)
% %                     old_max_Z = featureImageIn(i, j, k);  % Initialize peak of Z-intensity axis for counter
% %                     % Set new max of Z-plane
% %                     if new_max_Z < old_max_Z
% %                         new_max_Z = old_max_Z;
% %                     end
%                     % Store pixel at current location
%                     intensity_pd = [intensity_pd, featureImageIn(i,j,k)];
%                 end
%                 
%             end
%         end
%     end
%     
%     % Checks maximum dimensions of 3D intensity array
% %     intensities = [new_max_X; new_max_Y; new_max_Z];    % Checks max possible axis of intensity_array
%     
%     % Intensities in newly made 3D array
%     intensity_array = [intensity_t1; intensity_t2; intensity_pd];       % Each column is a pixel in space
%     points = intensity_array'                                          % Transposed to make all rows represent a pixel in space
%     [lenght_point_X, length_point_Y] = size(points);                   % Dimensions of pixel data set
%     
    
    %%%%%%%%%%%%%%%% Actual work %%%%%%%%%%%%%%%%
    
    assign_cluster = zeros(M, N);
    convergence = false;
    i = 0;
    final_i = 20;
    current_cluster = clusterCentersIn;
    
    % Compare image's intensity with clusters and store them in updating toy array
    while ~convergence && (i < final_i)
        
        % Display number of iterations to show that we converge
        fprintf('Iterating %d\n', i);
        i = i + 1;
        
        for x = 1:M % Go along columns
            
            for y = 1:N % Go along rows
                % Set current point and compare to each cluster
                current_point = squeeze(featureImageIn(x, y, :));
                assign_cluster(x, y) = findNearestCluster(current_point, current_cluster);
            end
            

        end
        
        % Calculate the new cluster centers
        newClusters = calculateClusters(assign_cluster, featureImageIn, numberofClusters);

        % Check for convergence
        if isequal(newClusters, current_cluster)
            convergence = true;
        else
            current_cluster = newClusters;
        end    
    end
    
    % Calculatue current distance fit
    distance_fit = bestDistance(assign_cluster, featureImageIn, current_cluster);
    
    % Update new best fit segment
    if distance_fit < BestDfit
        BestDfit = distance_fit;
        segmentedImage = assign_cluster;
    end
    
    end
end

function nearbyCluster = findNearestCluster(current_point, clusterCentersIn)

    % Should test each point with 1 cluster at a time and
    % determine which are the nearest to current cluster and 
    % store them to calculate mean. Once the mean is obtained
    % place the cluster onto the newly found mean location

    cluster_array_height = size(clusterCentersIn, 1);
    distances = zeros(cluster_array_height, 1);
    
    for k = 1:cluster_array_height
        
        euclidean_distance = sqrt(sum((current_point' - clusterCentersIn(k,:)).^2));
        distances(k) = euclidean_distance;
        
    end

    % Store nearest clusters from storage into nearbyCluster
    [~, nearbyCluster] = min(distances);

end

function newCenterLoc = calculateClusters(assign_cluster, featureImageIn, numberofClusters)
    [M, N, noF] = size(featureImageIn);
    newCenterLoc = zeros(numberofClusters, noF);
    
    for i = 1:numberofClusters
        for j = 1:noF
            % get pixels for cluster i and image j
            clusterPixels = featureImageIn(:,:,j);
            clusterPixels = clusterPixels(assign_cluster == i);
            % calculate mean for clusters
            if ~isempty(clusterPixels)
                newCenterLoc(i, j) = mean(clusterPixels);
            else
                newCenterLoc(i, j) = 0;
            end
        end
    end
end

function distFit = bestDistance(assign_cluster, featureImageIn, current_cluster)
    distFit = 0;
    
    for i = 1:size(featureImageIn, 1)
        for j = 1:size(featureImageIn, 2)
            pixelFeatures = squeeze(featureImageIn(i, j, :));  % get pixel features
            clusterIndex = assign_cluster(i, j);  % get assigned cluster index
            % compute squared distance to cluster center
            d = sum((pixelFeatures' - current_cluster(clusterIndex, :)).^2);
            distFit = distFit + d;
        end
    end
end