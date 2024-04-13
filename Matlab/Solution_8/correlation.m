function [G_t] = correlation()

    global L theta h
    % calculating slice spins
    S       = zeros(L,2);
    sum_1   = zeros(1,L);
    sum_2   = sum_1;
    
    for x2 = 1:L
        for x1 = 1:L
            sum_1(x1) = sin(theta(lexic([x1,x2])));
            sum_2(x1) = cos(theta(lexic([x1,x2])));
        end
        S(x2,1) = sum(sum_1);
        S(x2,2) = sum(sum_2);
    end
    S = S ./ L;
    
    clear sum_1 sum_2
    
    % correlation function
    G_t = zeros(L/2,L);
    
    S_prime = [S;S]; % for periodic boundaries --> because t = 1,...,16,
                        %   maximum is 32+16 = 48 < 64
    
    for t = 1:L/2
        for x1 = 1:L
            G_t(t,x1) = G_t(t,x1) + dot(S_prime(x1,:),S_prime(x1+t,:));
        end
    end
    G_t = G_t ./ L;
    
end