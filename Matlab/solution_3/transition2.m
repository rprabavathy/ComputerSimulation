r=2.7:0.002:4;
x0=0:0.002:1;

for lr=1:length(r)
   [xN,L]=replog_vec_lyapunov(x0,2000,r(lr));

   subplot(2,1,1)
   plot(r(lr)*ones(size(xN)),xN,'k.','MarkerSize',1); hold on;
   subplot(2,1,2)
   plot(r(lr),mean(L(~isinf(L))),'k.','MarkerSize',1); hold on;
end

subplot(2,1,1);
xlabel('r');
ylabel('x');

subplot(2,1,2);
xlabel('r');
ylabel('\lambda');
