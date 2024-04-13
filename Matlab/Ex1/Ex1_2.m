clc;
clear;
close;

% Program determines the largest positive number n such that 1+2^(-n) > 1
e2 = 1;
n1 = 0;
res = 1 + e2;
while res ~= 1
    n1 = n1+1;
    e2 = e2/2;
    res = 1 + e2;
end
n1 = n1 - 1;
fprintf('Type 1+2^-n:\n\tLargest positive number (n) for the type 1+2^-n : %i', n1);
fprintf('\n\tLargest number (n) for the type 2^-n : %e\n', 2^-n1);

% Program determines the largest positive number n such that 1+10^(-n) > 1
e10 = 1;
n2 = 0;
res = 1 + e10;
while res ~= 1
    n2 = n2+1;
    e10 = e10/10;
    res = 1 + e10;
end
n2 = n2 - 1;
fprintf('\nType 1+10^-n:\n\tLargest positive number (n) for the type 1+10^-n : %i', n2);
fprintf('\n\tLargest number (n) for the type 10^-n : %g\n', 10^-n2);
fprintf('\n\tSystem Floating-point relative accuracy %e\n', eps(1));

