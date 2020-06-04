function[ M, counts, s_counts ] = component(mask, connected ,th)
% Extract the connected components of fence according to th
[m,n] = size(mask);

[L,num] = bwlabel(mask,connected);
counts(1:num) = double(1);

for i= 1:m
    for j = 1:n
        if(L(i,j) > 0 )
            counts(1,L(i,j)) = double(counts(1,L(i,j))+1);
        end

    end
end

%sorts counts in descending order.
s_counts = sort(counts , 'descend');

counter = 1;

for i = 1:th
    x = s_counts(i);
    location = find(counts == x);
    [p q] = size(location);

    if(p>1)
        for j = 1:p
            locations(counter , 1) = location(p,1);
            counter = counter + 1;
        end
    else
        locations(counter , 1 ) = location(p,1);
        counter = counter + 1;
    end

    if(counter > th)
        break;
    end

end

M(m,n) = zeros;

for i = 1:th

    z = locations(i , 1);

    for j = 1:m
        for k =1:n

            if( L(j,k) == z)
                M(j,k) = 1;
           
            end
        end
    end


end

end