abc = imread('normal.ppm');
abc = im2double(abc);
a = abc(:,:,1);
b = abc(:,:,2);
c = abc(:,:,3);
v = [a(:), b(:), c(:)];
[idx, c] = kmeans(v, 6);
idx = reshape(idx, size(a,1), size(a,2));
imagesc(idx);

