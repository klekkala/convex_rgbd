function run_segs(nnn)
cmd = sprintf('load ../clouddata/nyu/rgbd%d.mat', nnn);
eval(cmd);
z = -z;
save rgbd.mat x y z r g b mask;
cmd = sprintf('cp ../clouddata/nyu/color%d.ppm color.ppm', nnn);
system(cmd);

fillhole2;

minx = min(min(xx(50:480-30, 40:640-40)));
maxx = max(max(xx(50:480-30, 40:640-40)));
xx = (xx-minx)/(maxx - minx);
xx(xx<0) = 0;
xx(xx>1) = 1;

miny = min(min(yy(50:480-30, 40:640-40)));
maxy = max(max(yy(50:480-30, 40:640-40)));
yy = (yy-miny)/(maxy - miny);
yy(yy<0) = 0;
yy(yy>1) = 1;

minz = min(min(zz(50:480-30, 40:640-40)));
maxz = max(max(zz(50:480-30, 40:640-40)));
zz = (zz-minz)/(maxz - minz);
zz(zz<0) = 0;
zz(zz>1) = 1;
img = cat(3, xx, yy, zz);
imwrite(img, 'normal.ppm');
%normal2;

cd segment
system('sh go.sh');
cd ..
process_seg;

seg = load('seg.txt');
imagesc(seg);



