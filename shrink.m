function [ output_image ] = shrink( image )
% Maximum absolute difference between high-resolution images fitted by downsampling.
[M, N, ~]=size(image);
output_image=image(1:2:M, 1:2:N,:);

end