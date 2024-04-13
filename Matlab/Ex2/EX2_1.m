%Exercise 2.1
%NUmber of terms to calculate.
N = 10;
%Declare array to store them
Pn = zeros(N,1);
%set first term 
Pn(1) = log(11)/10;
%Iterate with recursion formula 
for  i = 1:N-1
    Pn(i+1) = 0.1/i -0.1*Pn(i);
end
%COMPARE with analytical results
%create function depending on x and n
f = @(x,n) 1./((x.^n).*(x+10));
%create analytical results
An = zeros(N,1);
An(1) = Pn(1);
for  i = 1:N-1
    fn = @(x) f(x,i+1);
    An(i+1) = integral(fn,1,Inf);
end
%Display comparision
disp([Pn,An]);