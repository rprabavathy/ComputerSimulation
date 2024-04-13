% ex3_2.m: fancy plot

% range of r values
rmin=2.7;
rmax=4;

% image size:
H=1000;
W=1500;

% number of iterations
N=2000;

% image matrix
A=zeros(H,W);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

r=linspace(rmin,rmax,W);
x0=linspace(eps,1,H*20);

for lr=1:length(r)
   xN=replog_vec(x0,N,r(lr));
   b = hist(xN,linspace(0,1,H));
   b = b/max(b); %normalize to 1
   A(:,lr) = 1-b;
end

image(r,x0,256*A); hold on;
set(gca,'YDir','normal');
% create a colormap
for l=1:256
   map(l,:) = [1 1 1]*l/256;
end
colormap(map);
xlabel('r');
ylabel('x');
imwrite(flipud(A),'logistic.png')
