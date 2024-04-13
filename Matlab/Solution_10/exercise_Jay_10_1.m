%% initial conditions
L = 1/2;
D_x = 0.001;
D_y = 0.001;
A = 2;
B = 5.1;
h = L/50;
tau = h^2 / (10 * max(D_x,D_y));
t0 = 0;
tf = 10;
N = (tf - t0)/tau;
n1 = (L-(-L))/h + 2;
n2 = N;
X = zeros(n1,n2);
Y = zeros(n1,n2);
X(:,1) = A + randn(n1,1)*A/10;
Y(:,1) = B/A + randn(n1,1)*(B/A)/10;


%% implementation of the partial differential equation
D = @(x) abs(x)<=L; 
x = -L;
t = t0;
%S_x = zeros(n1,n2);
%S_y = zeros(n1,n2);

for j = 1 : n2
    for i = 2 : n1 -1
        S_x = A - ( B + 1 ) * X(i,j) + X(i,j)^2 * Y(i,j);
        S_y = B * X(i,j) - X(i,j)^2 * Y(i,j);
        X( i , j + 1 ) = X(i,j) + ( tau / h^2 ) * [ D( x + h/2 ) * D_x ] * (X( i+1 , j ) - X( i , j )) + ( tau / h^2 ) * [ D( x - h/2 ) * D_x ] * (X( i-1 , j ) - X( i , j )) + tau * S_x;
        Y( i , j + 1 ) = Y(i,j) + ( tau / h^2 ) * [ D( x + h/2 ) * D_y ] * (Y( i+1 , j ) - Y( i , j )) + ( tau / h^2 ) * [ D( x - h/2 ) * D_y ] * (Y( i-1 , j ) - Y( i , j )) + tau * S_y;
        x = x + h;
    end
    t = t + tau;
    x = -L;
end

figure;
mesh (X);
title('Plot for X on  A = 2, B = 4, D_x = 0.001, D_y = 0.001 ');

figure;
mesh (Y);
title('Plot for Y on  A = 2, B = 4, D_x = 0.001, D_y = 0.001 ');

