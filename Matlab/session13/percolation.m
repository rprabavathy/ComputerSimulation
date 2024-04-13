% file percolation.m
% main program for site percolation

L=12;   % lattice size L x L
p=0.5;  % site activation probability

% assign 0 for active sites, -1 for passive sites
field=-(rand(L,L) > p);


% Plot the configuration
figure();axis([0 L+1 0 L+1]);hold on;
% active sites: red *, passive sites blue .
for x=1:L 
   for y=1:L
      if field(x,y) >= 0
         plot(x,y,'*r'); 
      else 
         plot(x,y,'.b'); 
      end        
   end
end
% Lines between active sites
for x=1:L-1, 
   for y=1:L
      if field(x,y) >= 0 & field(x+1,y) >= 0 
         plot([x x+1],[y y],'-r'); 
      end
   end
end
for x=1:L 
   for y=1:L-1
      if field(x,y) >= 0 & field(x,y+1) >= 0 
         plot([x x],[y y+1],'-r'); 
      end
   end
end
axis off;

pause

disp('Tree-search result:');
[field] = tree_search(field);
flipud(field.') % such that 1/1 is in lower left corner and first index is x (column-index)
disp('Hoshen-Kopelman result:');
[field] = hoshen_kopelman(field); 
flipud(field.')
