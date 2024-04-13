%{
Jay Karippacheril Jacob - 2130800
Krutarth Trivedi - 2130962
%}
%% function for evaluating feed-foward netral networks with 
... Nlayers.
function net_out  = ffnet_eval(net_in, input_layer)

    net_out                     =   net_in;
    net_out.I{1}                =   input_layer;
    for l = 2:net_out.Nlayers+1
        % Calulation for the output of the layer l-1.
        M                       =   net_out.Nneurons(l-1);
        for p = 1:M
            net_out.O{l-1}(p)   =   net_out.factiv{l-1}(net_out.I{l-1}(p));
        end
        % Calulation for the input of layer l.
        if l<=net_out.Nlayers
            N                   =   net_out.Nneurons(l);
            for q = 1:N
                sum             =   0;
                for p = 1:M 
                    sum = sum + net_out.w{l-1}(p,q) * net_out.O{l-1}(p);
                end
                net_out.I{l}(q) =   sum;
            end
        end
    end
end