%Prabavathy Rajasekaran(2130757
% Anjaly Kuriakose(2132537)
clc;
close all;
clear all;
global L;
L = 5;

x1 = randi(5,1,L);
x2 = randi(5,1,L);

x = [x1;x2];

l = lexic(x);

fprintf('length l: %d\n',l);
l = alexic(l);

fprintf('vector x : %d\n',x);






