
% Ex 1.1
% Program determines the largest positive number n2 of the form 2^n1 
% is not equal to infinity
res = 2^0;
n1 = 0;
while ~isinf(res)
    n1 = n1+1;
    res = res * 2;
end

fprintf('\tLargest positive number (n) for the type 2^n1 : %i\n', n1 -1);


% Program determines the smallest positive number n2 of the form 2^-n2 
% is not equal to zero
res = 2^0;
n2 = 0;
while res > 0
    n2 = n2+1;
    res = res / 2;
end
fprintf('\n\tSmallest positive number (n) for the type 2^-n2 : %i\n', n2 -1);
