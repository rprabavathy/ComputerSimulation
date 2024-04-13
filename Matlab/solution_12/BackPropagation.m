% Exercise 12 Back Propgation

function net = BackPropagation(net, goal, rho, alpha)

for l = net.Nlayers-1:-1:1
  
    if l+1 == net.Nlayers
       net.dEdI{l+1} = net.dE(net.O{l+1},goal).*arrayfun(net.dfactiv{l+1}, net.I{l+1});
    else
       df = arrayfun(net.dfactiv{l+1}, net.I{l+1}(1:net.Nneurons(l+1)));
       net.dEdI{l+1} = df.* (net.w{l+1}(1:net.Nneurons(l+1),1:net.Nneurons(l+2))*net.dEdI{l+2}(1:net.Nneurons(l+2)));
    end
    disp(l)
    size(net.dEdw{l})
    net.dEdw{l} = net.O{l} .* net.dEdI{l+1}(1:net.Nneurons(l+1)).';
        size(net.dEdw{l}) 
 end

for l=1:net.Nlayers-1
    size(net.dEdw{l})
    size(net.dwold{l})
    net.dwold{l} = -rho* net.dEdw{l} + alpha*net.dwold{l};
   net.w{l}     = net.w{l} + net.dwold{l};
end

end
