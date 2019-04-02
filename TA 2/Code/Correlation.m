function [output] = Correlation(glcm)
glcm = glcm ./sum(glcm(:));
sizeGLCM = size(glcm);
[baris, kolom] = meshgrid(1:sizeGLCM(1),1:sizeGLCM(2));
baris = baris(:);
kolom = kolom(:);
    function Mean = MeanIn(index,glcm)
        Mean = index.*glcm(:);
        Mean = sum(Mean);
    end
    function Std = Stdin(index,glcm,mean)
        temp = (index - mean).^2.*glcm(:);
        Std = sqrt(sum(temp));
    end
        Meani = MeanIn(baris,glcm);
        Meanj = MeanIn(kolom,glcm);
        stdi = Stdin(baris,glcm,Meani);
        stdj = Stdin(kolom,glcm,Meanj);
        temp1 = (baris-Meani).*(kolom-Meanj).*glcm(:);
        temp2 = sum(temp1);
        Correlation = temp2 /(stdi * stdj);
        output = Correlation;
end