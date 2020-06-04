# Fence Removal From Images
<img width="300" height="200" src="https://github.com/fypiatbrian/GroupPfyp/blob/master/demo_result/demo_object.jpg"/><img width="300" height="200" src="https://github.com/fypiatbrian/GroupPfyp/blob/master/demo_result/demo_fence.jpg"/>
<img width="300" height="200" src="https://github.com/fypiatbrian/GroupPfyp/blob/master/demo_result/demo_result02.png"/><img width="300" height="200" src="https://github.com/fypiatbrian/GroupPfyp/blob/master/demo_result/demo_result04.png"/>
<img width="300" height="200" src="https://github.com/fypiatbrian/GroupPfyp/blob/master/demo_result/demo_result05.png"/><img width="300" height="200" src="https://github.com/fypiatbrian/GroupPfyp/blob/master/demo_result/demo_result06.png"/>

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

<img width="300" height="200" src="https://github.com/fypiatbrian/GroupPfyp/blob/master/demo_result/demo_result01.png"/><img width="300" height="200" src="https://github.com/fypiatbrian/GroupPfyp/blob/master/demo_result/demo_result02.png"/>

##  Image Recovering

**Method 01 - Use pixel average to inpaint**  
The weighted average value of the gray values of adjacent pixels is used to calculate the gray value of unknown pixels. This method has a faster repair speed, but cannot maintain the scene structure in the photo. The result of the repaired photo will be blurred.

<img width="300" height="200" src="https://github.com/fypiatbrian/GroupPfyp/blob/master/demo_result/demo_result07.png"/>


**Method 02 - Exemplar-based in painting algorithms**  
Exemplar-based algorithms are a technique for image inpainting. In the image restoration, we gradually restore the fence in the image. We can first remove the unnecessary fence parts in the original image, then use the inpainting approach to fill in, fill the geometry and texture of the image to the corresponding target area.

<img width="300" height="200" src="https://github.com/fypiatbrian/GroupPfyp/blob/master/demo_result/method_img.png"/>
<img width="300" height="200" src="https://github.com/fypiatbrian/GroupPfyp/blob/master/demo_result/demo_result06.png"/>

## Inpaint operation time
<img width="450" height="540" src="https://github.com/fypiatbrian/GroupPfyp/blob/master/demo_result/Picture%20operation%20time%2001.png"/>

<img width="450" height="540" src="https://github.com/fypiatbrian/GroupPfyp/blob/master/demo_result/Picture%20operation%20time%2002.png"/>

## Inpaint Result
<img width="510" height="540" src="https://github.com/fypiatbrian/GroupPfyp/blob/master/demo_result/demo_result08.png"/>
<img width="510" height="540" src="https://github.com/fypiatbrian/GroupPfyp/blob/master/demo_result/demo_result09.png"/>

<img width="510" height="540" src="https://github.com/fypiatbrian/GroupPfyp/blob/master/demo_result/demo_result10.png"/>
<img width="510" height="540" src="https://github.com/fypiatbrian/GroupPfyp/blob/master/demo_result/demo_result11.png"/>

