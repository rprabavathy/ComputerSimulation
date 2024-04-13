global L D

L=10;
D=2;

xvals = {[1 1], [2 2], [1,10], [10,1], [10,10]};

h=hop();

for k=1:length(xvals)
   x=xvals{k};
   l=lexic(x);
   y=alexic(l);
   n1=alexic(h(l,1));
   n2=alexic(h(l,2));
   n3=alexic(h(l,3));
   n4=alexic(h(l,4));
   fprintf('lexic([%3d,%3d]) = %d\n',x(1),x(2),l);
   fprintf('alexic(%3d)      = [%d,%d]\n',l,y(1),y(2));
   fprintf('   h(%d,1) = %d (positive 1 direction)\n',l,h(l,1))
   fprintf('   <-> [%d,%d]+[1,0] = [%d, %d]\n',x(1),x(2),n1(1),n1(2));
   fprintf('   h(%d,2) = %d (positive 2 direction)\n',l,h(l,2))
   fprintf('   <-> [%d,%d]+[0,1] = [%d, %d]\n',x(1),x(2),n2(1),n2(2));
   fprintf('   h(%d,3) = %d (negative 1 direction)\n',l,h(l,3))
   fprintf('   <-> [%d,%d]-[1,0] = [%d, %d]\n',x(1),x(2),n3(1),n3(2));
   fprintf('   h(%d,4) = %d (negative 2 direction)\n',l,h(l,4))
   fprintf('   <-> [%d,%d]-[0,1] = [%d, %d]\n',x(1),x(2),n4(1),n4(2));
   fprintf('\n');
end