clc;
clear;
D = @(x) 1;
S = @(x,t) 0;
L = 5;
h = 0.1;
N = 2000;
tau = 0.001;
u0 = zeros(1,2*L/h);
dim = ftcs(D,S,u0,L,h,tau,N);

figure;
mesh(dim);

% error_result = error_function(D,N,L,h);
% disp(error_result);
function u = ftcs(D, S, u0, L, h, tau, N)
    u = zeros(N,numel(u0)+2);
    u(2,2:end-1) = u0;
    for t= 1:N
        for x=2:2*L/h+2 -1    
            temp1 = ((tau/h^2)*D(x+(h/2))) * (u(t,x+1)-u(t,x));
            temp2 = ((tau/h^2)*D(x-(h/2))) * (u(t,x-1)-u(t,x));
            u(t+1,x) = u(t,x) + temp1 + temp2 + tau*S(t,x);
        end
    end 
end


