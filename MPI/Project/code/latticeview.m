clear all; clear; clc;
L0 = 600;  % number of lattice sites in x-direction
L1 = 150;  % number of lattice sites in y-direction
a = 0.1;   % lattice spacing

% Initialize arrays as 2D matrices
x = zeros(L1, L0);
y = zeros(L1, L0);

%2D lattice Setup
for l1=1:L1
    for l0=1:L0
        if mod(l1-1,2)==0
            %l = l0+L0*(l1-1);
            x(l1,l0) = (l0-1)*a;
            y(l1,l0) = (l1-1)*0.5*a;
        else
             %l = l0+L0*(l1-1);
             x(l1,l0) = (l0-1)*a+0.5*a;
             y(l1,l0) = (l1-1)*0.5*a;
        end
    end
end
% Resultant Matrix with Particle state after Collision and Streaming
% Particle states are in decimal form. Obstacle Number (here) is 64.
obstacle2d = readMat('output_1.bin',L1, L0, 'int');
obstacle2d([1, end], :) = 64; obstacle2d(:, [1, end]) = 64;

% Matrix acts as flag to identify the obstacle point and boundaries
% 1 - fluid 0 - obstacle/Boundary -- Exclude these points while averaging
% the velocity
obstacle = ones(L1,L0);
obstacle_indices = find(obstacle2d == 64);
obstacle(obstacle_indices) = 0;

figure;

voxelSize=15; % Blocks size
X = zeros(voxelSize, voxelSize);   Y = zeros(voxelSize, voxelSize);
VX = zeros(voxelSize, voxelSize);  VY = zeros(voxelSize, voxelSize);
% 2D Lattice Plot
plot(x,y,'k.','MarkerSize',1); hold on;
for t = 1:50
    xFile = sprintf('velocityX_%d.bin', t);
    yFile = sprintf('velocityY_%d.bin', t);
    mass = sprintf('mass_%d.bin',t);
    % VelocityMatrix of each particle in X and Y direction
    VX2d = readMat(xFile,L1, L0,'double');
    VY2d = readMat(yFile,L1, L0,'double');
    m2d = readMat(mass,L1, L0,'int');
    % Averaging positions for each voxels excluding obstacles and boundary
    X= calculateMean(x, voxelSize, voxelSize, obstacle);
    Y= calculateMean(y, voxelSize, voxelSize, obstacle);
    % Averaging velocity for each voxels excluding obstacles and boundary
    VX= calculateMean(VX2d, voxelSize, voxelSize, obstacle);
    VY= calculateMean(VY2d, voxelSize, voxelSize, obstacle);
    Ma = calculateMean(m2d, voxelSize, voxelSize,obstacle);
    % 1. Quiver Plot (Animated)
    subplot(3, 1, 1);
    scatter(x(obstacle_indices), y(obstacle_indices), 20, 'red', 'filled'); hold on;
    quiver(X(:), Y(:), VX(:), VY(:), 'color', 'b', 'AutoScale', 'on', 'AutoScaleFactor', 0.5); hold off;
    xlim([min(X(:)), max(X(:))]);
    ylim([min(Y(:)), max(Y(:))]);
    title('Directional Velocity');
     

    % 2. Contour Plot
    subplot(3, 1, 2);
    xlim([min(X(:)), max(X(:))]);
    ylim([min(Y(:)), max(Y(:))]);
    speed = sqrt(VX.^2 + VY.^2);
    contourf(X, Y, speed);
    colorbar;
    title('Norm Velocity');

    % 2. Mass Plot
    subplot(3, 1, 3);
    xlim([min(X(:)), max(X(:))]);
    ylim([min(Y(:)), max(Y(:))]);
    contourf(X, Y, Ma);
    colorbar;
    title('Mass or Density Plot(without Normalization)');

    % Adjust the layout
    sgtitle(['Fluid Flow Visualization - Time Step ' num2str(t*100)]);

    % Pause to control the animation speed
    pause(0.1);
    drawnow;
end


%Averging each blocks without considering Obstacle and Boundaries
function A = calculateMean(inputMatrix, subMatX, subMatY, obstacle)
    inputMatrix = inputMatrix .* obstacle;
    A = conv2(inputMatrix,ones(subMatX,subMatY),'valid');
    A = A(1:subMatX:end,1:subMatY:end);
    
    obstacleA = conv2(obstacle,ones(subMatX,subMatY),'valid');
    obstacleA = obstacleA(1:subMatX:end,1:subMatY:end);
    A = A./obstacleA;
end

% To read a binary file
function C= readMat(fname,m,n,type)
   fid = fopen(fname,'r');
   c = fread(fid,m*n,type);
   fclose(fid);
   C = reshape(c,n,m).';
end
