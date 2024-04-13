% Exercise 11.1 Structures and cell arrays
%The function creates and initializes a feed-forward neural network with Nlayers layers
%Prabavathy Rajasekaran (2130757)
% Anjaly Kuriakose(2132537)
function net = make_ffnet(Nlayers,Nneurons,hasBiasNeuron)
  net.Nlayers = Nlayers;
  net.Nneurons = Nneurons;
  net.hasBiasNeuron = hasBiasNeuron;
  net.hasBiasNeuron(Nlayers) = 0;
  
  %O and I calculation
  for l = 1:Nlayers
    net.O{l} = zeros(net.Nneurons(l)+net.hasBiasNeuron(l),1);   % conserding the Bias neuron                       
    net.I{l} = zeros(net.Nneurons(l),1); 
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
    M = net.Nneurons(l);
    N = net.Nneurons(l+1);
    net.w{l} = randn(M,N)/sqrt(2/(M+N));
  end
  
  %Computation of Objective function
  
  net.E = @(yc,yt) mean((yc-yt).^2);
  net.dE = @(yc,yt,j) 2*(yc(j)-yt(j))/length(yc);
  
end