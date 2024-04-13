%Exercise 4_1
%Prabavathy Rajasekaran(2130757
% Anjaly Kuriakose(2132537)

clear; 
clc;
x= 100000;
seed = 200;
a = 1234557;
c = 765656;
m = 2^24;
z = rng(x, seed, a,c,m);
normal_h = sqrt(var(z)).*z+mean(z);
figure;
histogram(normal_h);
title('Normalised histogram');

figure;
[counts,centers] = hist(z);
bar(centers, counts);
title(sprintf('linear congruence Generator z\n Mean = %1.2f\n Variance = %1.2f\n Skewness = %1.3f\n Kurtosis = %1.2f',mean(z),var(z),skewness(z),3-kurtosis(z)));
fprintf('Mean : %d\n',mean(z));
fprintf('Variance : %d\n',var(z));
fprintf('Kurtosis : %d\n',kurtosis(z));
fprintf('skewness : %d\n',skewness(z));


