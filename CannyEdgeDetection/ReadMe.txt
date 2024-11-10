Homework 2 

Submit HysteresisThreshold.m and NonMaximalSuppression.m ONLY


You CANNOT use the command edge


Implement the Canny edge detection algorithm.  Do so as follows:

   a) Write a function to compute image gradients expressed as
      magnitude and direction. The form should be:

     [magnitude,orientation] = EdgeFilter(image, sigma)

     In this case, sigma is the variance of the Gaussian filter you
     must use to compute the derivatives.

   b) Write a non-maximal suppression algorithm of the form

     newMagnitudeImage = NonMaximalSuppression(magnitude,orientation)

   c) Write a hysteresis thresholding algorithm of the form

     BinaryEdgeImage = HysteresisThreshold(magnitudeImage,minThresh,
     maxThresh)

     As suggested above, the output should be a binary image.

   To demonstrate the algorithm, apply the filter to the “BrainWeb”


   Use the script Assignment2.m that performs each stage of the Canny
   filter and displays the intermediate results in a separate
   image. 
  

