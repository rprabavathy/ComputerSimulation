%Lab Session 5 Monte-Carlo Integration

%Part 1 PLotting Integrand in 1D
clc;
xx= -1:0.01:1;
f = zeros(length(xx),1);
for lx=1 : length(xx)
    f(lx) = exp(-2.*abs(xx(lx)).^2).* (abs(xx(lx)).^2 + 1); 
end
figure;
plot(xx,f);
title('PLotting Integrand in 1D');

%Part 1 -Plotting Integrand in 2D
xx=-1:0.01:1;
f = zeros(length(xx),1);
for lx=1 : length(xx)
   for ly=1 : length(xx) 
%     f(lx,ly) = exp(-2.*abs(xx(lx)).^2).* (abs(xx(lx)).^2 + 1)*exp(-2.*abs(xx(ly)).^2).* (abs(xx(ly)).^2 + 1);
   f(lx,ly) = exp(-2.*((abs(xx(lx)).^2)+(abs(xx(ly)).^2 ))).*((abs(xx(lx)).^2)+(abs(xx(ly)).^2)+1);
   
end  
end
figure;
surf(xx,xx,f);
title('PLotting Integrand in 2D');

%Part 2 Integrators in 1D
f =@(x) exp((-2).*(x.^2)).*(x.^2 +1);
R1=quad(f, -1,1);
display(R1);

%Part 2 Integrators in 2D
g = @(x1,x2)(exp(-2.*(x1.^2 + x2.^2)).*((x1.^2 + x2.^2) + 1));
R2 = quad2d(g,-1,1,-1,1);
display(R2);
