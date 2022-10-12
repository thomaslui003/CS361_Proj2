
# CS361 project 2

This repository is to showcase the Harris corners detector feature and the SIFT-like Descriptors and Feature Matching feature.

## Description
**<ins>1.1: Data Preparation</ins>**\
**Set 1** (easy objects) images:


**Set 2** (hard objects) images:

**Set 3** (faces) images:



**<ins>2.0: Detect Harris Corners</ins>**\
**(2.1:implementation of Harris corner detector with a tuneable parameter)**

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


<img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/s1.png">

**(2.2:Performance of the Harris corner detector algorithm with a tuneable parameter)**

<img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/s22.jpg">

The threshold of 1e-7 or 0.0000001 was applied to the top image to get more high cornerness
points. As a result of this filtering for high cornerness point, there are many located points in the
background of the battery; for example, we can see the located high cornerness points in the
left scissors and in the plastic clip. These points may be useless and not wanted for the
intention of using it later for feature matching as it may be disturbing for matching points
between images. Therefore, we have the bottom image representing the result from a threshold
of 0.00005 or (1e-5)*5. With this bigger threshold, we get points located at the center of the
battery which is what we want for later use of feature matching with sift descriptor. Also, we get
the total number of 51 located points in the bottom with that threshold meanwhile the smaller
threshold get 337 located high cornerness points.

**<ins>3.0: SIFT like Descriptors and Feature Matching</ins>**\
**(3.1:implementation of SIFT like descriptors for harris corners)**

The algorithm implementation first take the located high cornerness points and have a nested
for loop to iterate through all of the found points. And, for each point, we extract a 16 by 16 pixel
window and have a gaussian kernel filtered with it. Next, for each pixel, we calculate its
orientation and magnitude with the magnitude and orientation formula and store it in each
individual magnitude and orientation matrix. Next, with the 16 by 16 window, we divide the
window into sub window of 4 by 4 to get its orientation and magnitude values allocated into a
histogram or essentially one of the eight bin (360 degree divided 8 for each bin). Then, for the
specific bin or angle bin, we sum up all the magnitude value related that angle for later use.
Once all four quadrant is done, we have a pool of data of high cornerness points with specific
bin allocated for magnitude value. Finally, we use the max function to get the max value of the
pool to be the key point descriptor for that located high cornerness point. Moreover, these key
point descriptor will be stored in a pool of keypoint descriptor and can be used to match other
image’s keypoint descriptor to locate similar feature in both images which is what the algorithm
performed. It took two image with harris corners and found all of the keypoint descriptors in
each image for feature matching.

**(3.2: Feature matching method algorithm)**

The feature matching algorithm took the approach of getting the result keypoint descriptor pool
data from the two image that wanted to be feature matched. In each of these array, it stored
each located high cornerness point’s keypoint descriptor value formed from the 16by16 window
and broken into 4by4 subwindow for magnitude and orientation value distribution across the
histogram. The algorithm uses a nested for loop with the two set of keypoint descriptor data and
match its keypoint descriptor values within a plus or minus 0.1 value buffer. Finally, when the
values matched, a line will be drawn across the matched points/harris corner points. Indeed,
each value in the pool of keypoint descriptor data is rounded to one decimal place to provide
some accuracy of matching the right feature between two images.

**(3.3: SIFT like Descriptor and Feature matching algorithm analysis)**\
Example of features that somewhat matched:\
**Set 1 (easy object)**

Single object feature matches with single object with different object on the side. High
cornerness threshold is 1e-6 on the left side and (1e-6)*2 on the right side. The result had 120
matched lines counted by the algorithm.



### Executing the program

The application can be compiled and run using Android studio.

The software uses Android API 24 and will be compatible with systems running Android 7.0.0+


styleguide: https://google.github.io/styleguide/javaguide.html

