tic;
close all;
clear all;
object_image = imread('demo_image\object\03.JPG');
fence_image = imread('demo_image\fence\03.JPG');
% Setup
fill_image = object_image;
set1 = 5 ;
set2 = 50 ;
% The value of connected is 4 or 8
% Indicating whether to search the area by 4 connected or 8 connected
connected = 8;
% Threshold of connected components
th = 1;
% Structural element objects for operations such as expansion corrosion and opening and closing operations
se = strel('disk',30);

% Gaussian blur
% Returns a rotationally symmetric Gaussian low-pass filter with dimensions of standard deviation
h1 = fspecial('gaussian',set1,set1*2);
h2 = fspecial('gaussian',set2,set2*2);
o_img_gray = rgb2gray(object_image);
f_img_gray = rgb2gray(fence_image);
% Identification fences
o_img_blur = imfilter(o_img_gray , h1, 'symmetric');
f_img_blur = imfilter(f_img_gray , h1, 'symmetric');
o_img_sub = imsubtract(o_img_gray,o_img_blur); 
f_img_sub = imsubtract(f_img_gray,f_img_blur);
% Extraction fences
f_img_sub_blur = imfilter(f_img_sub , h2, 'symmetric');
o_img_sub_D = double(o_img_sub);
f_img_sub_blur_D = double(f_img_sub_blur);
[h,w] = size(o_img_sub_D);
[r,c] = size(f_img_sub_blur_D);
sub_img = zeros();

%Into a mask image	
for i=1:r 
    for j=1:c 
        if f_img_sub_blur_D(i, j) > 0.1
            sub_img(i, j) = 1; 
        else
            sub_img(i, j) = 0; 
        end
    end
end

% Optimize the raised fence part
% Extract the fence parts
[sub_img_C] = component(sub_img, connected, th);

% Reduced or increased the fence size
%sub_img_thin = imerode(sub_img_C,se);
sub_img_coarse = imdilate(sub_img_C,se);

%Remove the fence in the original image
img_dil = ones();
img_imd = imdilate(sub_img_coarse, img_dil);

[m n] = size(img_imd);
for i=1:m
    for j=1:n
        if img_imd(i,j) 
        fill_image(i,j,1) = 0;
        fill_image(i,j,2) = 0;
        fill_image(i,j,3) = 0;
        end
    end
end

%Inpainted and restored image
mask = sub_img_coarse;
mask = im2bw(mask, 0.5);

recovered_image = recovering(object_image, mask, fill_image, mask);

% Show step results
subplot(3,3,1);imshow(object_image);
subplot(3,3,2);imshow(fence_image);
subplot(3,3,3);imshow(f_img_sub,[]);
subplot(3,3,4);imshow(f_img_sub_blur,[]);
subplot(3,3,5);imshow(sub_img);
subplot(3,3,6);imshow(sub_img_C);
subplot(3,3,7);imshow(sub_img_coarse);
subplot(3,3,8);imshow(fill_image);
subplot(3,3,9);imshow(recovered_image);

toc;