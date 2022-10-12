%source: references to lab2 tutorial for harris corners detection

%Detect harris corners for image 1
%part 2.1 (source from lab2)
image = rgb2gray(im2double(imread('plasticClip1.jpg')));

image = imresize(image,0.5);
imshow(image);
%resizedimage = imresize(image,[456 1000]);
%imshow(resizedimage);

gaus = fspecial('gaussian', 7, 1);
%surf(gaus);
[deriv_gaus_x, deriv_gaus_y] = gradient(gaus);

ix = imfilter(image, deriv_gaus_x,'replicate');
iy = imfilter(image, deriv_gaus_y,'replicate');

ix2 = ix.*ix;
iy2 = iy.*iy;
ixiy = ix.*iy;
%apply gaussian filter to get g(Ix^2), g(Iy^2), and g(Ix * Iy)
ix2g = imfilter(ix2, gaus);
iy2g = imfilter(iy2, gaus);
ixiyg = imfilter(ixiy, gaus);

cornerness = ix2g.*iy2g - ixiyg.*ixiyg - 0.05*(ix2g + iy2g).^2;

imshow(cornerness*1e6);

highcor = cornerness.*(cornerness > (1e-6)); %the bigger num the less corner it shows eg 1e-5
imshow([cornerness highcor]*1e6);

localmax = imdilate(highcor, ones(3));
corners = (highcor == localmax).*highcor;

imshow([highcor localmax]*1e6);
imshow([cornerness highcor corners]*1e6);
imshow(corners>0);

cornersOnImage= image;
cornersOnImage(corners>0) = 1;
imshow(cornersOnImage);%shows the corners on image


imshow(image);
[pointY, pointX] = find(corners > 0); %locating all x and y value that has the corners
hold on;
plot(pointX, pointY, 'o', 'Color', 'green');
%plot(800,400,'o','Color','blue'); %pointing point(800,400)
%plot([932 800],[329 400], 'r'); %from point (932,329) to (800,400) line
hold off;


locatedpoints = [pointY, pointX];

%evaluate all above for the harris corners detection result of the image 
%------------------------------------------------------------------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SIFT like descriptor
%first take the located points from harris corner detector then for each
%point take a 16 by 16 pixel area around it and for each pixel in that
%area we calculate the orientation and its magnitude 
keypointmagnitude = [];
keypointdesciptor=[];
keypointDescPool = [];
sizeOfLocatedPointsSet = length(pointY);

