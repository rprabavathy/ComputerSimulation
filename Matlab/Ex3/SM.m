%Secant method
%Define the function
f = @(x,b) tanh(6*b*x) - x;
%Define actual root
xT = 0.24062696159132;
%Define initial interval
x0 = 0.1;
x1 = 0.5;
%Stoppng threshold
tol = 1e-14;
%Set beta
beta = 0.17;
%Maximum number of iteration
nMax = 1000;
%Calculate intial error
Err = zeros(1,nMax);
Err(1) = abs(x1 - xT)/abs(xT);
ERR = Err(1);
%Secant iteration
i = 1;
while(ERR > tol && i <= nMax)
    %Numerator term
    f1 = f(x1,beta);
    %Denominator term
    f2 = f(x1,beta) - f(x0,beta);
    if(f2 == 0)
        break;
    end
    %calculate new x 
    x2 = x1 - (x1 - x0)*f1/f2;
    Err(i+1) = abs(x2 - xT)/abs(xT);
    ERR = Err(i+1);
    %Advance to next step
    x0 = x1;
    x1 = x2;
    i = i+1;
    
end
Err  = Err(1:i-1);
%plot results 
ErrN  = Err;
ErrNN = circshift(ErrN,-1);
ErrN  = ErrN(1:end -1);
ErrNN = ErrNN(1:end -1);
figure;
loglog(ErrN,ErrNN,'ko');
xlabel('\delta_{n}','Fontsize',15);
ylabel('\delta_{n+1}','Fontsize',15);
title('Secant Method','Fontsize',16);
%Exponent = 1.616 -> Supra - linear Convergence
alpha = (log10(ErrNN(end)) - log10(ErrNN(end-4))) / (log10(ErrN(end)) - log10(ErrN(end-4)));
fprintf('Convergence exponent is %.5f\n',alpha);












