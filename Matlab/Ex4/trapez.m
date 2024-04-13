%
% trapez.m
%
% numerical integration of func(x) between the limits a and b
% computation of approximations using the trapezoidal rule
%     for n=0: initialization of T_1
%         n>0: T_N -> T_2N , where 2N = 2^n
%
function [T2N] = trapez(func,a,b,TN,n)

if n < 0
      error('negative n in trapez');
elseif n == 0                % only one interval
      T2N = .5*(b-a)*(feval(func,a) + feval(func,b));
else
      h = (b-a)/2^n;          % new step size
      T2N = 0;
      for x=a+h:2*h:b        % sum over new (internal) points
            T2N = T2N + feval(func,x);
      end
      T2N = h*T2N + .5*TN;    % new approximation
end