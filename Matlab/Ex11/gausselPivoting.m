function [x] = gausselPivoting(A,b)
[m,n] = size(A);
if m~=n | n~=size(b,1), error('not a square matrix problem'); end

B = [A b];
N = size(B,2);
%--------------------------------------------------------------------------
%MODIFICATIONS START HERE
%All calls to B go from B(i,j) to B(P(i),j), with P the 
% permutation vector.
% Choose row with maximal first element.
Order = 1:m;
% Create permutation vector.
P = 1:m;
% Choose the first element of each row.
theRows = B(P,1);
% find the maximum element.
theMax = max(abs(theRows));
% Find the row that has the maximum.
firstRow = Order(theRows == theMax);
% Applying the permutation in the permutation array.
P([1,firstRow]) = P([firstRow,1]);
% bring the matrix into triangular form (Gauss elimination):
for k =1:n-1 % loop over columns where the zeros will appear
    fac = 1/B(P(k),k);
    for i = k+1:n % loop rows where substractions take place
        % Select the kth element of all the rows.
        theRows = B(P,k);
        % Find the maximum value from the current row down.
        theMax = max(abs(theRows(i:end)));
        % Determine which row has the maximum.
        firstRow = Order(theRows == theMax);
        % Apply the permutation to the permutation vector.
        P([firstRow,i]) = P([i,firstRow]);
        fac1 = fac*B(P(i),k); % factor.
        B(P(i),k) = 0; % new zero by construction.
        B(P(i),k+1:N) = B(P(i),k+1:N) - B(P(k),k+1:N)*fac1; % substraction
    end
end

% solution by backsubstitution:
x = zeros(size(b)); % predefinition of x.
for k = n:-1:1
    x(k,:) = B(P(k),n+1:N);
    for j = k+1:n
        x(k,:) = x(k,:) - B(P(k),j)*x(j,:);
    end
    x(k,:) = x(k,:)/B(P(k),k);
end
end