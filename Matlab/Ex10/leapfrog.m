function [X,Y,VX,VY]=leapfrog(x,y,vx,vy,L,tau,nstep)

N=length(x); % number of particles
X =zeros(N,nstep+1); Y =zeros(size(X));
VX=zeros(N,nstep+1); VY=zeros(size(X));

 X(:,1)= x;  Y(:,1)= y;              % start values
VX(:,1)=vx; VY(:,1)=vy;

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
end