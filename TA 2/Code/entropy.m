function [output] = entropy(glcm)
glcm = glcm ./sum(glcm(:));      
[baris, kolom] = size(glcm);
Entropy = zeros(baris,kolom);
  for i=1:baris
     for j=1:kolom
            temp2 = glcm(i:i,j);
            if(temp2==0)
                Entropy(i:i,j) = 0;
            else
                temp = -(temp2);
                temp3 = log10(temp2);
                Entropy(i:i,j)=temp.*temp3;
            end
     end
  end
  output = Entropy;
  output = sum(sum(output));
end