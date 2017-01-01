function filter_cand
cn = 1;
cmd = sprintf('ls acand/seg_cand*.mat > names.txt');
system(cmd);
fd = fopen('names.txt', 'r');
while 1
   fname = fgetl(fd);
   if ~ischar(fname)
      break;
   end
   cmd = sprintf('load %s', fname);
   eval(cmd);
   if min_c < 90
      cmd = sprintf('cp %s seg_cand%d.mat', fname, cn);
      system(cmd);
      cn = cn + 1;
   end
end
fclose(fd);

