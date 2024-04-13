% Exercise 11.2 Evaluating feed-forward networks
% Prabavathy Rajasekaran (2130757)
% Anjaly Kuriakose(2132537)
function net_out = ffnet_eval(netIn, inputLayer)
    net_out = netIn;
    if(length(inputLayer)~=netIn.Nneurons(1))
       error('Invalid input layer length'); 
    end
    netIn.O{1}(1:netIn.Nneurons)= inputLayer;
    
    for l = 2:netIn.Nlayers
       for n = 1:netIn.Nneurons(l)
           I = 0;
           for i = 1:length(netIn.O{l-1})
               I = I + netIn.w{l-1}(i,n)*netIn.O{l-1}(i);
            end
           net_out.I{l}(n) = I;
           net_out.O{l}(n) = netIn.factiv{l}(I);
       end
        
    end


end

