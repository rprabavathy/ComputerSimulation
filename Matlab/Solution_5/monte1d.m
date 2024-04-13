xx= -1:0.01:1;
%f = zeros(length(xx),1);
f = exp(-2*abs(xx).^2).* (abs(xx).^2 + 1);
figure;
plot(xx,f);