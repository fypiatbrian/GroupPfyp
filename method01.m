clear
close all
clc

I1=imread('01_1.png');%input the image focus background 
a=rgb2gray(I1);  %convert color image to grayscale image
I2=imread('01_2.png');%input the image focus fence
b=rgb2gray(I2); %convert color image to grayscale image
aa=(b-(a-b)); %the fence of image 2
[h,w]=size(aa);%read length and width
n=8;  %expand the fence
B=ones(n,n); %nn matrix
for i=1:h
    for j=1:w
            if aa(i,j)~=0
                 for l=1:3
                I2(i,j,l)=0;
                end
            end
    end
end

mask=imdilate(I2,B);%expand fence of image2
for i=1:h
    for j=1:w
         for l=1:3
            if mask(i,j)>0
                I1(i,j,l)=0; %make the fence color become black
            end
         end
    end
end
figure(2)
imshow(mask)  % show the fence image

%inpaint the image
n_p=2;
I1=padarray(I1, [n_p n_p]); %add n_p circle elements to periphery of the image
for i=n_p:h+n_p
    for j=n_p:w+n_p
         for l=1:3
              if I1(i,j,l)==0 
                frame=reshape(I1(i-n_p+1:i+n_p-1,j-n_p+1:j+n_p-1,l),1,(2n_p-1).^2);  %compress the matrix into one dimension
                num=(frame~=0);%the position of the 0 element in the fence
                n_num=sum(num);  %the number of 0 element in the fence
                m=sum(frame)/n_num;%Average pixel value
                I1(i,j,l)=round(m);%assign 0 pixels to the average pixel value
              end
         end
    end
end

I=I1(n_p+1:h+n_p,n_p+1:w+n_p,1:3); % show the inpaint image
figure(1)
imshow(I)