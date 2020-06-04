function img = expand(image)
%Upsampling
%Pixels restore the image accordingly at the downsampling level.
%gaussian weighting functions
gaussian_weighting = [1 4 6 4 1]/16;

img_size = size(rgb2gray(image));
y = zeros(2*img_size);
y(1:2:2*img_size(1),1:2:2*img_size(2)) = image(:,:,1);
img(:,:,1) = 4*conv2(gaussian_weighting,gaussian_weighting,y,'same');

y = zeros(2*img_size);
y(1:2:2*img_size(1),1:2:2*img_size(2)) = image(:,:,2);
img(:,:,2) = 4*conv2(gaussian_weighting,gaussian_weighting,y,'same');

y = zeros(2*img_size);
y(1:2:2*img_size(1),1:2:2*img_size(2)) = image(:,:,3);
img(:,:,3) = 4*conv2(gaussian_weighting,gaussian_weighting,y,'same'); 

img = uint8(img);
end