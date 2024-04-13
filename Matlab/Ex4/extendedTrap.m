function I = extendedTrap(func,a,b,N)
%define the step size
h = (b-a)/(N);
%Generate equally spaced sampling points
samplePoints = a:h:b;
%Evaluate the function in the sample points
evalPoints = arrayfun(func,samplePoints);
%Generate the array of coefficients
coeffs(1) = 1;
coeffs(N+1) = 1;
coeffs(2:N) = 2.*ones(1,N-1);
%Calculate the integral according to the trapezoidal formula
I = 0.5*h*dot(evalPoints,coeffs);

end