clc;
close all;
clear all;
%define the differential equation
f = @(t,y) 0.1*y;
%define time interval and initial condition
t = 15;
y0 =1;
%Set defferent values of times
tau = 10.^[0:-0.1:-3];
%solve equation for each value of tau
valsRK4  = zeros(1,length(tau));
valsRK5 = zeros(1,length(tau));
globalRK4 = zeros(1,length(tau));
globalRK5 = zeros(1,length(tau));

for i=1:length(tau)
    yRK4        = RK4(f,tau(i),[0,t],y0);
    valsRK4(i)  = yRK4(2);
    globalRK4(i) = yRK4(end);

    yRK5        = RK5(f,tau(i),[0,t],y0);
    valsRK5(i)  = yRK5(2);
    globalRK5(i) = yRK5(end);
    
end
%Calculate exact solution at time t = 15
ySol = exp(0.1*tau);
ySolGlobal = exp(0.1*t);
%Calculate realtive local error
errRK4 = abs(ySol - valsRK4)./abs(ySol);
errRK5 = abs(ySol - valsRK5)./abs(ySol);
globalRK4 = abs(ySolGlobal - globalRK4) ./ abs(ySolGlobal);

globalRK5 = abs(ySolGlobal - globalRK5) ./ abs(ySolGlobal);

figure;
loglog(tau,errRK4,'ko');hold on;
loglog(tau,errRK5,'ro');


function y = RK5(f,tau,int,y0)
%Calculate number of times steps needed
    nsteps = ceil((int(2) - int(1))/tau);
    %allocate space for solution
    y = zeros(length(y0),nsteps);
    T = zeros(1,nsteps);
    %Set initial condition
    y(:,1) = y0;
    T(1) = int(1);
    %Integrals over time interval
    t = T(1);
    k = 2;

    while t < int(2)
    %if last stop lands outside the interval then reduce tau
    if t + tau > int(2)
        tau = int(2) - t;
    end
        t = t + tau;


        k1 = tau.*f(T(k -1),y(:,k -1));
        k2 = tau.*f(T(k -1) + (2/9)*tau  ,y(:,k -1) + (2/9).*k1);
        k3 = tau.*f(T(k -1) + (1/3)*tau  ,y(:,k -1) + (1/12).*k1   + (1/4).*k2);
        k4 = tau.*f(T(k -1) + (3/4)*tau  ,y(:,k -1) + (69/128).*k1 - (243/128).*k2 + (135/64).*k3);
        k5 = tau.*f(T(k -1) + tau        ,y(:,k -1) - (17/12) .*k1 + (27/4).*k2    - (27/5).*k3    + (16/15).*k4);
        k6 = tau.*f(T(k -1) + (5/6)*tau  ,y(:,k -1) + (65/432).*k1 - (5/16).*k2    + (13/16).*k3   + (4/27).*k4   + (4/144).*k5);
    
        y(:,k) = y(:,k -1) + (47/450).*k1 + (12/25).*k3 + (32/225).*k4 + (1/30).*k5 + (6/25).*k6;

        T(k) = t;
        k = k+1;

    end



end



function y = RK4(f,tau,int,y0)
%Calculate number of times steps needed
    nsteps = ceil((int(2) - int(1))/tau);
    %allocate space for solution
    y = zeros(length(y0),nsteps);
    T = zeros(1,nsteps);
    %Set initial condition
    y(:,1) = y0;
    T(1) = int(1);
    %Integrals over time interval
    t = T(1);
    k = 2;

    while t < int(2)
    %if last stop lands outside the interval then reduce tau
    if t + tau > int(2)
        tau = int(2) - t;
    end
        t = t + tau;


        k1 = tau.*f(T(k -1),y(:,k -1));
        k2 = tau.*f(T(k -1) + (2/9)*tau  ,y(:,k -1) + (2/9).*k1);
        k3 = tau.*f(T(k -1) + (1/3)*tau  ,y(:,k -1) + (1/12).*k1   + (1/4).*k2);
        k4 = tau.*f(T(k -1) + (3/4)*tau  ,y(:,k -1) + (69/128).*k1 - (243/128).*k2 + (135/64).*k3);
        k5 = tau.*f(T(k -1) + tau        ,y(:,k -1) - (17/12) .*k1 + (27/4).*k2    - (27/5).*k3    + (16/15).*k4);
        %k6 = tau.*f(T(k -1) + (6/5)*tau  ,y(:,k -1) + (65/432).*k1 - (5/16).*k2    + (13/16).*k3   + (4/27).*k4   + (4/144).*k5);
        y(:,k) = y(:,k -1) + (1/9).*k1 + (9/20).*k3 + (16/45).*k4 + (1/12).*k5;
        %y(:,k) = y(:,k -1) + (47/450).*k1 + (12/25).*k3 + (32/225).*k4 + (1/30).*k5 + (6/25).*k6;

        T(k) = t;
        k = k+1;

    end



end















