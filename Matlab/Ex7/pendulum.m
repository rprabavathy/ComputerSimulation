%set relavant constant
g = 9.81;
l = 1; 
%set the number of points
N=100000;
%set the time step size
h=10/(N-1);
%Array of time
t=0:h:10;
%Initial conditions
y = zeros(N, 1);
yP = zeros(N, 1);
y(1)=0.45;
yP(1)=0;
%implement explicit Euler
for n=2:N
    %calculate new Position
    y(n) = y(n-1) + h.* yP(n-1);
    yP(n) = yP(n-1) -(g*h/l).*sin(y(n-1));
end
%Calculate period T with approximation
T=(sqrt(g/l)/(2*pi))^(-1);
fprintf('Initial angle is small -ish so period should be close to %.4f seconds.\n',T);
% plot results
figure(1);
plot(t,y,'k');
xlabel('t {s}');
ylabel('\phi(t)','FontSize',14);
title('No Friction','FontSize',14);
figure(2);
%y(t) vs y'(t) i.e Phase Space
plot(yP,y,'k');
xlabel('d\phi /dt','FontSize',14);
ylabel('\phi(t)','FontSize',14);
title('No Friction','FontSize',14);
%Add air friction
rho = 0.12; %s^-1
y2 = zeros(N, 1);
y2P = zeros(N, 1);
y2(1)=0.45;
y2P(1)=0;
%implement explicit Euler
for n=1:N-1
    %calculate new Position
    y2(n+1) = y2(n) + h.* y2P(n);
    y2P(n+1) = y2P(n) -(g*h/l).*sin(y2(n))-rho*h*y2P(n);
end

figure(3);
%y(t) vs y'(t) i.e Phase Space
plot(y2P,y2,'k');
xlabel('d\phi /dt','FontSize',14);
ylabel('\phi(t)','FontSize',14);
title('\rho = 0.12 s^{-1}','FontSize',14);