gauss = fspecial('gaussian', 4, 1);
%the loop go through each located point and get a 16by16 window and each
%pixel calculates its orientation and magnitude. Then the window will be
%divided into 4 quadrant
for j=1:sizeOfLocatedPointsSet
   theWindow = cornersOnImage(pointY(j)-8:pointY(j)+8,pointX(j)-8:pointX(j)+8); %getting the 16x16 theWindow around each located point
  
   %filter the 16by16 window with weighted gaussian such that the center is
   %more significant than the outer of the frame.
   theWindow = imfilter(theWindow,gauss);
   [sizex sizey] =size(theWindow);
   
   %looping through each pixel within the 16by16 theWindow to get each pixel's
   %orientation and magnitude with the orientation and magnitude formula
   for i=1:sizex-1
    for u=1:sizey-1
       
         orientation(i,u)=atan2(((theWindow(i+1,u)-theWindow(i,u))),(theWindow(i,u+1)-theWindow(i,u)));
         orientation(i,u)= (180/pi)*orientation(i,u); %converting to degrees
         magnitude(i,u)=sqrt(((theWindow(i+1,u)-theWindow(i,u))^2)+((theWindow(i,u+1)-theWindow(i,u))^2));
         
    end
   end
   
   %dividing the theWindow into sub theWindow of size 4 by 4, each loop loop through each
   %quatrant of size 4by4 and each pixel's calculated orientation will be
   %distributed into 8bins (45degree each angle) then the magnitude value
   %will be added up to later get the max bin which is the key desciptor
   %for the 16 by 16 window.
     for k1=1:4
        for j1=1:4
            
            magPool = [];
            mag1=magnitude(((k1-1)*4)+1:4*k1, ((j1-1)*4)+1:4*j1);
            %extract the 4by4 of mag and orientation
            orient1=orientation(((k1-1)*4)+1:4*k1, ((j1-1)*4)+1:4*j1);
            
            %dividing the 360 degree into 8 bins with 45 degree each
            %bin/section such that each result orientation with mag can get be
            %allocated to its bin and find the keypoint desciptor
            for x=0:45:359 
                %divide by 8 section (45 degree each section)
                sumMag = 0;
                
             
            %looping the sub theWindow of 4by4, all the mag value of that
            %orientation would be collected within that section(45 degree) 
            for a=1:4
                for b=1:4
                    
                    lowbound=-180+x;
                    %the higherbound is 45 degree more than the lowerbound
                    higherbound=-135+x; 
                    
                    
                   %since the orientation value are from -180 to 180 then
                   %the lowerbound and higher bound will be below 0.
                    if lowbound < 0  ||  higherbound < 0
                        
                    if abs(orient1(a,b))>=abs(higherbound) && abs(orient1(a,b))<abs(lowbound)
                        %if the orientation value fall within the bin then
                        %we add the mag value to that bin.
                        sumMag=sumMag+mag1(a,b);
                    end
                    else
                    if abs(orient1(a,b))<=abs(higherbound) && abs(orient1(a,b))>abs(lowbound)
                        %mag1(a,b) is magnitude at that point
                        sumMag=sumMag+mag1(a,b); 
                        
                    end
                    end
                    
                end
            end
            %at end of this, is loop through 4by4 for a specific angle bin.
            %only that angle is done and concat the result to the pool of
            %magPool
            magPool=[magPool sumMag]; %concat it into a pool of magPool such that the max number of the pool would be the final mag of the subtheWindow
            
            
            end
            
            %at the end of this is all the angles looped, and got the array
            %of result from the specific quatrant
            keypointmagnitude =[keypointmagnitude magPool];
                
            
            
        end
     end
     %all 4 quatrant of the 16by16 theWindow is accounted, and we get the
     %result of whatever the max number in magnitude within the 16by16
     %pixel. The bin with the highest mag number is the descriptor for the
     %specific key point. 
     
     keypointdesciptor = [keypointdesciptor keypointmagnitude];
     maxOfCurrentKeyPointDesc = max(keypointdesciptor);
     %taking the max value of all the bins to be the keypoint descriptor of
     %the current theWindow
     keypointDescPool = [keypointDescPool maxOfCurrentKeyPointDesc];
   
 
   
end
%keypointDescPool is each keypoint descriptor value


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Harris corner detection for image 2 %%%%%%%%%%%%%%%%%%%%%%%%

imagev2 = rgb2gray(im2double(imread('plasticClip2.jpg')));

imagev2 = imresize(imagev2,0.5);
imshow(imagev2);
%resizedimage = imresize(image,[456 1000]);
%imshow(resizedimage);

gausv2 = fspecial('gaussian', 7, 1);
%surf(gausv2);
[deriv_gaus_xv2, deriv_gaus_yv2] = gradient(gausv2);

ixv2 = imfilter(imagev2, deriv_gaus_xv2,'replicate');
iyv2 = imfilter(imagev2, deriv_gaus_yv2,'replicate');

ix2v2 = ixv2.*ixv2;
iy2v2 = iyv2.*iyv2;
ixiyv2 = ixv2.*iyv2;
%apply gaussian filter to get g(Ix^2), g(Iy^2), and g(Ix * Iy)
ix2gv2 = imfilter(ix2v2, gausv2);
iy2gv2 = imfilter(iy2v2, gausv2);
ixiygv2 = imfilter(ixiyv2, gausv2);

cornernessv2 = ix2gv2.*iy2gv2 - ixiygv2.*ixiygv2 - 0.05*(ix2gv2 + iy2gv2).^2;

imshow(cornernessv2*1e6);

