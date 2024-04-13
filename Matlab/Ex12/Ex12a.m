% Exercise 12.a: Gaussian elimination vs Householder.

% Test both methods with random matrix.
% Both methods should in principle work.
A = rand(100,100);
AH = A;
AG = A;
x = rand(100,1);
bH = A*x;
bG = A*x;
% Householder solution.
yH = householder(AH, bH);
% Gaussian elimination solution.
yG = gaussel(AG,bG);
% Compare them.
D = norm(yH - yG)/norm(yG);
fprintf('------------Random Matrix---------\n');
fprintf('Relative difference between solutions: %.4g\n',D);
D = norm(yH - x)/norm(x);
fprintf('Relative error of householder solution: %.4g\n', D);

% Test both methods with matrix that runs Gaussian elimination.
% Setting the first entry to 0 sabotages the Gaussian algorithm so only
% householder can be used here. Clear advantage if no pivoting is used.
A = rand(100,100);
A(1,1) = 0;
x = rand(100,1);
b = A*x;
yH = householder(A,b);
D = norm(yH - x)/norm(x);
fprintf('---------Special matrix---------\n');
fprintf('Relative error of Householder solution: %.4g\n', D);

% Compare errors as function of problem size.
errGauss = zeros(1,100);
errHouse = zeros(1,100);
for n = 2:100
    % Create matrix.
    A = rand(n);
    % Create solution.
    x = rand(n,1);
    % Create right-hand side.
    b = A*x;
    % Solve with Gaussian elimination.
    AG = A;
    bG = b;
    yG = gaussel(AG,bG);
    errGauss(n) = norm(yG - x)/norm(x);
    % Solve with Householder reduction.
    AH = A;
    bH = b;
    yH = householder(AH, bH);
    errHouse(n) = norm(yH - x)/norm(x);
end
% Plot the error vs problem size.
figure();
loglog(2:100,errGauss(2:100),'k.');hold on;
loglog(2:100,errHouse(2:100),'r.');
xlabel('n','FontSize',17);
ylabel('\delta','FontSize',17);
legend({'Gauss','Householder'});
% Numerical stability of householder allows it to beat Gauss elimination.

% Calculate computational cost.
CountRatio = zeros(1,200);
for n = 2:200
    A = rand(n);
    x = rand(n,1);
    b = A*x;
    % Gaussian elimination.
    AG = A;
    bG = b;
    countGauss = gaussel_counter(AG,bG);
    % householder reduction.
    AH = A;
    bH = b;
    countHouse = householder_counter(AH, bH);
    % Find ratio.
    CountRatio(n) = countHouse / countGauss;
end
% Plot ratio of costs.
figure();
plot(2:200,CountRatio(2:200),'k.');
xlabel('n','FontSize',17);
ylabel('Cost Ratio','FontSize',17);
% The ratio becomes 2 for large matrices ---> Householder is twice as
% expensive.