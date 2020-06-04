# Fence Removal From Images

![image](https://github.com/fypiatbrian/GroupPfyp/blob/master/fence/02.jpg)
![image](https://github.com/fypiatbrian/GroupPfyp/blob/master/object/02.jpg)

## Abstract


In daily life, take a photo is already an indispensable part of people's daily lives. As people have higher and higher requirements for photo quality, people often choose to use the method of retouching to remove or modify photos The part that is considered unnecessary, we often encounter obstacles when shooting, which affects the aesthetics of the photos we take. 

For this, we need a processing tool that can provide us with the ability to repair pictures, So that we can use it to remove unnecessary fences and obstacles in the picture. Usually, this tool is divided into two parts, one part can detect the fence and obstacles in the picture, extract the fence part from the picture. The other part is the part that can repair the missing fence.

## Requirements Setup

This project is all implemented using [Matlab](https://www.mathworks.com/products/matlab.html)

## Data Preparation

We have prepared 8 groups of photos, two in a group, for using to testing data.

## Fence Extraction

Subtract the Gaussian Blur image from its original image, subtract from pixel to pixel, and then a value will appear. The larger the value is the clear position, and the smaller the value is the blurred position so that the clear position of the pixel will be on the fence and the subject.
The mask of extraction fence image.

![image](picture or gif url)
呢度放提取圖ppt15

##  Image Recovering

**Method 01 - Use pixel average to inpaint**  
The weighted average value of the gray values of adjacent pixels is used to calculate the gray value of unknown pixels. This method has a faster repair speed, but cannot maintain the scene structure in the photo. The result of the repaired photo will be blurred.

![image](picture or gif url)
呢度放圖ppt24


**Method 02 - Exemplar-based in painting algorithms**  
Exemplar-based algorithms are a technique for image inpainting. In the image restoration, we gradually restore the fence in the image. We can first remove the unnecessary fence parts in the original image, then use the inpainting approach to fill in, fill the geometry and texture of the image to the corresponding target area.

![image](picture or gif url)
呢度放圖ppt25

## Inpaint operation time

![image](picture or gif url)
呢度放圖ppt37

![image](picture or gif url)
呢度放圖ppt38

## Inpaint Result

![image](picture or gif url)
呢度放圖ppt41

![image](picture or gif url)
呢度放圖ppt43
