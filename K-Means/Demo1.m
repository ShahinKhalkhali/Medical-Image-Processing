% ----------------------------------- % 
% ------ Do not modify this code ---- %
% ------ Do not submit this code ---- % 
% ----------------------------------- % 
close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%% 1) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read and display an image
load Toy_T1_T2.mat
% Remove the following 3 variables underneath to revert to original
t1 = [0.4, 0.5; 0.25, 0.2];
t2 = [0.2, 0.6; 0.25, 0.1];
pd = [1, 0.35; 0.25, 0.45];

figure, 
subplot(1,3,1), imagesc(t1)
subplot(1,3,2), imagesc(t2)
subplot(1,3,3), imagesc(pd), colormap gray
%%%%%%%%%%%%%%%%%%%%%%%%% 2) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Apply KMeans, the features are t1 t2 pd
clusterCentersIn = [1 1 1; 1 1 0; 1 0 1; 0 1 1; 1 0 0; 0 1 0; 0 0 1; 0 0 0];
% do not uncomment the above line in your final code. Only uncomment it when you initially write your code (it is easier to have the clusterCentersIn, so write your first version of code using it.
InIm = zeros([size(t1) 3]); % input image that includes all t1 t2 pd data
InIm(:,:,1) = t1;
InIm(:,:,2) = t2;
InIm(:,:,3) = pd;
segmentedImage = KMeans(InIm,5,clusterCentersIn);
figure, imagesc(segmentedImage), colormap hot
title('KMeans with t1 t2 pd');

% %%%%%%%%%%%%%%%%%%%%%%%%% 3) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Create two new images that encode the x and y coordinates of each pixel in the image.
% 
% Ximage = repmat( [1:size(InIm,2)], size(InIm,1), 1);    % Specifies list of scalars, r1, r2, ..., rN, that describes how copies of A 
%                                                         % are arranged in each dimension. When A has N dimensions, the size of B is 
%                                                         % size(A).*[r1...rN]. For example, repmat([1 2; 3 4],2,3) returns a 4-by-6 matrix.
%                                                         
% Yimage = repmat( [1:size(InIm,1)]', 1, size(InIm,2));   % Specifies list of scalars, r1, r2, ..., rN, that describes how copies of A 
%                                                         % are arranged in each dimension. When A has N dimensions, the size of B is 
%                                                         % size(A).*[r1...rN]. For example, repmat([1 2; 3 4],2,3) returns a 4-by-6 matrix. 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%% 4) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Normalize and add to features
% FeatureIin = zeros( size(InIm,1), size(InIm,2), 5);
% FeatureIin(:,:,1:3) = InIm;
% FeatureIin(:,:,4) = Ximage/max(Ximage(:));
% FeatureIin(:,:,5) = Yimage/max(Yimage(:));
% 
% %%%%%%%%%%%%%%%%%%%%%%%%% 5) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Apply Kmeans to new feature image
% segmentedImage = KMeans(FeatureIin,5,clusterCentersIn);
% figure, imagesc(segmentedImage)
% title('KMeans with t1 t2 pd X Y');
% display('Finished!'), colormap hot
