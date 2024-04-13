% Exercise 9: Moon Landing
clear variables;

%% Constants
global Rearth Rmoon Mmoon Mearth rs omega crashed;
Rearth  =   0.734078492664;
Rmoon   =   59.6805814534;
Mmoon   =   20/81.3;
Mearth  =   20;
rs      =   1.06;
omega   =   2*pi/(27.322*24);
crashed =   0;
step    =   0.05;

%% Asking for the initial conditions.
%(6,250) -> Orbiting without landing.
%(6.1,230) -> Lands on the Moon.
disp('Use v_O = 6.1, alpha = 230 for moon landing.');
disp('Use v_O = 6, alpha = 250 for an orbit around the Earth without landing.');
vO      =   input(' Initial velocity vO (EU/h) ? ');
alpha   =   input(' Initial angle alpha(Grad) ? ')*pi/180;

YO      =   [(rs*cos(alpha))-Rearth;
            rs*sin(alpha);
            -vO*sin(alpha);
            vO*cos(alpha)];
trajectory  =   [];

%% Create figure and plot orgin.
figure();
axis equal;
plot(0,0); hold on;
axis equal;
xlim([-60,60]);
ylim([-60,60]);

%% Set relative precision.
options = odeset('RelTol',1e-6,'AbsTol',1e-6);

%% Iteration over 28 days
t = 0;
ind = 1;
for day =   1:27
    % Set time interval.
    interval    =   t:step:t+24;
    % integrate over 24 hrs
    [T,Y]       =   ode45(@(t,y) f(t,y), interval, YO,options);
    % Compute positions of the Moon and Earth in these 24 hours.
    for tt  =   t:step:t+24
        vecEarth        =   posEarth(tt);
        vecMoon         =   posMoon(tt);
        r_EarthX(ind)   =   vecEarth(1);
        r_EarthY(ind)   =   vecEarth(2);
        r_MoonX(ind)    =   vecMoon(1);
        r_MoonY(ind)    =   vecMoon(2);
        ind             =   ind+1;
    end
    % Update global time.
    t   =   t+24;
    % Set initial conditions for the next day.
    YO          =   [Y(round(24/step),1);
                     Y(round(24/step),2);
                     Y(round(24/step),3);
                     Y(round(24/step),4)];
    % Plot celestial bodies.
    trajectory  =   [trajectory;Y(:,1),Y(:,2)];
    % Plot the Moon, Earth and Satellite.
    clf;
    plot(r_MoonX,r_MoonY,'k--'); hold on;
    plot(r_EarthX,r_EarthY,'b--');
    plot(trajectory(:,1),trajectory(:,2),'r--');
    plot(r_MoonX(ind-1),r_MoonY(ind-1),'k.');
    plot(r_EarthX(ind-1),r_EarthY(ind-1),'b.');
    xlim([-60,60]);
    ylim([-60,60]);
    drawnow;
    pause(0.5);
    % Step if crashed or landed.
    if crashed == 1
        break;
    end
end
hold off;

function    r   =   posEarth(t)
    global Rearth omega;
    % Calculate position in circular orbit.
    r(1)    =   -Rearth*cos(omega*t);
    r(2)    =   -Rearth*sin(omega*t);
end

function    r   =   posMoon(t)
    global Rmoon omega;
    % Calculate position in circular orbit.
    r(1)    =   Rmoon*cos(omega*t);
    r(2)    =   Rmoon*sin(omega*t);
end

function dydt   =   f(t,y)
    global Mearth Mmoon crashed;
    % Calculate position of the Earth and Moon.
    rEarth      =   posEarth(t);
    rMoon       =   posMoon(t);
    % Calculate distance to both Earth and Moon.
    distMoon    =   norm([rMoon(1)  - y(1), rMoon(2)  - y(2)]);
    distEarth   =   norm([rEarth(1) - y(1), rEarth(2) - y(2)]);
    % Check if it crashes on Earth.
    if  distEarth   <=  1
        % If it hasn't crashed/landed yet.
        if  crashed ==  0
            fprintf('Satellite crashed on the Earth.\n');
            crashed =   1;
        end
        % Set velocity and acceleration to 0.
        dydt    =   [0;0;0;0];
        return;
    end
    % Check if it lands on the moon.
    if distMoon <=  3500/6400
        % If it has not crashed/landed.
        if  crashed ==  0
            fprintf('Satellite landed!\n');
            crashed =   1;
        end
        dydt    =   [0;0;0;0];
        return;
    end

    % If trajectory continues.
    dydt    =   [y(3);
                 y(4);
                 -Mearth*(y(1)  -   rEarth(1))/(distEarth^3)    -   Mmoon*(y(1) -   rMoon(1))/(distMoon^3);
                 -Mearth*(y(2)  -   rEarth(2))/(distEarth^3)    -   Mmoon*(y(2) -   rMoon(2))/(distMoon^3)];
end