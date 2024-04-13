% Exercise 11.3 Text Recognition
load weights
load digits
net = make_ffnet(3, [784 800 10], [true true false]);
net.w = w;
for d = 1:10
    [M ~] = size(train{d});
    net = ffnet_eval(net,train{d}(M,:));
    [M N] = max(net.O{end}(:));
    fprintf('The digit recognized for test{%d} is %d \n',d,N-1);
end

% Exercise 11.1 Structures and cell arrays
%The function creates and initializes a feed-forward neural network with Nlayers layers

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
    net.w{l} = randn(M,N)*var(2/(M+N));
  end
  
  %Computation of Objective function
  net.E = @(yc,yt) mean((yc-yt).^2);
  net.dE = @(yc,yt,j) 2*(yc(j)-yt(j))/length(yc);
  
end

% Exercise 11.2 Evaluating feed-forward networks
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
           net_out.O{l}(n) = net_out.factiv{l}(I);
       end
        
    end


end

