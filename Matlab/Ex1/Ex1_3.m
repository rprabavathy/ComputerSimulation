% Numerical derivative of func f(x) of Order h^4
% Taylor expansion f(x+/-h) = (f^(n)(x)/n!)(+/-)^n * h^n

fprintf('Exercise 1.3 and 1.4');
h = 10.^(-(1:10)); % set step-sizes

% Define Derivative 
% Asymmetric Derivative
diff_h1 = @(f,x,d) (feval(f,x+d) - feval(f,x-d))/d;

% Symmetric Derivative
diff_h2 = @(f,x,d) ((8*(feval(f,x+d) - feval(f,x-d))) - (feval(f,x+2*d) - feval(f,x-2*d)))/12*d;
