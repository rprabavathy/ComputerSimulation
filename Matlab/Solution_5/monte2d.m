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