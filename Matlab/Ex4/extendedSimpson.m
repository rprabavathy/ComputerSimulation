function I = extendedSimpson(f,a,b,N)
%N > 2: amount of subIntervals
%Calculate the step size
h = (b-a)/(N);
%find equally spaced sampling points
samplingPoints = a:h:b;
%Evaluate the function in the sample points
evalatedPoints = arrayfun(f,samplingPoints);
%Calculate the coefficients
coeffs = ones(1,N+1);
coeffs(1:2:N+1) = 2;
coeffs(2:2:N+1) = 4;
coeffs(1) = 1;
coeffs(N+1) = 1;
coeffs = h/3.*coeffs;
%Calculate the integral according to the formula
I = dot(evalatedPoints,coeffs);

end