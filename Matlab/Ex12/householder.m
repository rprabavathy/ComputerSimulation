% Householder reduction
function x = householder(A,b)
    % Get size of matrix.
    [~,n] = size(A);
    % Iterate over columns.
    for i = 1:n-1
        % Calculate norm of section of column.
        normTerm = norm(A(i:n,i));
        % Calulate sigma avoiding sign function of matlab.
        if A(i,i) ~= 0
            s = A(i,i)/abs(A(i,i));
        else
            s = 1;
        end
        % Calculate sigma.
        sigma = s*normTerm;
        % Calculate H.
        H = sigma*(sigma + A(i,i));
        % Find u and u^T.
        u = zeros(n-i+1,1);
        u(1,1) = A(i,i) + sigma;
        u(2:end,1) = A(i+1:n,i);
        uT = u.';
        u = u./H;
        % Segment of current column has sigma in first entry and zero
        % otherwise
        A(i:n,i) = zeros(length(A(i:n,i)),1);
        A(i,i) = -sigma;
        % Applying householder reflection to the relavant piece of the matrix.
        A(i:n,i+1:n) = A(i:n,i+1:n) - u*(uT*A(i:n,i+1:n));
        % Applying to the right-hand side too.
        b(i:n,:) = b(i:n,:) - u*(uT*b(i:n,:));
    end

    % Back substitution.
    B = [A b];
    N = size(B,2);

    x = zeros(size(b));
    for k = n:-1:1
        x(k,:) = B(k,n+1:N);
        for j = k+1:n
            x(k,:) = x(k,:) - B(k,j).*x(j,:);
        end
        x(k,:) = x(k,:)./B(k,k);
    end
end