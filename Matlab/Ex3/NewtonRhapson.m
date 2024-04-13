%Newton-Raphson for arbitary functions.
%For f(x) = x^2 - R the iteration;
%x_(x+1) = x_n . (x_(n)^2 - R) / (2*x_(n))
%Define f(x) and f'(x)
f = @(x,R) x.^2 - R;
df = @(x) 2.*x;
%Set initial guess not too far away from sqrt(R)
x0 = 0.7;
%Stopping threshold
tol   = 1e-10;
xOld  = x0;
xNew  = x0;
Diff  = 1000;
%Set R
R = 144;
%NR iteration
while (abs(Diff) > abs(xOld) * tol)
    %Calculate new x.
    xNew = xOld - f(xOld,R)/df(xOld);
    Diff = abs(xNew - xOld);
    xOld = xNew;
end
%Compare with real root
disp(abs(sqrt(R) - xNew)/abs(sqrt(R)));






