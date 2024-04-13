% Exercise 10 Part 1: Energies

% Set size of box
L=6;
% Number of particles.
N = 5*5;
% Initial positions: Particles in square grid.
x = zeros(N,1);
y = zeros(N,1);
ind = 1;
for i = 1:sqrt(N)
    for j = 1:sqrt(N)
        % Put particales in a grid.
        x(ind) = i;
        y(ind) = j;
        ind = ind + 1;
    end
end

% Initial velocities: Random between 0 & 1.
vx = 2.*rand(N,1) - 1;
vy = 2.*rand(N,1) - 1;

% Time interval.
T = 80;
tau = 0.001;
nsteps = fix(T/tau);

% Integrate using leap-frog
[X,Y,VX,VY] = leapfrog(x,y,vx,vy,L,tau,nsteps);

% Calculate energies.
[Ekin, Epot] = Energies(X,Y,VX,VY);

% Plot energies.
figure();
plot(0:tau:T-tau,Ekin,'r-');
hold on;
plot(0:tau:T-tau, Epot);
plot(0:tau:T-tau, Ekin + Epot);
legend({'E_(kin)','E_(pot)', 'E_(total)'});
xlabel('Time [AU]');
ylabel('Energy [AU]');

function [Ekin, Epot] = Energies(X,Y,VX,VY)
    % Calculate Kinectic energy.
    Ekin = 0.5*sum(VX.^2 + VY.^2,1)';
    % Average between neighbouring times to 'centralize' time.
    Ekin = (Ekin(1:end-1) + Ekin(2:end))./2;
    % Calculate potential Energy.
    % Get number of particles and time steps.
    [N,tsteps] = size(X);
    Epot = zeros(tsteps,1);
    % Iterate over pairs of particcles without repeating.
    for i = 2:N
        for j = 1:i-1
            % Calculate inter-particle distance in each value of time.
            r = sqrt( (X(i,:)-X(j,:)).^2 + (Y(i,:)-Y(j,:)).^2);
            % Calculate LJ potential.
            V = 4*((1./r).^12 - (1./r).^6);
            % Update sum of potential energy.
            Epot = Epot + V.';
        end
    end
    % Take only the potential energies that have a matching kinectic
    % energy.
    Epot = Epot(2:end);
end