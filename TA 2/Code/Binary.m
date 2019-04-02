function [ K ] = Binary2( I )
[l]=size(I,1); [p]=size(I,2);
    for k=1:3
        for i=1:l
            for j=1:p
                if I(i,j)==1
                    K(i,j,k)=0;
                else K(i,j,k)=1;
                end
            end
        end
    end
end