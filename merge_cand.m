function merge_cand
cn = 1;
for nnn = 1 : 2
   cmd = sprintf('ls %d/seg_cand*.mat > names.txt', nnn);
   system(cmd);
   fd = fopen('names.txt', 'r');
   while 1
      fname = fgetl(fd);
      if ~ischar(fname)
         break;
      end
      cmd = sprintf('cp %s acand/seg_cand%d.mat', fname, cn);
      system(cmd);
      cn = cn + 1;
   end
   fclose(fd);
end


