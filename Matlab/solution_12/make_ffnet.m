% Exercise 11.1 Structures and cell arrays
%The function creates and initializes a feed-forward neural network with Nlayers layers
function net = make_ffnet(Nlayers,Nneurons,hasBiasNeuron)
  net.Nlayers = Nlayers;
  net.Nneurons = Nneurons;
  net.hasBiasNeuron = hasBiasNeuron;
  net.hasBiasNeuron(Nlayers) = false;
  
  %O and I calculation
  for l = 1:Nlayers
    net.O{l} = zeros(net.Nneurons(l)+net.hasBiasNeuron(l),1);   % conserding the Bias neuron  
    if(l>1)
        net.I{l} = zeros(net.Nneurons(l),1); 
        net.dEdI{l} = zeros(net.Nneurons(l),1); 
    else
        net.I{l} = []; 
        net.dEdI{l} = [];
    end
  end
  
  %Activation function phi(x) and phi'(x)
  net.factiv{Nlayers} = @(x) tanh(x);
  net.dfactiv{Nlayers}= @(x) 1/cosh(x)^2;
  for l=1:Nlayers-1
    net.factiv{l} = @(x) max([0 x]);
    net.dfactiv{l} = @(x) double(x>0);
  end
  
  %Weight calculation
  for l=1:Nlayers-1
    M = net.Nneurons(l)+net.hasBiasNeuron(l);
    N = net.Nneurons(l+1);
    sig = sqrt(2/(M+N));
    net.w{l} = randn(M,N)*sig;
    net.dEdw{l} = zeros(M,N); 
    net.dwold{l} = zeros(M,N); 
  end
  
  %Computation of Objective function
  
  net.E = @(yc,yt) mean((yc-yt).^2);
  net.dE = @(yc,yt) 2*(yc-yt)/length(yc);
  
end
