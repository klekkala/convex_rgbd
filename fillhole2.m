im = imread('color.ppm');
load rgbd.mat;

xx = fill_depth_cross_bfx(im, x, mask);
yy = fill_depth_cross_bfx(im, y, mask);
zz = fill_depth_cross_bfx(im, z, mask);

save xyz_fill.mat xx yy zz;

