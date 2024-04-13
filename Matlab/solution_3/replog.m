function xN=replog(x0,N,r)

for l=1:length(x0)
   xN(l) = x0(l);
   for n=1:N
      xN(l)=r*xN(l)*(1-xN(l));
   end
end
