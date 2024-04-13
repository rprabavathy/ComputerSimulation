% Linear Congruential Generator − pseudo random number generator
function [z] = rng(N,seed,a,c,m)
persistent x;
   switch nargin
       case 1 % One Input argument rng(N)
           % default set of magic numbers
           a = 140671485;
           c = 12820163;
           m = 2^24;
           x(1)= 200;
       case 2 % two Input argument rng(N , seed)
           % default set of magic numbers
           a = 140671485;
           c = 12820163;
           m = 2^24;
           x(1)= seed;
           
       case 5 % All Input argument rng(N,seed,a,c,m) 
           x(1)=seed;
          magic(a,c,m);%verifies whether the three condition satisfied or not

       otherwise
           fprintf('Input in the form of rng(N) or rng(N,seed) or rng(N,seed,a,c,m\n');
  end
    %Recursion formula of Linear congruence random number generator    
    for i=2:N
        x(i) = mod((a*x(i-1)+c),m);
        z= x/m;
        
    end
    figure;
    hist(z);
    title('Histogram of rng');
end
