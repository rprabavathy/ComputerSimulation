% check whether the generator satisfies the 3 Magic Conditions of Linear Congruence
% Generator
%Prabavathy Rajasekaran(2130757
% Anjaly Kuriakose(2132537)

function magic(a,c,m)
    if((intersect(factor(m),factor(c))~=0) || (mod(a-1,m)~=0) || ((mod(a-1,4)~=0 && mod(m,4)~=0)))
        fprintf('Warning!! the given values a, c, m doesnot satisfy the 3 magic conditions!');
    end
  
end