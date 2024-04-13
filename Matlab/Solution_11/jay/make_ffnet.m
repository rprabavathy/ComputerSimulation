%{
    Jay Karippacheril Jacob - 2130800
    Krutarth Trivedi - 2130962
%}
%% function to create and initialize a feed-foward netral network with 
... Nlayers.
function net = make_ffnet(Nlayers, Nneurons, hasBiasNeurons)

% No.of non-bias neurons in each layer is given by the vector 'Nneurons'.

% whether a layer has a bias neutron in each layer is given by the logical 
... vector 'hasBiasNeurons'.

% the size of vectors 'Nneurons' and 'hasBiasNeurons' = Nlayers x 1.

% The output function structure with the fields are as follows:

net.Nlayers             =   Nlayers;    % no.of layers
net.Nneurons            =   Nneurons;   % size = Nlayers x 1, No.of neurons in  
                                                       ...each layer.
net.hasBiasNeurons      =   hasBiasNeurons; % size = Nlayers x 1, 0/1 for the
                                            ...presence of biased neurons.
% Initialization of output and input cell array for the neuron 
...'j' in layer 'l'.
for l = 1:Nlayers
    net.O{l}            =   zeros(Nneurons(l) + hasBiasNeurons(l),1);
    net.I{l}            =   zeros(Nneurons(l) + hasBiasNeurons(l),1);
    % Cell arrray with the activation function for each layer 'l' - ReLU.
    net.factiv{l}       =   @(x) max(0,x);
    % Cell arrray with the derivative of activation function for each layer
    ...'l' - ReLU.
    net.dfactiv{l}      =   @(x) x>0;
    % Cell arrray with the activation function for Nlayer/Output layer
    ...'tanh' and the derivative of the activation layer.
    if l == Nlayers
        net.factiv{l}   =   @(x) tanh(x);
        net.dfactiv{l}  =   @(x) 1/(cosh(x)^2);
    end
end
% Initialization of the cell array 'w' (weights b/w neuron 'j' in layer l 
...and neuron 'k' in layer l+1).
for l = 1:Nlayers-1
    M                   =   Nneurons(l) + hasBiasNeurons(l);
    N                   =   Nneurons(l+1) + hasBiasNeurons(l+1);
    net.w{l}            =   (randn(M,N))/sqrt(2/(M+N));   
end
% Error function E(y_o,y_t) to compute how well the objective was achieved.
... y_o  ->  output vector, y_t  ->  true results. ans dE is the partial 
...derivative of the Errorfunction
for l = 1:Nlayers
    net.E{l}                =   @(y_0,y_t) 1/N*sum((y_0 - y_t)^2);
    net.dE{l}               =   @(y_0,y_t) 1/N*(y_0 - y_t)*2;
end