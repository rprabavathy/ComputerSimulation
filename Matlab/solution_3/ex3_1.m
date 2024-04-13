x0=0:0.0001:1;
N=10000;
r=3.7;

tic
xN=replog(x0,N,3.7);
t1=toc;

tic
xN=replog_vec(x0,N,3.7);
t2=toc;

fprintf('time non-vectorized: %f sec\n',t1);
fprintf('time vectorized:     %f sec\n',t2);

hist(xN,20);
xlabel('x_N');
ylabel('occurences');
