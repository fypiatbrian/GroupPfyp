function [inpainted_img,fill_img] = inpainting(original_image,fill_image,fill_color)
%Exemplar-based inpainting
%Refer by http://www.di.unito.it/~farid/Research/defencing.html
[img,fill_img,fill_region] = loadimgs(original_image,fill_image,fill_color);
img = double(img);
ori_img = img;
ind_img = img2ind(img);
mn = [size(img,1) size(img,2)];
source_region = ~fill_region;

%Initialize isophote values
[Ix(:,:,3) ,Iy(:,:,3)] = gradient(img(:,:,3));
[Ix(:,:,2) ,Iy(:,:,2)] = gradient(img(:,:,2));
[Ix(:,:,1) ,Iy(:,:,1)] = gradient(img(:,:,1));
Ix = sum(Ix,3)/(3*255); 
Iy = sum(Iy,3)/(3*255);
%Rotation gradient 90 degrees
temp = Ix; Ix = -Iy;
Iy = temp;

%Initialize confidence and data terms
% C - MxN matrix of confidence values accumulated over all iterations.
% D - MxN matrix of data term values accumulated over all iterations.
C = double(source_region);
D = repmat(-.1,mn);
iteration = 1;
% Visualization stuff
if nargout==6
  ori_img(1,1,:) = fill_color;
  iteration = 2;
end

% Loop until the entire filled area is covered
while any(fill_region(:))
  % Find contour & normalized gradients of fill region
  fill_region_D = double(fill_region);
  edge = find(conv2(fill_region_D,[1,1,1;1,-8,1;1,1,1],'same')>0);

  
  [Jx,Jy] = gradient(double(~fill_region));
  J = [Jx(edge(:)) Jy(edge(:))];
  J = normr(J); 
  % handle NaN and Inf
  J(~isfinite(J))=0; 
  
  % Calculate confidence along the fill front
  for K=edge'
    max_pri_patch = getpatch(mn,K);
    L = max_pri_patch(~(fill_region(max_pri_patch)));
    C(K) = sum(C(L))/numel(max_pri_patch);
  end
  
  % Calculate patch priorities = confidence term * data term
  D(edge) = abs(Ix(edge).*J(:,1)+Iy(edge).*J(:,2)) + 0.001;
  priorities = C(edge).* D(edge);
  
  % Find patch with maximum priority, max_pri_patch
  [unused,ndx] = max(priorities(:));
  M = edge(ndx(1));
  [max_pri_patch,rows,cols] = getpatch(mn,M);
  fillin = fill_region(max_pri_patch);
  
  % Find exemplar that minimizes error, min_error
  min_error = bestexemplar(img,img(rows,cols,:),fillin',source_region);
  
  % Update fill region
  fillin = logical(fillin); 
  fill_region(max_pri_patch(fillin)) = false;
  
  % Propagate confidence & isophote values
  C(max_pri_patch(fillin))  = C(M);
  Ix(max_pri_patch(fillin)) = Ix(min_error(fillin));
  Iy(max_pri_patch(fillin)) = Iy(min_error(fillin));
  
  % Copy image data from min_error to max_pri_patch
  ind_img(max_pri_patch(fillin)) = ind_img(min_error(fillin));
  img(rows,cols,:) = ind2img(ind_img(rows,cols),ori_img);  

  % Visualization stuff
  if nargout==6
    ind2_img = ind_img;
    ind2_img(logical(fill_region)) = 1; 
  end
  iteration = iteration+1;
end

inpainted_img=img;

% Scans over the entire image (with a sliding window)
% for the exemplar with the minimizes error
%Call C/C ++ and Fortran MEX function from MATLAB
function low_error = bestexemplar(img,Ip,fillin,source_region)
m=size(Ip,1); 
mm=size(img,1); 
n=size(Ip,2); 
nn=size(img,2);
best = bestexemplarhelper(mm,nn,m,n,img,Ip,fillin,source_region);
low_error = sub2ndx(best(1):best(2),(best(3):best(4))',mm);

% Returns the 9x9 color patch centered on the pixel index
function [max_pri_patch,rows,cols] = getpatch(mn,pixel)
w=4; pixel=pixel-1; 
y=floor(pixel/mn(1))+1; 
pixel=rem(pixel,mn(1)); 
x=floor(pixel)+1;
rows = max(x-w,1):min(x+w,mn(1));
cols = (max(y-w,1):min(y+w,mn(2)))';
max_pri_patch = sub2ndx(rows,cols,mn(1));

% Convert (row, column) subscript style index to Matlab index style index
function N = sub2ndx(rows,cols,total_rows)
X = rows(ones(length(cols),1),:);
Y = cols(:,ones(1,length(rows)));
N = X+(Y-1)*total_rows;

%Convert indexed images to RGB images as a color map
function img_ind2 = ind2img(ind,img)
for i=3:-1:1, temp=img(:,:,i); 
    img_ind2(:,:,i)=temp(ind); 
end

%Use the image itself as a color map to convert RGB images to index images
function ind_img = img2ind(img)
s=size(img); 
ind_img=reshape(1:s(1)*s(2),s(1),s(2));

% Load the image and its filled region as marker values to understand which pixels to fill
function [img,fill_img,fill_region] = loadimgs(img,fill_img,fill_color)
fill_region = fill_img(:,:,1)==fill_color(1) & ...
    fill_img(:,:,2)==fill_color(2) & fill_img(:,:,3)==fill_color(3);
