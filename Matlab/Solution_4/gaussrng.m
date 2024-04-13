function [z]= gaussrng(N,mu,sig)
u = rng(N);

for k=1:2:N-1
    z(k)= sqrt(-2.*log(u(k))).*cos(2*pi*u(k+1));
    z(k+1)= sqrt(-2.*log(u(k))).*sin(2*pi*u(k+1));
end
 z = sig.*z+mu;
end
 
