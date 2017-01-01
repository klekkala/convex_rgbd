function makelpy2r
N = 1;
masks = {};
masks2 = {};
costs = {};
costx = {};
cscore = {};
for n = 1 : 1000
  fname = sprintf('seg_cand%d.mat', n);
  if ~exist(fname)
    break;
  end
  cmd = sprintf('load %s', fname);
  eval(cmd);
  masks{n} = seg_cand;
  P = imresize(seg_cand, 0.25, 'nearest');
  Q = bwconvhull(P);
  masks2{n} = P;
  costs{n} = min_cc; 
  costx{n} = min_c;
  cscore{n} = sum(P(:)) / (sum(Q(:)) + 1e-3);
  N = n;
end

save masks.mat masks;
cn = 1;
for n = 1 : 24
  for m = 1 : 32
     L = zeros(120, 160);
     L((n-1)*5+1 : n*5, (m-1)*5+1 : m*5) = 1;
     sp_pixels{cn} = L;
     cn = cn + 1;
  end
end

%seg = load('seg.txt');
%sp_pixels = {};
%for n = 1 : max(seg(:))
%    L = imresize(seg == n, 0.25, 'nearest');
%    sp_pixels{n} = L;
%end 

fd = fopen('test.lp', 'wt');
fprintf(fd, 'Minimize\n');

for n = 1 : N
      t = costs{n} + 200 + 0*costx{n}; %0*cscore{n} + 100*costx{n} ;
      if t > 0
        fprintf(fd, '+ %f xx%d\n', t, n);
      elseif t < 0
        fprintf(fd, '- %f xx%d\n', abs(t), n);
      end        
end

for n = 1 : N
  for m = n+1 : N
    r = sum(sum(masks2{n} & masks2{m})) * 16; % / sum(sum(masks2{n} | masks2{m}));
    if r > 0 
       fprintf(fd, '+ %f zz%d,%d\n', 0.01*r, n, m);
    end
  end
end

for n = 1 : size(sp_pixels,2)
    fprintf(fd, '- %f yy%d\n', sum(sum(sp_pixels{n}))*16000, n);
end

fprintf(fd, 'Subject To\n');

res = load('result.txt');
for n = 1 : N
    if res(n,2) == 1
       fprintf(fd, ' xx%d = 1\n', res(n,1));
    end
end

%for n = 1 : N
%      if  costx{n} > 80 || cscore{n} < 0.5 
%        fprintf(fd, ' xx%d = 0\n', n);
%      end
%end

for n = 1 : N
  for m = n+1 : N
    fprintf(fd, 'zz%d,%d - xx%d <= 0 \n', n, m, n);
    fprintf(fd, 'zz%d,%d - xx%d <= 0 \n', n, m, m);
    fprintf(fd, 'zz%d,%d - xx%d - xx%d >= -1 \n', n, m, n, m);
  end
end

for n = 1 : N
  for m = n+1 : N
    r = sum(sum(masks2{n} & masks2{m}))/...
        sum(sum(masks2{n} | masks2{m}));
    if r > 0.5
       fprintf(fd, 'zz%d,%d = 0\n', n, m);
    end
  end
end

for n = 1 : size(sp_pixels, 2)
   for m = 1 : N
       t = sum(sum(masks2{m} & sp_pixels{n}));
       if t > 0
           fprintf(fd, '+ xx%d\n', m);
       end
   end
   fprintf(fd, '- yy%d >=0 \n', n);
end

for n = 1 : size(sp_pixels, 2)
   fprintf(fd, 'yy%d <= 1 \n', n);
end


fprintf(fd, 'Binaries\n');
for n = 1 : N
  fprintf(fd, 'xx%d\n', n);
end

fprintf(fd, 'End');
fclose(fd);
  



