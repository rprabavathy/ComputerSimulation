% Discrete Fourier Transform
function ft = dft(f)
    %Set length of input vector
    N = length(f);
    %Calculate values of momenta
    k = (2*pi/N).*(0:N-1);
    %Initialize transform to zero
    ft = zeros(N,1);
    %calculate each element of the transform
    for m = 1:N
        %for a fixed k we calculate all the terms of the sum and then sum
        %them up
        ft(m) = sum(f.*exp(-1i*k(m)*(0:N-1)'));
    end
end
