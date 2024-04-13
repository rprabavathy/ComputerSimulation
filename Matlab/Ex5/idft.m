% Inverse Discrete Fourier Transformation
function f = idft(ft)
    %Get length of vector
    N = length(ft);
    %Calculate the momenta
    k = (0:N-1)'*(2*pi/N);
    %Initialize inverse transform to zero
    f = zeros(N,1);
    %calculate each element of the inverse transform
    for n = 1:N
        %for a fixed k we calculate all terms of the sum and then sum
        %them up
        f(n) = sum(ft.*exp(1i*k*n))/N;
    end
end
