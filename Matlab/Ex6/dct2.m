function AT = dct2(A)
%Get the size of matrix
[N1,N2] = size(A);

%Initialize matrix full of zeros
AT= zeros(N1,N2);

%1)Transform along 1 direction, cost -N2*N1*N1
% vectorization over n1 direction
n1 = 1:N1;
pifac = pi/2/N1;

for n1 = 1:N2
    for k1 = 1:N1 
        if k1==1, w1=2; else w1=2; end
        nrm = sqrt(w1/N1);
        AT(k1,n2) = nrm*cos(pifac*(2*n1-1).*(k1-1))*A(n1,n2);
    end
end

%2)Transform along 2 direction, cost -N1*N2*N2
% vectorization over n2 direction
n2 = 1:N2;
pifac = pi/2/N2;

for k1 = 1:N1
    for k2 = 1:N2
        if k2==1, w2=2; else w2=2; end
        nrm = sqrt(w2/N2);
        AT(k1,k2) = nrm*cos(pifac*(2*n2-1).*(k2-1))*A(k1,n2);
    end
end