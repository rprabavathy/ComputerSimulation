%cropping function
function Y = crop(Y,rho)
    %Get size of matrix
    [m,n] = size(Y);
    %iterate over rows
    for l=1:m
        %iterate over columns
        for k=1:n
            %if outside of maximum radius than 0
            if (l^2 + k^2) > (rho^2 * (m^2 + n^2))
                Y(l, k) = 0;
            end
        end
    end
end

