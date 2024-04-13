%Anjaly Kuriakose(2132537)
%Prabavathy Rajasekaran(2130757)

% main program for Monte-Carlo simulation of the XY model with the
% Metropolis algorithm

global D L h theta beta

%%%%%%%%%%%%%%%%%%%%%% parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N_therm = 1000;  % thermalization sweeps
N_prod  = 5E3;   %10000; % production sweeps

beta = 1.5;       % inverse temperature
L    = 24;        %32;        % lattice size
D    = 2;         % dimension

%%%%%%%%%%%%%%%%%%%%%% geometry and initialization %%%%%%%%%%%%%%%%%%%%%%%%

vol = L^D;
h = hop();
theta = rand(vol,1);

%%%%%%%%%%%%%%%%%%%%%% thermalization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f = waitbar(0,'Thermalisation Calculation Progress');
for k=1:N_therm
    waitbar(k/N_therm,f, 'Thermalisation Calculation Progress');
    [~, ~] = sweep();
end
close(f)
plot_cnfg(theta);

%%%%%%%%%%%%%%%%%%%%%% production %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f = waitbar(0, 'Production Progress: Initialisation');

H   = zeros(N_prod,1);
M   = zeros(N_prod,1);
chi = zeros(N_prod,1);
acc = zeros(N_prod,1);
DH  = zeros(N_prod,1);
Iam1= zeros(N_prod,1);

Gtsim = zeros(N_prod*L/2,L);
temp1 = 1;
temp2 = L/2;
for k=1:N_prod
   waitbar(k/N_prod,f, 'Main Calculation Progress');
   [acc(k), Iam1(k)] = sweep();
   H(k)   = energy(theta);
   M(k)   = magnetization(theta);
   chi(k) = susceptibility(theta);
   G_tsim(temp1:temp2,:) = correlation_Function();
   temp1 = temp1 + L/2;
   temp2 = temp2 + L/2;
end
close(f);

%%%%%%%%%%%%%%%%%%%%%% data analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Data analysis for correlation function Gtsim
for i1 = 1:L/2
    [mGt(:,i1), dGt(:,i1), ddGt(:,i1), tauGt(:,i1), dtauGt(:,i1)] = UWerr(transpose(Gtsim(i1)));
end
plot(dGt)

[mH, dH, ddH, tauH, dtauH] = UWerr(H);
[mM, dM, ddM, tauM, dtauM] = UWerr(M);
[mchi, dchi, ddchi, tauchi, dtauchi] = UWerr(chi);
macc = sum(acc)/vol/N_prod;
[mIam1, dIam1, ddIam1, tauIam1, dtauIam1] = UWerr(Iam1);

fprintf('energy          <H>   = %f +/- %f\n',mH,dH);
fprintf('magnetization   <M>   = %f +/- %f\n',mM,dM);
fprintf('susceptibility  <chi> = %f +/- %f\n',mchi,dchi);
fprintf('acceptance rate: %f %%\n',macc);
fprintf('Iam1  <exp(-beta*DH)> = %f +/- %f\n',mIam1,dIam1);
