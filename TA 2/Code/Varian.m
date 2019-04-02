function [output] = Varian( image )
varian=0;
[a b]=Rataan(image);
[x y]=size(image);
for m=1:x
    for n=1:y  
        varian=((image(m,n)-a)^2)+varian;
    end
end
varian=varian/numel(image);
output =sum(sum(varian));
end

