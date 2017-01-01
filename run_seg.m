function run_seg(nnn)
cmd = sprintf('load ../clouddata/nyu/rgbd%d.mat', nnn);
eval(cmd);
z = -z;
save rgbd.mat x y z r g b mask;
cmd = sprintf('cp ../clouddata/nyu/color%d.ppm color.ppm', nnn);
system(cmd);

fillhole2;
normal2;
n_cluster_new;
seg = load('seg.txt');
imagesc(seg);


