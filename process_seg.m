function process_seg
load rgbd.mat;
seg = -ones(480, 640);
ss = load('./segment/out.txt');
seg(50:480-30, 40:640-40) = ss(50:480-30, 40:640-40);
ids = unique(seg);
N = length(ids);
map = zeros(size(seg));
k = 1;
for n = 1 : N
    if ids(n) < 0
       continue;
    end 
    T = seg == ids(n);    
    if sum(T(:)) < 500 
       continue;
    end

    map(T) = k;
    k = k + 1;
end
save seg.txt map -ascii
