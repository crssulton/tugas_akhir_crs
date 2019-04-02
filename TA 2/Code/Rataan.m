function [rata2, sdev] = Rataan(gambar)
gambar = im2bw(gambar);
rata2 = sum(double(gambar(:)), 1)./ numel(gambar);
[rows, columns] = size(gambar);
k = numel(gambar);
sdev = 0;
for col=1:columns;
    for row=1:rows
        sdev =sdev + ((gambar(row,col)-rata2)^2);
    end
end
sdev2 =sqrt(sdev/(k-1));
end