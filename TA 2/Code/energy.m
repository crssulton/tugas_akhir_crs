function [output] = energy(glcm)
 glcm = glcm ./sum(glcm(:));
 [baris, kolom] = size(glcm);
 Energy = zeros(baris,kolom);
 for i=1:baris
     for j=1:kolom
            temp2 = glcm(i:i,j);
            if(temp2==0)
                Energy(i:i,j)= 0;
            else
                temp3 = (temp2).^2;
                Energy(i:i,j)=temp3;
            end
     end
end
    output = Energy;
    output = sum(sum(output));
end

