function [ output ] = Contras( image )
image = image ./sum(image(:));
[x y]=size(image);
kontras=0;
for m=1:x
    for n=1:y  
        kontras=((m-n)^2*image(m,n))+kontras;
    end
end
output=kontras;
end

