%Exercise_4_2 Box Muller Transform
%Prabavathy Rajasekaran(2130757
% Anjaly Kuriakose(2132537)
clear;
clc;
z = gaussrng(10000,0.2,4);
figure
hist(z,100);
title(sprintf('Box-Muller Transform z\n Mean = %1.2f\n Variance = %1.2f\n Kurtosis = %1.2f',mean(z),var(z),3-kurtosis(z)));
xlim([-20 20]);
fprintf('first order moments %d\n' ,moment(z,1));
fprintf('second order moments %d\n' ,moment(z,2));
fprintf('third order moments %d\n' ,moment(z,3));
