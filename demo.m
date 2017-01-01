frame_num = 50; % NYU dataset frame number. Choose a number from 1 to 1449
system('rm *.mat');
system('rm 1/*.mat');
system('rm 2/*.mat');
system('rm acand/*.mat');
run_seg(frame_num);
mergez2
system('mv seg_cand*.mat 1');
run_segs(frame_num);
mergez2
system('mv seg_cand*.mat 2');
merge_cand
filter_cand
makelpy2
showresult
drawnow;
makelpy2r
showresult
drawnow;