highcorv2 = cornernessv2.*(cornernessv2 > (1e-6)*2); %the bigger num the less corner it shows eg 1e-5  (had(1e-5)*6 before as setting)
%parameter 1e-4 or 0.0001 show too little corners
imshow([cornernessv2 highcorv2]*1e6);

localmaxv2 = imdilate(highcorv2, ones(3));
cornersv2 = (highcorv2 == localmaxv2).*highcorv2;

imshow([highcorv2 localmaxv2]*1e6);
imshow([cornernessv2 highcorv2 cornersv2]*1e6);
imshow(cornersv2>0);

cornersOnImagev2= imagev2;
cornersOnImagev2(cornersv2>0) = 1;
imshow(cornersOnImagev2);%shows the corners on image


imshow(imagev2);
[pointYv2, pointXv2] = find(cornersv2 > 0); %locating all x and y value that has the corners

%loop to remove element (corners) in the top part of the image frame (took
%out all element/corners within the 50pixel from the top of the y axis)
for i = length(pointYv2):-1:1
    if(pointYv2(i)<=300)
        pointYv2(i)= [];
        pointXv2(i)= [];
    end
    
end

for i = length(pointXv2):-1:1
    if(pointXv2(i)>=1400)
        pointXv2(i)= [];
        pointYv2(i)= [];
    end
    
end

hold on;
plot(pointXv2, pointYv2, 'o', 'Color', 'green');
%plot(800,400,'o','Color','blue'); %pointing point(800,400)
%plot([932 800],[329 400], 'r'); %from point (932,329) to (800,400) line
hold off;


locatedpointsv2 = [pointYv2, pointXv2];




%evaluate all above for the harris corners detection result of the image 
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%  sift descriptor for image 2 %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

keypointmagnitude2 = [];
keypointdesciptor2=[];
keypointDescPool2 = [];
sizeOfLocatedPointsSet2 = length(pointYv2);
gauss2 = fspecial('gaussian', 7, 1);

for j2=1:sizeOfLocatedPointsSet2
   theWindow2 = cornersOnImagev2(pointYv2(j2)-8:pointYv2(j2)+8,pointXv2(j2)-8:pointXv2(j2)+8); %getting the 16x16 theWindow around each located point
   
   %filter the 16by16 window with weighted gaussian such that the center is
   %more significant than the outer of the frame.
   theWindow2 = imfilter(theWindow2,gauss2);
   [sizex2 sizey2] =size(theWindow2);
   
   %looping through each pixel within the 16by16 theWindow to get each pixel's
   %orientation and magnitude with the orientation and magnitude formula
   for i2=1:sizex2-1
    for u2=1:sizey2-1
       
         orientation2(i2,u2)=atan2(((theWindow2(i2+1,u2)-theWindow2(i2,u2))),(theWindow2(i2,u2+1)-theWindow2(i2,u2)));
         orientation2(i2,u2)= (180/pi)*orientation2(i2,u2); %converting to degrees
         magnitude2(i2,u2)=sqrt(((theWindow2(i2+1,u2)-theWindow2(i2,u2))^2)+((theWindow2(i2,u2+1)-theWindow2(i2,u2))^2));
         
    end
   end
   
   
   %dividing it into sub theWindow of size 4 by 4, each loop loop through each
   %quatrant of size 4by4 and each pixel's calculated orientation will be
   %distributed into 8bins (45degree each angle) then the magnitude value
   %will be added up to later get the max bin which is the key desciptor
   %for the 16 by 16 window.
     for k2=1:4
        for j2=1:4
            
            magPool2 = [];
            mag2=magnitude2(((k2-1)*4)+1:k2*4, ((j2-1)*4)+1:4*j2);
            %extract the 4by4 of mag and orientation
            orient2=orientation2(((k2-1)*4)+1:4*k2, ((j2-1)*4)+1:4*j2);  
            
            %dividing the 360 degree into 8 bins with 45 degree each
            %bin/section such that each result orientation with mag can get be
            %allocated to its bin and find the keypoint desciptor            
            for x2=0:45:359 
                %divide by 8 section (45 degree each section)
                sumMag2 =0;
                
                           
            %looping the sub theWindow of 4by4, all the mag value of that
            %orientation would be collected within that section(45 degree) 
            for a2=1:4
                for b2=1:4
                    
                    lowbound2=-180+x2;
                    %the higherbound is 45 degree more than the lowerbound
                    higherbound2=-135+x2;
                    
                    
                   %since the orientation value are from -180 to 180 then
                   %the lowerbound and higher bound will be below 0.   
                    if lowbound2<0  ||  higherbound2<0
                        
                    if abs(orient2(a2,b2))<abs(lowbound2) && abs(orient2(a2,b2))>=abs(higherbound2)
                    %if the orientation value fall within the bin then
                    %we add the mag value to that bin.
                        sumMag2=sumMag2+mag2(a2,b2);
                    end
                    else
                    if abs(orient2(a2,b2))>abs(lowbound2) && abs(orient2(a2,b2))<=abs(higherbound2)
                      %mag2(a2,b2) is magnitude at that point
                        sumMag2=sumMag2+mag2(a2,b2); 
                        
                    end
                    end
                    
                end
            end
            %at end of this, is loop through 4by4 for a specific angle bin.
            %only that angle is done and concat the result to the pool of
            %magPool
            magPool2=[magPool2 sumMag2]; %concat it into a pool of magPool such that the max number of the pool would be the final mag of the subtheWindow
            
            
            end
            
            %at the end of this is all the angles looped, and got the array
            %of result from the specific quatrant
            keypointmagnitude2 =[keypointmagnitude2 magPool2];
                
            
            
        end
     end
     %all 4 quatrant of the 16by16 theWindow is accounted, and we get the
     %result of whatever the max number in magnitude within the 16by16
     %pixel. The bin with the highest mag number is the descriptor for the
     %specific key point. 
     
     keypointdesciptor2=[keypointdesciptor2 keypointmagnitude2];
     maxOfCurrentKeyPointDesc2=max(keypointdesciptor2);
     %taking the max value of all the bins to be the keypoint descriptor of
     %the current theWindow
     keypointDescPool2=[keypointDescPool2 maxOfCurrentKeyPointDesc2];
   
 
   
