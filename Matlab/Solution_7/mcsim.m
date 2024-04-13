% main program for Monte-Carlo simulation of the XY model with the
% Metropolis algorithm

global D L h theta beta

%%%%%%%%%%%%%%%%%%%%%% parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N_therm = 1000;  % thermalization sweeps
N_prod  = 10000; % production sweeps

beta = 1.5;       % inverse temperature
L    = 32;        % lattice size
D    = 2;         % dimension

%%%%%%%%%%%%%%%%%%%%%% geometry and initialization %%%%%%%%%%%%%%%%%%%%%%%%

vol = L^D;
h = hop();
theta = rand(vol,1);

%%%%%%%%%%%%%%%%%%%%%% thermalization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k=1:N_therm
   [~, ~] = sweep();
end
plot_cnfg(theta);

%%%%%%%%%%%%%%%%%%%%%% production %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H   = zeros(N_prod,1);
M   = zeros(N_prod,1);    
chi = zeros(N_prod,1);
acc = zeros(N_prod,1);
DH  = zeros(N_prod,1);
Iam1= zeros(N_prod,1);

for k=1:N_prod
   [acc(k), Iam1(k)] = sweep();
   H(k)   = energy(theta);
   M(k)   = magnetization(theta);
   chi(k) = susceptibility(theta);
end

%%%%%%%%%%%%%%%%%%%%%% data analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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