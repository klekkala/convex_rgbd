function mergez2()
load xyz_fill.mat;
x = xx; y = yy; z = zz;
cim = imread('color.ppm');
cim = im2double(cim);
r = cim(:,:,1);
g = cim(:,:,2);
b = cim(:,:,3);

seg = load('seg.txt');
figure(1); imagesc(seg);
drawnow;

stage = 1;
N = max(seg(:));
for n = 1 : N
    msk = seg == n;        
    %msk = imerode(msk, ones(3,3));
   [min_c, min_cc] = get_concavity2z(x, y, z, msk);
   seg_cand = zeros(size(x));
   seg_cand(msk) = 1;
   cmd = sprintf('save seg_cand%d.mat seg_cand min_cc min_c', stage);
   eval(cmd);
   stage = stage + 1;
end

masks = cell(N,1);
masks_big = cell(N,1);

for n = 1 : N
    masks{n} = (seg == n);
    masks_big{n} = imdilate(imresize(masks{n}, 0.5, 'nearest'), ones(2,2));
end

G = zeros(N, N); 
C = ones(N, N, 2)*1e10;
for n = 1 : N
  for m = n+1 : N
      len = sum(sum(masks_big{n} & masks_big{m}));
      if len > 0
         G(n, m) = 1;
         msk = masks{n} | masks{m};
         [c, cc] = get_concavity2z(x, y, z, msk);
         C(n, m, 1) = c;
         C(n, m, 2) = cc;
      end
  end
end

while N > 2
 
   [min_n, min_m] = find( (C(:,:,1) == min(min(C(:,:,1)))) & (G == 1) );
   if isempty(min_n) || isempty(min_m)
      break;
   end
   min_n = min_n(1); 
   min_m = min_m(1);

   new_masks = cell(N-1,1);
   new_big_masks = cell(N-1,1);
   cn = 1;
   for n = 1 : N
       if n == min_n || n == min_m
          continue;
       end
       new_masks{cn} = masks{n};
       new_masks_big{cn} = masks_big{n};
       cn = cn + 1;
   end
   new_masks{cn} = masks{min_n} | masks{min_m};
   new_masks_big{cn} = masks_big{min_n} | masks_big{min_m};

   seg_cand = zeros(size(x));
   seg_cand(new_masks{cn}) = 1;
   min_c = C(min_n, min_m, 1);
   min_cc = C(min_n, min_m, 2);
   cmd = sprintf('save seg_cand%d.mat seg_cand min_cc min_c', stage);
   eval(cmd);

   newG = zeros(N-1, N-1); % update superpixel graph
   newC = ones(N-1, N-1, 2)*1e10;
   
   newG(1:N-2, 1:N-2) = G(1:N ~= min_n & 1:N ~= min_m, 1:N ~= min_n & 1:N ~= min_m);
   newC(1:N-2, 1:N-2, :) = C(1:N ~= min_n & 1:N ~= min_m, 1:N ~= min_n & 1:N ~= min_m, :);
  
   for n = 1 : N-2
       len = sum(sum(new_masks_big{cn} & new_masks_big{n})); 
       if len > 0
          newG(n, cn) = 1;
          msk = new_masks{cn} | new_masks{n};
          [c, cc] = get_concavity2z(x, y, z, msk);
          newC(n, cn, 1) = c;
          newC(n, cn, 2) = cc;
       end
   end 

   G = newG;
   C = newC;
   masks = new_masks;
   masks_big = new_masks_big;

   N = N - 1;
   stage = stage + 1;

   figure(2);
   seg_new = zeros(size(x));
   for n = 1 : N 
       seg_new(masks{n}) = n;
   end
   imagesc(seg_new);
   drawnow;
end 



      
    
