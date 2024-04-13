function counter = gaussel_counter(A,b)
    [m,n] = size(A);
    if m~=n | n~=size(b,1), error('not square matrix problem'); end;

    B = [A b];
    N = size(B,2);

    % bring the matrix into triangular form (Gauss elimination):
    counter = 0;
    for k = 1:n-1 % loop over columns where the zeros will appear.
        fac = 1/B(k,k);
        counter = counter +1;
        for i=k+1:n % loop over rows where substractions take place.
            fac1 =  fac*B(i,k); % factor
            counter = counter + 1;
            B(i,k) = 0; % new zeros by construction.
            B(i,k+1:N) = B(i,k+1:N) - B(k,k+1:N)*fac1; % substraction.
            counter = counter + 2*length(B(k,k+1:N));
        end
    end
end