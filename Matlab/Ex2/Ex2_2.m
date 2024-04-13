%Exercise 2.2
%set beta and exact solution
beta = 0.17;
x_t = 0.24062696159732;
%set initial guess
x_0 = 0.2;
x_n = x_0;
n = 1;
delta(1) = abs(x_0 - x_t)/abs(x_t);
%start iterating
while delta(n) > eps && n <= 1400
    % calculate new estimate
    x_nn = tanh(6*beta*x_n); 
    %calculate new error
    delta(n+1) = abs(x_nn - x_t)/abs(x_t);
    %Advance to new iteration
    x_n = x_nn;
    n = n+1;
end
%plot the results
figure();
semilogy(1:length(delta),delta,'b');
ylabel('\delta_n','FontSize',15);
xlabel('n');
%print number of iterations needed to achieve machine precision
disp(n);
%print number of iterations needed according to formula
n_t = -16 / log10((6*beta)/(cosh(6*beta*x_t)^2));
disp(n_t);