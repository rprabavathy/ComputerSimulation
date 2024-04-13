function [idct] = IDCT(dct)
[N1,N2] = size(dct);
    idct = zeros(N1,N2);
    rowInv = zeros(N1,N2);
    for n1 = 1:N1
        for k1 = 1:N1
            if k1 == 1
                wk1 = 1;
            else
                wk1 = 2;
            end
            rowInv(n1,:) = rowInv(n1,:) + dct(k1,:).*cos(pi*(2*n1-1).*(k1-1)./(2*N1)).*sqrt(wk1/N1);
         end
    end
    for n2 = 1:N2
        for k2 = 1:N2
            if k2 == 1
                wk2 = 1;
            else
                wk2 = 2;
            end
            idct(:,n2) = idct(:,n2) + rowInv(:,k2).*cos(pi*(2*n2-1).*(k2 - 1)./(2*N2)).*sqrt(wk2/N2);
        end
    end
end