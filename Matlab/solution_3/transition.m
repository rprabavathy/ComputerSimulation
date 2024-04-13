r=2.7:0.002:4;
x0=0:0.002:1;

for lr=1:length(r)
   xN=replog(x0,2000,r(lr));
   plot(r(lr)*ones(size(xN)),xN,'k.','MarkerSize',1); hold on;
end

xlabel('r');
ylabel('x');
