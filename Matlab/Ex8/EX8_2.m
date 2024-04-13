close all;
%initial condotion
y0 = [[1 -1 0], [1 3 0], [-2 -1 0], [0 0 0],[0 0 0],[0 0 0] ];

%use RK45
[y,T] = RK45(@(t,y) f(t,y),0.05,[0,10],y0);

%Extract the 3d poistion of the three bodies
x1 = y(1:3,:);
x2 = y(4:6,:);
x3 = y(7:9,:);

%find the minimal distance at each time
mindist = zeros(1,length(x1(1,:)));

for l = 1:length(x1(1,:))

    x12 = norm(x1(:,l) - x2(:,l));
    x13 = norm(x1(:,l) - x2(:,l));
    x23 = norm(x1(:,l) - x2(:,l));
    mindist(l) = min([x12, x13, x23]);

end

figure;
plot(x1(1,:),x1(2,:),'k.');
hold on;
plot(x2(1,:),x2(2,:),'r.');
hold on;
plot(x3(1,:),x3(2,:),'b.');
xlabel('x');
xlabel('y');
legend('x_1','x_2','x_3');

figure;
subplot(2,1,1);
semilogy(T(1:end-1),diff(T),'k.')


function [y, T] = RK45(f,tau,int,y0)
    %Set global relative precision
    PrecGoal = 1e-10;
    %Set accuracy factor
    SecFac = 0.9;
    %Minimum tau possible
    tauMin = 1e-9;
    GoalReached = true;
    
    %Set initial condition
    y(:,1) = y0(:);
    t = int(1);
    T(1) = t;
    %Solve over time interval
    k = 2;
    while t < int(2)
        %Find a suitable step size
        accepted = false;
        while ~accepted
            %if last step is outside time interval
            if t + tau > int(2)
                tau = int(2) -t;
            end
            %Calculate the k vector

            k1 = tau.*f(T(k -1),y(:,k -1));
            k1 = k1(:);
            k2 = tau.*f(T(k -1) + (2/9)*tau  ,y(:,k -1) + (2/9).*k1(:));
            k2 = k2(:);
            k3 = tau.*f(T(k -1) + (1/3)*tau  ,y(:,k -1) + (1/12).*k1(:)   + (1/4).*k2(:));
            k3 = k3(:);
            k4 = tau.*f(T(k -1) + (3/4)*tau  ,y(:,k -1) + (69/128).*k1(:) - (243/128).*k2(:) + (135/64).*k3(:));
            k4 = k4(:);
            k5 = tau.*f(T(k -1) + tau        ,y(:,k -1) - (17/12) .*k1(:) + (27/4).*k2(:)    - (27/5).*k3(:)    + (16/15).*k4(:));
            k5 = k5(:);
            k6 = tau.*f(T(k -1) + (5/6)*tau  ,y(:,k -1) + (65/432).*k1(:) - (5/16).*k2(:)    + (13/16).*k3(:)   + (4/27).*k4(:)   + (4/144).*k5(:));
            k6 = k6(:);
            r4 =(1/9).*k1(:) + (9/20).*k3(:) + (16/45).*k4(:) + (1/12).*k5(:);
            r5 =(47/450).*k1 + (12/25).*k3 + (32/225).*k4 + (1/30).*k5 + (6/25).*k6;
            
            I = r5 ~= 0;
            Delta = max(abs(r5(I) - r4(I))./ abs(y(I,k-1) + r5(I)));
            if Delta > PrecGoal
                %Need to repeat step calculation
                tau = tau * SecFac*(PrecGoal/Delta)^(1/5);
                %step-size could be too small
                if tau < tauMin
                    GoalReached = false;
                    fprintf('Warning too small...\n');
                    break;
                end
            else
                accepted = true;
                t = t + tau;
                tau = 1.5*tau;
            end
           end
        T(k) = t;
        y(:,k) = y(:,k-1)  + r5;
        k = k + 1;
        end
        
    end


function dydt = f(t,y)


m1 = 5;
m2 = 3;
m3 = 4;

y = y(:);
x12 = y(1:3) - y(4:6);
x13 = y(1:3) - y(7:9);
x23 = y(4:6) - y(7:9);

dx12 = norm(x12)^3;
dx13 = norm(x13) ^3;
dx23 = norm(x23)^3;

dydt = [y(10:18) ; -m2*x12/dx12 - m3*x13/dx13;...
                   +m1*x12/dx12 - m3*x23/dx23;...
                   +m1*x13/dx13 + m2*x23/dx23];


end












