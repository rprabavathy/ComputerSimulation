%Exercise 9 FTCS Forward-time Center Space
%Prabavathy Rajasekaran (2130757)
% Anjaly Kuriakose(2132537)

%Initial Values
clc;
close all;
clear ;

L= 5;
h = 0.1;
M = (2*L/h) +2; % -L <= x <= +L  
tau = 0.001;
N = 2000;
u = zeros(N,M);
%e = zeros(N,M);
S = zeros(N,M);

%part 1 with source S(x,t)=0 and nonConstant D(x) = 0 when abs(x)>L
x = -L-h:h:L;
u(1,:) =  1 .* (abs(x) < 1.5);

x = -L-h/2:h:L+h/2;
D = abs(x)<=L; 

for t = 1:N-1
    for x = 2:M-1
        u(t+1,x) = u(t,x) + (tau/h^2)*D(x+1)*(u(t,x+1)-u(t,x)) + (tau/h^2)*D(x-1)*(u(t,x-1)-u(t,x)) + tau*S(t,x);
    end
end
figure;
mesh(u);
title('S(x,t)=0 and D(x)=1');

%Part 2 Exact Solution Implementation
D=1;
x = -L-h:h:L;
t=0:tau:(N-1)*tau;
t=t.';
e= 0.5.*(erf((1.5-x)./(2.*sqrt(D*t))) - erf((-1.5-x)./(2.*sqrt(D*t))));

figure;
mesh(e);
title('Exact Solution');
 

%part 3 with source S(x,t) = -4 when (x<0.1 and 0.1<t<0.6) and nonConstant
%D(x) = 1 - abs(x)/10
u1 = zeros(N,M);
x = -L-h:h:L;
u1(1,:) =  1 .* (abs(x) < 1.5);

%t=(0:tau:(N-1)*tau).';
%S1 = -4.*(x<0.1 & 0.1 <t & t<0.6);

S1 = @(t,x) -4*(abs(x)<0.1 && t>0.1  && t<0.6);

%x = -L+h/2:h:L+h/2;
D = @(x) (1 -(abs(x)/10))*(abs(x)<=L); 

for t1 = 1:N-1
    for x1 = 2:M-1
        u1(t1+1,x1) = u1(t1,x1) + (tau/h^2)*D(-L+x1*h +(h/2))*(u1(t1,x1+1)-u1(t1,x1)) + (tau/h^2)*D(-L+x1*h-(h/2))*(u1(t1,x1-1)-u1(t1,x1)) + tau*S1(t1*tau,-L+(x1*h));
        disp(-L+x1*h);
    end
end

figure;
%mesh(u1);
[z1,z2] = meshgrid(-L-h:h:L,0:tau:(N-1)*tau);
mesh(z1,z2,u1);
title('with change in S(x,t) and D(x)');




