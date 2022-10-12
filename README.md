
# CS361 project 2

This repository is to showcase the Harris corners detector feature and the SIFT-like Descriptors and Feature Matching feature.

## Description
1.1: Data Preparation\
Set 1 (easy objects) images:


Set 2 (hard objects) images:

Set 3 (faces) images:


2.0: Detect Harris Corners\
(2.1:implementation of Harris corner detector with a tuneable parameter)

The implementation of Harris corner detector have two tuneable parameter and they are the gaussian function
and the high corner filter variable which when we have smaller and smaller setting like 1-e6 we
will end up with more corner location detected. The algorithm generally has the structure of first
importing the image to gray image then getting the derivative of gaussian kernel. Next, the
kernel will be used to calculate the image derivative of x and y. Then, for each image derivative,
we take the square of itself and apply gaussian filter to it. And, we take these components to
compute the cornerness using cor = ix2g.*iy2g - ixiyg.*ixiyg - 0.05*(ix2g + iy2g).^2. Then, we will
use the threshold to get points with high cornerness which smaller the threshold the more
corner will be detected. Lastly, we will use the find function to get all the corners into a 2d array
called locatedpoints which has all the coordinates of points.


<img src="https://github.com/thomaslui003/Quick-fix/raw/main/layout1.png" width="807" height="524">
<img src="https://github.com/thomaslui003/Quick-fix/raw/main/layout2.png" width="853" height="476">


### Executing the program

The application can be compiled and run using Android studio.

The software uses Android API 24 and will be compatible with systems running Android 7.0.0+


styleguide: https://google.github.io/styleguide/javaguide.html

