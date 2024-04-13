for i = 0.5
    %Define x^1
    func = @(x) x.^1;
    %Real value of Integral 
    realnt = 1/(i+1);
    %calculate with extended Trapezoidal 
    trapInt = extendedTrap(func,0,1,1);
    %calculate with extended Simpson 
    simpInt = extendedSimpson(func,0,1,2); 
    %print the degree, the error from trapezoidal and the error from
    %Simpson
    errorTrap = abs(realnt - trapInt)/abs(realnt);
    errorSimp = abs(realnt - simpInt)/abs(realnt);
    fprintf('Deg : %i,  error Trapezoidal : %.5f,  error Simpson : %.5f \n',i,errorTrap,errorSimp);
end
%Extended Trapezoidal integrates exactly upto x^1
%Extended Simpson integrates exactly upto x^3