% Exercise 11.a: Comparision of errors.

% Allocate space for the errors of each method.
errGauss = zeros(1,100);
errPivot = zeros(1,100);
errMatlab = zeros(1,100);

% Iterate over different problem sizes.
for n = 2:100
    % Generate random matrix.
    A = rand(n,n);
    % Generate random solution.
    x = rand(n,1);
    % Compute right-hand side.
    b = A*x;
    % Find solution and error with Gaussian elimination.
    yG = gaussel(A,b);
    errGauss(n) = max(x - yG);
    % Find solution and error using partial pivoting.
    yP = gausselPivoting(A,b);
    errPivot(n) = max(abs(x - yP));
    % Find solution and error using Matlab.
    yM = A\b;
    errMatlab(n) = max(abs(x - yM));
end

% Plot the error for the three methods.
figure;
loglog(2:100,errGauss(2:100),'k.');hold on;
loglog(2:100,errPivot(2:100),'r.');
loglog(2:100,errMatlab(2:100),'b.');
legend('No pivot','Pivot','Matlab');
xlabel('n','Fontsize',17);
ylabel('\delta','Fontsize',17);

% Test iterative improvement.
RelevantiterationsG = zeros(30,1);
RelevantiterationsP = zeros(30,1);
% Iterate over problem size.
for n = 2:30
    % create random matrix.
    A = rand(n,n);
    % Create random solution.
    x = rand(n,1);
    % Create rhs.
    b = A*x;
    % Find solutions with and without pivoting.
    yG = gaussel(A,b);
    yP = gausselPivoting(A,b);
    % Find 'exact' solution.
    xE = A\b;
    % Apply iterative improvement.
    IterGauss = 1;
    IterPivot = 1;
    stopGauss = false;
    stopPivot = false;
    % Approximate RHS.
    bO_G = A*yG;
    % RHS for error system.
    db = bO_G - b;
    % Relative error.
    RelErrG_Old = norm(yG - xE)/norm(xE);
    RelErrP_Old = norm(yP - xE)/norm(xE);
    while ~stopGauss
        % Improvegaussian solution.
        if ~stopGauss
            % setinitial solution.
            xO_G = yG;
            % Approximation rhs.
            bO_G = A*xO_G;
            % RHS for new system.
            db = bO_G - b;
            dxO_G = gaussel(A,db);
            % Calculate new solution.
            x1_G = xO_G - dxO_G;
            % Compare with 'exact solution'.
            RelErrG_New = norm(x1_G - xE)/norm(xE);
            % update solution.
            yG = x1_G;
            % If not improved then stop.
            if RelErrG_New >= RelErrG_Old
                stopGauss = true;
            end
            RelErrG_Old = RelErrG_New;
            IterGauss = IterGauss + 1;
        end
        % IMprove pivoted solution.
        if ~stopPivot
            % Set initial  solution.
            xO_P = yP;
            % Approximate rhs..
            bO_P = A*xO_P;
            % RHS for new system.
            db = bO_P - b;
            dxO_P = gausselPivoting(A,db);
            % Calculate new solution.
            x1_P = xO_P - dxO_P;
            % Compare with 'exact' solution.
            RelErrP_New = norm(x1_P - xE)/norm(xE);
            % If not improve then stop.
            if RelErrP_New >= RelErrP_Old
                stopPivot = true;
            end
            RelErrP_Old = RelErrP_New;
            IterPivot = IterPivot + 1;
        end
    end
    RelevantiterationsG(n) = IterGauss;
    RelevantiterationsP(n) = IterPivot;
end

% Plot relevant iterations.
figure();
plot(2:30,RelevantiterationsG(2:30), 'r.'); hold on;
plot(2:30,RelevantiterationsP(2:30),'k.');
legend({'No Pivoting','Pivoting'});
xlabel('n','Fontsize',15);
ylabel('Relevant iterations');