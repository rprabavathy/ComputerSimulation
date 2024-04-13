clc;
clear all;
close all;

global L D;
L    = 32;        % lattice size
D    = 2; 
vol = L^D;
theta = rand(vol,1);
N_prod  = 10000
for k=1:L
  G(k) = correlation(theta);
end
 