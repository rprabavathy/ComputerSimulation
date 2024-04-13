% Exercise 10 part 2 : temperature

% Set start of equilibrium phase.
ntherm = 0.75*nsteps;

% Measure temperature in natural units.
kBT = temperature(VX(ntherm:end),VY(ntherm:end));
% Convert it in Kelvin:
% Natural units -> kB x T is in units of epsilon.
% Convert to physical units:
% E_k x epsilon = energy of the system = kB T_s
% E_k x kB * 120 = kB T_s
% E_k x 120 = T_s
temp_nat = kBT;
temp_kelvin = temp_nat*120;
% Print results.
fprintf('Temperature: Natural units = %.6g, Kelvin = %.6g K\n',temp_nat, temp_kelvin);
fprintf('Normalization is necessary because a histogram just counts number of occurance in an interval but we need to change them to suit the pdf');
fprintf('Value = # occurance / (N*width)\n');

% Calculate magnitude of velocities.
V = sqrt(VX(:,ntherm:end).^2 + VY(:,ntherm:end).^2);
histogram(V(:), 20, 'Normalization','pdf');
hold on;
% Add the expected curve.
vels = linspace(min(V(:)),max(V(:)),1000);
P = (vels./kBT).*exp(-(vels.^2)./(2*kBT));
plot(vels,P);
xlabel('Velocity');
legend({'Data','Expected distribution'});

function kBT = temperature(VX,VY)
    kBT = mean(VX(:).^2 + VY(:).^2)/2;
end