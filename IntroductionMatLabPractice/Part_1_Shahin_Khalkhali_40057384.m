% ELEC 444 - Medical Image Processing
% Name: Shahin Khalkhali
% SID: 40057384
% Date: 18/09/2024

% NOTE: You cannot use ANY function from the image processing toolbox except for imagesc and imshow.

% Part I: Matlab
% 
% Write a script called part1.m the performs and displays the results of
% the following:
% 
% 1.) Make a 12x12 matrix and fill in with the numbers 1-144 column-wise
% (without the use of for loops!). I.E. the first column is 1,2,3,4...
%  the second is 13,14,15, .... and so on.
% 
% 2.) Do the same as question 1 now row-wise.
% 
% 3.) Using the matrix from question 1, create a new matrix half the
% size of the original containing the odd columns and the even rows.
% 
% 4.) Using the matrix from question 1 create a Boolean matrix (0,1)
% indicating the elements greater than 30.
% 
% 5.) Solve this system:
% 
% 	X + Y + Z = 9;
% 	2*X + Y = 3;
% 	Y + Z = 5;
% 
% 	This should be done in one short line using matrixes and
% 	built-in operators.

% ---------------------------------------------------------------------

% > Referenced Sources
% > if statement: https://www.mathworks.com/help/releases/R2021a/matlab/ref/if.html?s_tid=doc_srchtitle
% > for statement: https://www.mathworks.com/help/releases/R2021a/matlab/ref/for.html?s_tid=doc_srchtitle
% > solve method: https://www.youtube.com/watch?v=la3XeeBjE8Y

% -----------------------------------------------------------------

clc;
clear;
close all;

%% Question 1
matrix = [1:12 ; 13:24 ; 25:36 ; 37:48 ; 49:60 ; 61:72 ; 73:84 ; 85:96 ; 97:108 ; 109:120 ; 121:132 ; 133:144]; % Original Matrix
Question_1 = matrix'                                                                                            % Transposed Matrix

%% Question 2
Question_2 = matrix % Original Matrix from Question 1

%% Question 3
Question_3 = Question_1([2, 4, 6, 8, 10, 12], [1, 3, 5, 7, 9, 11]) % Even rows in first parameter & odd columns in second parameter of transposed matrix from Question 1

%% Question 4 
Question_4 = Question_1;

for index = 1:144
    if Question_4(index) > 30
        Question_4(index) = 1;
    else
        Question_4(index) = 0;
    end
end

Question_4 % Output

%% Question 5

% 	X + Y + Z = 9;  ---> [ 1 1 1 ]   [ X ] = [ 9 ]
% 	2*X + Y = 3;    ---> [ 2 1 0 ] * [ Y ]   [ 3 ]
% 	Y + Z = 5;      ---> [ 0 1 1 ]   [ Z ]   [ 5 ]

A = [1 1 1; 2 1 0; 0 1 1];
b = [9;3;5];

Question_5 = A \ b % Since A*x = b, therefore we isolate x = b / A
                    % Where Question_5 = [X;Y;Z]