end

rounded1 = round(keypointDescPool,2,'significant');
rounded2 = round(keypointDescPool2,2,'significant');

%%%% Part 3.2 feature matching method %%%%%%%%%%%%%%%%%%

colorImage = im2double(imread('plasticClip1.jpg'));

colorImage = imresize(colorImage,0.5);

colorImage2 = im2double(imread('plasticClip2.jpg'));

colorImage2 = imresize(colorImage2,0.5);

img2width = size(colorImage2(:,:,1), 2);

imshow([colorImage colorImage2]);

hold on;

% plot(pointX, pointY, 'x', 'Color', 'green');
% hold on;
% plot(pointXv2 + img2width, pointYv2 , 'o', 'Color', 'blue');
% 
temparray = [];
counting = 0;

for i=1:length(keypointDescPool)
   for j=1:length(keypointDescPool2)
            
     %if(rounded1(1,i)==rounded2(1,j))
     if((rounded1(1,i)+0.1==rounded2(1,j))||(rounded1(1,i)-0.1==rounded2(1,j))||(rounded1(1,i)==rounded2(1,j)))
         
%          tempa = rounded2(1,j);
%          
%          if(~(ismember(tempa,temparray)))
             
          img1_Y = locatedpoints(i);
          imgl_X = locatedpoints(i,2);
          plot(imgl_X, img1_Y, 'x', 'Color', 'green');
          img2_Y = locatedpointsv2(j);
          img2_X = locatedpointsv2(j,2);
          plot(img2_X +img2width, img2_Y, 'o', 'Color', 'blue');
         
          plot([imgl_X img2_X + img2width],[img1_Y img2_Y],'red');
          
          
         
%           temparray = [temparray tempa];
%           
%          end
%         
          counting = counting + 1;
         
         
         
         
     end
   end
end


hold off;


%evaluate all above for the result image of feature matching result from the sift like descriptor. 
%--------------------------------------------------------------

