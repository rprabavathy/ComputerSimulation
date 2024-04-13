% Exercise 11.2 Evaluating feed-forward networks
% Prabavathy Rajasekaran (2130757)
% Anjaly Kuriakose(2132537)
function net_out = ffnet_eval(netIn, inputLayer)
    net_out = netIn;
    if(length(inputLayer)~=net_out.Nneurons(1))
       error('Invalid input layer length'); 
    end
    net_out.O{1}(1:net_out.Nneurons)= inputLayer;
    
    for l = 2:net_out.Nlayers
       for n = 1:net_out.Nneurons(l)
           I = 0;
           for i = 1:length(net_out.O{l-1})
              I = I + net_out.w{l-1}(i,n)*net_out.O{l-1}(i);
           end
           net_out.I{l}(n) = I;
           %net_out.I{l}(n) = I+net_out.hasBiasNeuron(l-1)*net_out.w{l-1}(i,n);
           net_out.O{l}(n) = net_out.factiv{l}(I);
       end
        
    end


end

