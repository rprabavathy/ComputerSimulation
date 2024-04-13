global D L h

% set up geometry
L=10;
vol = L^D;
D=2;
h=hop();

% create constant configuration
theta = ones(vol,1)*0.123*pi;

H   = energy(theta);
fprintf('energy/link of a constant configuration: %f\n',H/L^D/D);
M   = magnetization(theta);
fprintf('magnetization (per site) of a constant cnfg: %f\n',M);
chi = susceptibility(theta);
fprintf('susceptibility of a constant cnfg: %f\n',chi);
plot_cnfg(theta);

% now: N random configurations, compute the averages
N = 10000;
for l=1:N
   theta  = rand(vol,1)*2*pi; % angles uniformly in [0,2pi]
   H(l)   = energy(theta);
   M(l)   = magnetization(theta);
   chi(l) = susceptibility(theta);
end
plot_cnfg(theta);

mH = mean(H);
dH = std(H)/sqrt(N);
fprintf('%d random configs: <H> = %f +/- %f\n',N,mH,dH);

mM = mean(M);
dM = std(M)/sqrt(N);
fprintf('%d random configs: <M> = %f +/- %f\n',N,mM,dM);

mchi = mean(chi);
dchi = std(chi)/sqrt(N);
fprintf('%d random configs: <chi> = %f +/- %f\n',N,mchi,dchi);