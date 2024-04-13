% ball.m - program for flying balls
% Euler Method, without friction
clear;  help ball;
%
r = [0 0]; % optional also as input argument
v0    = input(' Initial velocity v0 (m/sec) ? ');
theta = input(' Angle theta (degree) ? ')*pi/180; % converted in radians
tau   = input(' Time step tau (sec) ? ');
%
v = v0*[cos(theta) sin(theta)]; % v_0
g = 9.81; % g in m/sec^2
a = [0 -g]; % in this case constant acceleration
%
maxstep = 100000; % maximum number of steps
%
% main loop:
%
y(1,:) = [r(1) r(2) v(1) v(2)];  % initial values
t(1) = 0;
for istep=1:maxstep
   y(istep+1,:) = y(istep,:) + tau * [y(istep,3), y(istep,4), 0, -g];
   if( y(istep+1,2) < 0 )  % stop the loop, impact!
      break;
   end
end

fprintf(' Range: %g meters\n',y(istep+1,1));
fprintf(' Time of flight: %g seconds\n',(istep+1)*tau)
fprintf(' Maximal height: %g m\n',max(y(:,2)));

%
%  Plot:
%
% Ground line:
xground = [0 y(istep+1,1)]; yground = [0 0];
% Graph of the trajectory:
plot(y(:,1),y(:,2),'+',xground,yground,'-');
xlabel('Range (m)')
ylabel('Altitude (m)')
title('Flying ball')
%
% Compare with exact solution:
%
xmaxx = v0^2*sin(2*theta)/g;
tfl   = 2*v0*sin(theta)/g;
ymax  = v0^2/2/g*sin(theta)^2;
fprintf(' relative discrepancy in time of flight: %g \n',((istep+1)*tau-tfl)/tfl)
fprintf(' relative discrepancy in range         : %g \n',(y(istep+1,1)-xmaxx)/xmaxx)
fprintf(' relative discrepancy in maximal height: %g \n',(max(y(:,2))-ymax)/ymax)