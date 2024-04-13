% Exercise 10 Part 3: Freesing.

% Set size of box.
L = 8;
% Number of particles.
N = 5*5;
% Initial positions: Particles in square grid.
x = zeros(N,1);
y = zeros(N,1);
ind = 1;
for i = 1:sqrt(N)
    for j = 1:sqrt(N)
        % Put particles in a grid.
        x(ind) = i;
        y(ind) = j;
        ind = ind + 1;
    end
end

% Initial velocities: Random between 0 and 1.
vx = 2.*rand(N,1) - 1;
vx = vx - mean(vx);
vy = 2.*rand(N,1) - 1;
vy = vy - mean(vy);

% Time interval.
T = 500;
tau = 0.005;
nsteps = fix(T/tau);

% Integrate using Leap-Frog.
[X,Y,VX,VY] = leapfrog_freeze(x,y,vx,vy,L,tau,nsteps);

% Plot the positions to see crystallization: Hexagonal crystal.
figure();
plot(X(:,end),Y(:,end),'k*');
xlabel('x');
ylabel('y');

% Get lattice spacing.
a = minDist(X(:,end),Y(:,end));
fprintf('Crystal: Hexagonal. Lattice constant is %.3g in natural units and %.4g in Angstrom.\n',a,a*3.4);

function [X,Y,VX,VY] = leapfrog_freeze(x,y,vx,vy,L,tau,nstep)
    N = length(x); % number of particles
    X = zeros(N,nstep+1); Y = zeros(size(X));
    VX = zeros(N,nstep+1); VY = zeros(size(X));
    
    X(:,1) = x; Y(:,1) = y;      % start value
    VX(:,1) = vx; VY(:,1) = vy;
    
    for n=1:nstep
        X(:,n+1)=X(:,n)+tau*VX(:,n); % positions: n*tau -> (n+1)*tau
        Y(:,n+1)=Y(:,n)+tau*VY(:,n); % using v evaluated at (n+1/2)*tau
        % reflections of particles at the box boundaries:
        for i=1:N
            if X(i,n+1)<0, X(i,n+1)=   -X(i,n+1); VX(i,n)=-VX(i,n); end
            if X(i,n+1)>L, X(i,n+1)=2*L-X(i,n+1); VX(i,n)=-VX(i,n); end
            if Y(i,n+1)<0, Y(i,n+1)=   -Y(i,n+1); VY(i,n)=-VY(i,n); end
            if Y(i,n+1)>L, Y(i,n+1)=2*L-Y(i,n+1); VY(i,n)=-VY(i,n); end
        end
    
        [fx,fy]=LJforce(X(:,n+1),Y(:,n+1));
    
        VX(:,n+1)=VX(:,n)+tau*fx; % momenta: (n+1/2)*tau -> (n+3/2)*tau
        VY(:,n+1)=VY(:,n)+tau*fy; % using fx,fy evaluated at (n+1)*tau
        % If even step then freeze.
        if mod(n,2) == 0
            VX(:,n+1) = VX(:,n+1)*0.5;
            VY(:,n+1) = VY(:,n+1)*0.5;
        end
    end
end


% Find distance to nearest neighbour.
function mindist = minDist(X,Y)
    % Allocate vector of minimal distances.
    N = length(X);
    mindist = zeros(N,1);
    % Iterate over N atoms.
    for i = 1:N
        d = zeros(N-1,1);
        id = 1;
        for j = 1:N
            if i ~= j
                d(id) = norm( [X(i) - X(j), Y(i) - Y(j)]);
                id = id + 1;
            else
                continue;
            end
        end
        mindist(i) = min(d);
    end
    % Get average of minnimal distances/
    mindist = mean(mindist);
end