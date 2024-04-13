function [ x ] = alexic( l)
global L;

x1 = 1+ mod(l-1,L);
%x2 = 1+(l-1)*(x1-L)/L;
x2 = (l-x1)/L+1;
x=[x1;x2];
end

