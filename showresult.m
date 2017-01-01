system('~/glpk/bin/glpsol --lp test.lp -o out.txt');
system('sh parse.sh');
load masks.mat;
N = size(masks,2);
res = load('result.txt');
im = zeros(480, 640, 3); 
for n = 1 : N
    R = im(:,:,1);
    G = im(:,:,2);
    B = im(:,:,3);
    if res(n,2) == 1       
       R(masks{res(n,1)}>0) = rand(1,1);
       G(masks{res(n,1)}>0) = rand(1,1);
       B(masks{res(n,1)}>0) = rand(1,1);       
    end
    im = cat(3, R, G, B);
end

imagesc(im); 

  



