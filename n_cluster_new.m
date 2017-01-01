function n_cluster_new 
v = imread('normal.ppm');
v = im2double(v);
r = v(:,:,1);
g = v(:,:,2);
b = v(:,:,3);
v = imread('color.ppm');
v = im2double(v);
rr = v(:,:,1);
gg = v(:,:,2);
bb = v(:,:,3);

load xyz_fill.mat;
t = r.*xx + g.*yy + b.*zz;
t = t(:);
t = (t-min(t)) ./ (max(t)-min(t)+1e-6);

u = zz;
u = u(:);
u = (u-min(u)) ./ (max(u)-min(u)+1e-6);

A = [r(:), g(:), b(:) sqrt(3)*t sqrt(3)*u]; % 0.01*rr(:) 0.01*gg(:) 0.01*bb(:)];

M = 20;

[cid, ctr] = kmeans(A, M, 'emptyaction', 'drop');
ids = reshape(cid, 480, 640);
%imagesc(ids);
total = 0;
map = zeros(size(ids));
for n = 1 : M
  im = ids == n;
  %im = imopen(im, ones(10,10));
  L = bwlabel(im, 4);
  map(L > 0) = L(L > 0) + total;
  total = total + max(L(:));
end
mask = zeros(480, 640);
mask(50:480-30, 40:640-40) = 1;
mask = ~mask;

map(mask) = 0;
%imagesc(map);
%map = im2double(map);
N = max(map(:));
z = [];
num = 1;
ss = zeros(size(map));
for n = 1 : N
    if sum(sum(map == n)) >= 500
       ss(map == n) = num;
       num = num + 1;
    end
end

save seg.txt ss -ascii;

%for n = 1 : max(map(:))
%    map(map == n) = rand(1,1);
%end
%imagesc(map);

 

