function [fx fy] = LJforce(x,y)
% file LJforce.m
%
% Force from Lennard-Jones potential for N particles (2dim.)
N=length(x);
fx=zeros(size(x)); fy=zeros(size(fx));     % reserve storage
% loop over pairs of distinct particles (each pair counted only one time, i<j !)
%
for i=1:N-1
    for j=i+1:N
    r2=(x(i)-x(j))^2+(y(i)-y(j))^2; % distance^2
    ri2=1/r2;
    fac=24*ri2^4*(2*ri2^3-1);
    fx(i)=fx(i)+(x(i)-x(j))*fac;% contribution of this pair-force acting ON i
    fy(i)=fy(i)+(y(i)-y(j))*fac;%
    fx(j)=fx(j)-(x(i)-x(j))*fac;% contribution of this pair-force acting ON j
    fy(j)=fy(j)-(y(i)-y(j))*fac;% Sign: actio=reactio
    end % loop j
end     % loop i; all forces are taken into account