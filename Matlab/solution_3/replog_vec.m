function [xN]=replog_vec(x0,N,r)

xN=x0;
for n=1:N
   xN=r*xN.*(1-xN);
end