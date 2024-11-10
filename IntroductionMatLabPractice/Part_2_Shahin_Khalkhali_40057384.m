% ELEC 444 - Medical Image Processing
% Name: Shahin Khalkhali
% SID: 40057384
% Date: 18/09/2024

% NOTE: You cannot use ANY function from the image processing toolbox except for imagesc and imshow.

% Part II: Image manipulations
% 
% Write a script called part2.m that performs and displays the results of
% the following:
% 
% For 1 through 4 use the built-in image "peppers.png" to test. To load it, simply type the following:
% i_pepper = imread('peppers.png');
% 
% 1.) Flip an image upside-down.
% 
% 2.) Take a color image and make it grayscale using equal weights of R,
%   G, and B. 
% 
% 3.) Swap the R and B color channels of an RGB image such that R is now B and
% vise versa.
% 
% 4.) Rotate a grey scale image 90 degrees counter-clockwise. (you cannot use imrotate or rot90)
% 
% 5.) Create a 12 by 12 by 3 "image" using the matrix from part 1
%   question 1.  Now, look at the "reshape" function in matlab using the
%   help command. Use reshape to  
%     a) convert this matrix to a 144 by 3 matrix.
%     b) convert the 144 by 3 matrix back to the original 12 by 12 by 3
%        structure.

% -----------------------------------------------------------------

% > Referenced Sources
% > Grayscale script example from Dr. Hasan Rivaz's lecture presentation: w02_2_Matlab_Matrix_hist.pdf, p.20
% > Manipulating pixels of an image:    https://www.youtube.com/watch?v=kQly-XDeFgU
%                                       https://www.youtube.com/watch?v=c2VMpu0Q4UU
%                                       https://www.youtube.com/watch?v=F9S3S4P8REY
% > Reshape Statement: https://www.mathworks.com/help/matlab/ref/double.reshape.html
% > Reshape Statement: https://stackoverflow.com/questions/2256925/reshape-3d-matrix-to-2d-matrix
% > Creating 3D matrix with 2D matrix: https://www.mathworks.com/help/matlab/ref/repmat.html#:~:text=0%20%20%20%20%200%20%20%20300-,3%2DD%20Block%20Array,-Try%20This%20Example

% -----------------------------------------------------------------

clc;
clear;
close all;
i_pepper = imread('peppers.png');

subplot(3,3,1);
imagesc(i_pepper);
title('Original Pepper');
axis image; % Maintain aspect ratio

%% Question 1
[x y z] = size(i_pepper);   % Dimenesions of peppers.png
i = 1;                      % Variable of the pixel's index

for j = x:-1:1
    i_pepper_flipped(i,:,:) = i_pepper(j,:,:);
    i = i + 1;
end

subplot(3,3,2);
imagesc(i_pepper_flipped);
title('Q1) Flipped Pepper');
axis image; % Maintain aspect ratio

%% Question 2
gray_pepper = zeros(384,512);
gray_pepper(:) = (i_pepper(:,:,1) + i_pepper(:,:,2) + i_pepper(:,:,3))/3;
imin = min(min(gray_pepper));
gray_pepper = gray_pepper - imin;
imax = max(max(gray_pepper));
gray_pepper = floor(gray_pepper/imax*64);

subplot(3,3,3);
colormap(gray);
imagesc(gray_pepper);
title('Q2) Gray Pepper');
axis image; % Maintain aspect ratio

%% Question 3
new_pepper = i_pepper;          % Use original image as reference
og_red = new_pepper(:,:,1);     % Store original blue colors into temp
og_blue = new_pepper(:,:,3);    % Store original red colors into temp

new_pepper(:,:,3) = og_red;     % Replace blue pixels with red pixels
new_pepper(:,:,1) = og_blue;    % Replace red pixels with blue pixels

subplot(3,3,4);
imagesc(new_pepper);
title('Q3) Color Swap Pepper');
axis image; % Maintain aspect ratio

%% Question 4
[x y z] = size(i_pepper);   % Dimenesions of peppers.png
i = 1;                      % Variable of the pixel's index

for j = x:-1:1
    i_pepper_CCW(i,:,:) = i_pepper(:,j,:);
    i = i + 1;
end

subplot(3,3,5);
imagesc(i_pepper_CCW);
title('Q4) CCW Pepper');
axis image; % Maintain aspect ratio

%% Question 5
matrix = [1:12 ; 13:24 ; 25:36 ; 37:48 ; 49:60 ; 61:72 ; 73:84 ; 85:96 ; 97:108 ; 109:120 ; 121:132 ; 133:144]; % Original Matrix
Question_1 = matrix';                                                                                           % Transposed Matrix

matrix_T = repmat(Question_1,[1,1,3]); % 

subplot(3,3,7);
imagesc(matrix_T);
title('Q5-1) Image 12x12x3');
axis image; % Maintain aspect ratio

matrix_144x3 = reshape(matrix_T,[144,3]);

subplot(3,3,8);
imagesc(matrix_144x3);
title('Q5-2) Image 144 x 3');
axis image; % Maintain aspect ratio

matrix_12x12x3_og = reshape(matrix_T,[12,12,3]);

subplot(3,3,9);
imagesc(matrix_12x12x3_og);
title('Q5-3) Image 12x12x3');
axis image; % Maintain aspect ratio