% Householder reduction
function counter = householder_counter(A,b)
    % Get size of matrix.
    [~,n] = size(A);
    % Iterate over columns.
    counter = 0;
    for i = 1:n-1
        % Calculate norm of section of column.
        normTerm = norm(A(i:n,i));
        % Number of entries of segment of column.
        m = length(A(i:n,i));
        counter = counter + m + m -1;
        % Calulate sigma avoiding sign function of matlab.
        if A(i,i) ~= 0
            s = A(i,i)/abs(A(i,i));
        else
            s = 1;
        end
        % Calculate sigma.
        sigma = s*normTerm;
        counter = counter +1;
        % Calculate H.
        H = sigma*(sigma + A(i,i));
        counter = counter + 2;
        % Find u and u^T.
        u = zeros(n-i+1,1);
        u(1,1) = A(i,i) + sigma;
        counter = counter + 1;
        u(2:end,1) = A(i+1:n,i);
        uT = u.';
        u = u./H;
        counter = counter + length(u);
        % Segment of current column has sigma in first entry and zero
        % otherwise
        A(i:n,i) = zeros(length(A(i:n,i)),1);
        A(i,i) = -sigma;
        % Applying householder reflection to the relavant piece of the matrix.
        A(i:n,i+1:n) = A(i:n,i+1:n) - u*(uT*A(i:n,i+1:n));
        counter = counter + 2*length(u)*length(u) - length(u); % vector x Matrix.
        counter = counter + length(u)^2; % Vector x Vector = Matrix product.
        counter = counter + prod(size(A(i:n,i+1:n))); % Matrix - Matrix.
        % Applying to the right-hand side too.
        b(i:n,:) = b(i:n,:) - u*(uT*b(i:n,:));
        counter = counter + 2*length(u) - 1; % inner product.
        counter = counter + length(u); % Vector timesconstant multiplication.
        counter = counter + length(u); % Vector - Vector substraction.
    end
end