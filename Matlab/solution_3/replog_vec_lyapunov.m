function [xN,L]=replog_vec_lyapunov(x0,N,r)

xN=x0;
L=zeros(size(x0));
for n=1:N
   L = L + log(abs(r-2*r*xN));
   xN=r*xN.*(1-xN);
end

L = L./N;