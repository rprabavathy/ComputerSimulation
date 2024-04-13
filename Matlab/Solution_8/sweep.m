
function [acc, Iam1] = sweep()
phi = pi/4;
Iam1 = 0;
acc = 0;
global D L h theta beta;
for x = 1:L^D
    bx = [0 0];
    for mu=1:D
        %local magnetic field calculation
        bx= bx + [cos(theta(h(x,mu)))  sin(theta(h(x,mu)))];
    end
    %spin calculation
    thet = [cos(theta(x))  sin(theta(x))];
    rSym = 2*phi*rand() - phi;
    %SpinPrime calculation
    thetprime = [cos(theta(x)+rSym) sin(theta(x)+rSym)];
    delH = dot((thet-thetprime),bx);
    %calculation of exp value to find accepance probability
    aProp = exp(-beta*delH);
    accProb = min(1,aProp);
    a = rand();
    %validating proposal
    if(a < accProb)
        Iam1 = Iam1+1;
    end
    acc = acc + aProp;
end
  acc = acc/(L^D);
end

