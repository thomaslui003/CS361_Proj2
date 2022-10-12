
# CS361 project 2

This repository is to showcase the Harris corners detector feature and the SIFT-like Descriptors and Feature Matching feature.\
Research paper on SIFT descriptors: https://www.cs.ubc.ca/~lowe/papers/ijcv04.pdf

## Description
**<ins>1.1: Data Preparation</ins>**\
**Set 1** (easy objects) images:

<p float="left">
  <img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/plasticClip1.jpg" width="500" />
  <img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/plasticClip2.jpg" width="500" /> 
  
</p>

<p float="left">
  <img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/plasticClip3.jpg" width="500" />
  <img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/plasticClip4.jpg" width="500" /> 
  
</p>


**Set 2** (hard objects) images:

<p float="left">
  <img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/battery1.jpg" width="500" />
  <img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/battery2.jpg" width="500" /> 
  
</p>

<p float="left">
  <img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/battery3.jpg" width="500" />
  <img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/battery4.jpg" width="500" /> 
  
</p>

**Set 3** (faces) images:

<p float="left">
  <img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/myface1.jpg" width="500" />
  <img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/myface3.jpg" width="500" /> 
  <img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/myface4.jpg" width="500" /> 
</p>


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

Below is some other resulting images from the algorithm:

<p float="left">
  <img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/results/set1HarrisResult1.jpg" width="500" />
  <img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/results/set2HarrisResult3.jpg" width="500" />
  <img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/results/set3HarrisResult1.jpg" width="500" />
</p>


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


**(3.3: SIFT like Descriptor and Feature matching algorithm analysis)**

Example of features that somewhat matched:\
**Set 1 (easy object)**\
Single object feature matches with single object with different object on the side. High
cornerness threshold is 1e-6 on the left side and (1e-6)*2 on the right side. The result had 98
matched lines counted by the algorithm.

<img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/results/set1pair1resultss.png">

Single object (blue clip) feature matches with single object with similar objects(yellow clip) and
other objects. High cornerness threshold is 1e-6 on the left side and (1e-6)*4 on the right side.
The result had 8 matched lines counted by the algorithm.

<img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/results/set1pair2resultss.png">

Single object (blue clip) feature matches with appearance changed single object (blue clip with
tape on it) and similar/different objects on the side. High cornerness threshold is 1e-6 on the left
side and (1e-6)*5 on the right side. The result had 21 matched lines counted by the algorithm.

<img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/results/set1pair3resultss.png">

The first set object is supposingly to be easy to feature match thus from a visual observation, it
surely matched most of the feature of the blue clip against the right side clip feature. However,
it seems to have a 25% correct rate of the matched line drawn which is caused by the detected
corner points at either the black pen or the scissors which was not the intention of the feature
match. These corner points’ key descriptor may have a similar value as a result it got wrongfully
feature matched. Despite having the matching algorithm taking match point value within 0.1
buffer, each corner point construction of the key descriptor is unique and different therefore
similar feature in both image clip can’t be matched exactly as the creation of the same keypoint
descriptor value may not be possible. Thus, the rounding of the value of keypoint descriptor take
effect which helped matches some features across two different images. For example, in set 1,
the keypoint descriptor value is rounded to 1 decimal place and with these value it may be hard
to get perfect outcome. Also, the feature matching outcome of the hardest pair in set 1 resulted
in a decent outcome as the center of the clip and edge of the clip was matched.


**Set 2 (harder object)**

Single object feature matches with single object with different object on the side. High
cornerness threshold is (1e-6)*8 on the left side and (1e-5)*3 on the right side. The result had
693 matched lines counted by the algorithm.

<img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/results/set2pair1resultss.png">

Single object (battery) feature matches with single object with similar objects(GP battery) and
other objects. High cornerness threshold is (1e-6)*8 on the left side and (1e-5)*5 on the right
side. The result had 247 matched lines counted by the algorithm.

<img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/results/set2pair2resultss.png">

Single object (battery) feature matches with appearance changed single object (battery with a
black marker line drawn down center) and similar/different objects on the side. High cornerness
threshold is 1e-6 on the left side and (1e-6)*6 on the right side. The result had 273 matched
lines counted by the algorithm.

<img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/results/set2pair3resultss.png">

Likewise to set 1, the feature match algorithm performed better than for set 1 object as the
branding letters on thebattery seems to have a better defined edge. As a result, the harris
corner detector algorithm was able to spot out all of the high cornerness points near the letters
of the battery which can be used to feature match. The success rate of matched point line
drawn is approximated at 50% as we can see in the top and bottom image where majority of the
matched lines are drawn between the battery branding label. However, these drawn line is not
surely accurate as the matching and sift like descriptor algorithm implemented can not
distinguish the exact point of feature that need to be match thus we have many line drawn
between the images.


**Set 3 (face)**

Single object (face) feature matches with single object with similar objects(another person face)
and other objects. High cornerness threshold is (1e-6) on the left side and (1e-5) on the right
side. The result had 16 matched lines counted by the algorithm.

<img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/results/set3pair2resultss.png">

Single object (face) feature matches with appearance changed single object (my face with
messing hairstyle) and similar/different objects on the side. High cornerness threshold is 1e-6 on
the left side and (1e-6)*6 on the right side. The result had 3068 matched lines counted by the
algorithm.

<img src="https://github.com/thomaslui003/CS361_Proj2/raw/main/results/set3pair3resultss.png">

From this set of result, the sift like descriptor and harris corner detector algorithm implemented
is not reliable at all as we can use the top image and observe that majority of the matched line
from my face matched to the top of the onion. Similarly, on the middle pair image, we see that
the corner points on the left side of my head got successfully matched with the same feature on
the right side once (1/16 or 6% successful rate). In other words, my algorithm cannot perform
feature matching correctly as the implementation and logic behind may be incorrect. But, to
some surprise, the bottom pair of image shows none of the matched line drawn from my face
leads to the other person face which shows my algorithm’s strength and inconsistency such that
further improvement are needed.


### Executing the program

For each report image, please open the matlab scripts that’s named according to the set of
image eg. set1pair2.m and look at the sectioned out comments line and left click to highlight the
portion of code that will generate the image and right click to the evaluate selection button.








