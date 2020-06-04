function [ recovered_img ] = recovering(original_image, original_mask, fill_image, mask)

[height,width] = size(mask);
level = floor(log2(min(height, width)));
pyramid_fill_img = cell(1, level);
pyramid_mask = cell(1, level);

flag = 1; %Check for the presence of marked region
count = 0; %Counts the levels

pyramid_fill_img{count+1} = fill_image;
pyramid_mask{count+1} = mask;
count = count+1;

% Downsampling
% Recursive Identification Methods (RIM)
for i=1:level
    if(flag==1)
        [RIM] = shrink(fill_image);
        [mask] = shrink(mask);

% Check for black        
        ind = find(mask == 1);
        if ~size(ind) 
            flag = 0;
        elseif size(mask, 1) <= 300
            flag = 0;
            [RIM] = inpainting(RIM, RIM, [0 0 0]);              
            RIM = uint8(RIM);           
        end

        count = count+1;
        pyramid_fill_img{count} = RIM;
        pyramid_mask{count} = mask;
        fill_image = RIM;
        clear rim;
    else
        break;
    end
end
%Matlab¡¦s built-in cellfun function enabled ¡¥isempty¡¦ processing functions.
pyramid_fill_img = pyramid_fill_img(~cellfun('isempty', pyramid_fill_img));
pyramid_mask = pyramid_mask(~cellfun('isempty', pyramid_mask));


% Upsampling
for i=count:-1:2
    img = pyramid_fill_img{i};
    
    exp = expand(img);
    
    mask = pyramid_mask{i-1};
    recovered_img = pyramid_fill_img{i-1};
    [x,y] = find(mask==1);
    for j=1:size(x)
        if mask(x(j), y(j))
            recovered_img(x(j), y(j),1) = exp(x(j), y(j),1);
            recovered_img(x(j), y(j),2) = exp(x(j), y(j),2);
            recovered_img(x(j), y(j),3) = exp(x(j), y(j),3);
        end
    end    
    
    pyramid_fill_img{i-1} = recovered_img;
    if i ~= 2
        clear recovered_img im exp mask
    end
end

end