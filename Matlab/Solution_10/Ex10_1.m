 8e% Exercise 10.1 Coupled Non Linear Diffusion
%Prabavathy Rajasekaran (2130757)
% Anjaly Kuriakose(2132537)

clc;
clear all;
close all;

% Initial values
L = 1/2;
Dx = 0.001;
Dy = 0.001;
A = 2;
B = 5.1;
h = L/50;
M = (2*L/h)+2;

tau = h^2/(10*max(Dx,Dy));

N = (10-0)/tau;

X = zeros(M,N);
Y= zeros(M,N);

x = -L-h/2:h:L+h/2;
D = abs(x)<=L; 

X(:,1) =  A + randn(M,1) *A/10;
Y(:,1) =  B/A + randn(M,1) *(B/A)/10;
 
for t1 = 1:N-1
    for x1 = 2:M-1
        S_X= A-(B+1)*X(x1,t1)+X(x1,t1)^2 * Y(x1,t1); % Source term of X
        S_Y = B*X(x1,t1) - X(x1,t1)^2 * Y(x1,t1); % Source term of Y
        X(x1,t1+1) = X(x1,t1) + (tau/h^2)*D(x1+1)*Dx*(X(x1+1,t1)-X(x1,t1)) + (tau/h^2)*D(x1-1)*Dx*(X(x1-1,t1)-X(x1,t1)) + tau*S_X;
        Y(x1,t1+1) = Y(x1,t1) + (tau/h^2)*D(x1+1)*Dy*(Y(x1+1,t1)-Y(x1,t1)) + (tau/h^2)*D(x1-1)*Dy*(Y(x1-1,t1)-Y(x1,t1)) + tau*S_Y;
    end
end


figure;
mesh(X);
title({'Substance X(x,t)', 'Constant Concentration of substance A=2 , B=5.1', 'Diffusion Constant D_X=D_Y = 0.001'});
figure;
mesh(Y);
title({'Substance Y(x,t)', 'Constant Concentration of substance A=2 , B=5.1', 'Diffusion Constant D_X=D_Y = 0.001'});
