% Exercise 11.b: Operation counting.

% Set up a system.
% Matrix size.
n = 100;
% Number of columns of solution.
m = 2;
% Create matrix and solution.
A = rand(n,n);
x = rand(n,m);
% Create rhs.
b = A*x;

fprintf('Operation count for Gaussian elimination.\n');
% Solve system with Gaussian elimination.
y = gaussel_counter(A,b);

%--------------------------------------------------------------------------
fprintf('----------------------------------------------------------------');
fprintf('----------------------Comparison of simultaneous vs separate solutions:---------------------------------\n');

% Test simultaneous vs separate solutions.
A = rand(50,50);
x = rand(50,2);
b = A*x;

fprintf('----------------------Simultaneous solution:------------------------------------------------------------\n');
%Solve simultaneously.
ySim = gaussel_counter(A,b);

fprintf('----------------------Separate solutions:---------------------------------------------------------------\n');
% Solve separately.







% Gaussian elimination with counters.
function [x] = gaussel_counter(A,b)
[m,n]=size(A);
if m~=n || n~=size(b,1), error('not a square matrix problem'); end

B=[A b];
N=size(B,2);

% bring the matrix into triangular form (Gauss elimination):
%--------------------------------------------------------------------------
% Add the counter for the elimination step.
counter = 0;
for k=1:n-1    % loop over columns where the zeros will appear
  fac=1/B(k,k);
  % Update the counter for this division.
  counter = counter + 1;
  for i=k+1:n   % loop over rows where subtractions take place
    fac1=fac*B(i,k); % factor
    % Update the counter for this multiplication.
    counter = counter + 1;
    B(i,k)=0; % new zero by construction
    B(i,k+1:N)=B(i,k+1:N)-B(k,k+1:N)*fac1; % subtraction
    % Update the counter for the total of multiplications.
    counter = counter + length(B(k,k+1:N));
  end
end
% Display the count of operations.
disp('Multiplications & Divisions in Elimination:');
display(counter);
% Calculate the expected value with the derived formula.
rows = m;
cols = size(b,2);
disp('Expected count:');
rho = (1/3)*rows^3 + 0.5*cols*rows^2 + rows*(4/6 - cols/2) - 1;
% Display the count according to the formula.
disp(rho);
% Solution by backsubstitution :
x=zeros(size(b)); % predefinition of x
% Create counter for back substitution.
counter2 = 0;
for k=n:-1:1
  x(k,:)=B(k,n+1:N);
  for j=k+1:n
    x(k,:)=x(k,:)-B(k,j)*x(j,:);
    % Update counter by the total of multiplications.
    counter2 = counter2 + length(x(j,:)); 
  end
  x(k,:)=x(k,:)/B(k,k);
  % Update counter by the total of divisions.
  counter2 = counter2 + length(x(k,:));
end
% Display the total count of operations.
disp('Multiplications & Dividions in Back Substitution:');
disp(counter2);
% Calculate the expected count with the derived formula.
disp('Expected count:');
alpha = rows*cols*0.5*(rows+1);
% Display the expected value.
disp(alpha);
end