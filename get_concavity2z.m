function [res1, res2] = get_concavity2z(x, y, z, bw)

x = x(1:4:end,1:4:end);
y = y(1:4:end,1:4:end);
z = z(1:4:end,1:4:end);
bw = bw(1:4:end,1:4:end);

eg = edge(bw);
bw = eg | bw;
mask = bw; 

if sum(sum(mask)) <= 100  
   res1 = 1000;
   res2 = 1000;
   return;
end

if length(unique([x(mask), y(mask), z(mask)], 'rows')) < 10
   res1 = 1000;
   res2 = 1000;
   return;
end

x(eg) = 10*x(eg);
y(eg) = 10*y(eg);
z(eg) = 10*z(eg);

xx = x(mask);
yy = y(mask);
zz = z(mask); 

minzz = min(zz);

xyz = [xx, yy, zz];
opt = {};
opt{1} = 'QJ';
K = convhulln(xyz, opt);
%figure(1);
%plot3(xx, yy, zz, '.');
%axis equal;

M = ~( (ismember(xyz(K(:,1), 1), x(eg)) & ismember(xyz(K(:,1), 2), y(eg)) & ismember(xyz(K(:,1), 3), z(eg))) | ... 
       (ismember(xyz(K(:,2), 1), x(eg)) & ismember(xyz(K(:,2), 2), y(eg)) & ismember(xyz(K(:,2), 3), z(eg))) | ...
       (ismember(xyz(K(:,3), 1), x(eg)) & ismember(xyz(K(:,3), 2), y(eg)) & ismember(xyz(K(:,3), 3), z(eg))) );
KK = K(M,:);

%figure(2);
%fill3(xx(KK'), yy(KK'), zz(KK'), zz(KK'))
%figure(3);
%fill3(xx(K'), yy(K'), zz(K'), zz(K'))


A = xyz(KK(:,1), :);
B = xyz(KK(:,2), :);
C = xyz(KK(:,3), :);

a = (B(:,2)-A(:,2)).*(C(:,3)-A(:,3)) - (C(:,2)-A(:,2)).*(B(:,3)-A(:,3));
b = (B(:,3)-A(:,3)).*(C(:,1)-A(:,1)) - (C(:,3)-A(:,3)).*(B(:,1)-A(:,1));
c = (B(:,1)-A(:,1)).*(C(:,2)-A(:,2)) - (C(:,1)-A(:,1)).*(B(:,2)-A(:,2));
d = -(a.*A(:,1) + b.*A(:,2) + c.*A(:,3));

J = (~ismember(xyz(:, 1), x(eg))) | (~ismember(xyz(:, 2), y(eg))) | (~ismember(xyz(:, 3), z(eg)));
uvw = xyz(J,:);

%figure(2);
%hold on;
%plot3(uvw(:,1), uvw(:,2), uvw(:,3), 'r.')
%hold off;

U = [uvw'; ones(1, size(uvw,1))];
t = sqrt(a.^2 + b.^2 + c.^2);
D = [a./t, b./t, c./t, d./t];
R = abs(D * U);

res1 = mean(min(R)) * 1000;
if isnan(res1)
   res1 = 1000;
end
res2 = sum(min(R)); 

 

