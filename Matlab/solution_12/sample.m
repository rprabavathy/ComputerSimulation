net = make_ffnet(3, [196,300,3], [true, true, false]);

target = eye(3); target(target==0) = -1;

load('small_digits.mat');


rho=0.005; alpha=0.1;
for e=1:100 
   %fprintf('------------ EPOCH %d, rho=%f-----------\n',e,rho);
   for i=1:4000
    d = floor(rand*3)+1;
    
      [Nim,~] = size(train{d});
      im = floor(rand*Nim)+1;
     
      net = ffnet_eval(net, train{d}(im,:));
      if i<10
         E = net.E(net.O{end},goals(:,d));
       %  fprintf('%4d) training with digit %d, sample %5d. Achieved score: %0.15f\n',i,d-1,im,E);
      end
      net = BackPropagation(net,goals(:,d),rho,alpha);
   end
   rho = rho*0.95;
end

function net = BackPropagation(net, target, rho, alpha)

for l = net.Nlayers-1:-1:1
  
    if l+1 == net.Nlayers
       net.dEdI{l+1} = net.dE(net.O{l+1},target).*arrayfun(net.dfactiv{l+1}, net.I{l+1});
    else
       df = arrayfun(net.dfactiv{l+1}, net.I{l+1}(1:net.Nneurons(l+1)));
       net.dEdI{l+1} = df.* (net.w{l+1}(1:net.Nneurons(l+1),1:net.Nneurons(l+2))*net.dEdI{l+2}(1:net.Nneurons(l+2)));
    end
    
    net.dEdw{l} = net.O{l} .* net.dEdI{l+1}(1:net.Nneurons(l+1)).';
   
end

for l=1:net.Nlayers-1
   net.dwold{l} = -rho* net.dEdw{l} + alpha*net.dwold{l};
   net.w{l}     = net.w{l} + net.dwold{l};
end

end
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
              % I = I + net_out.w{l-1}(i,n)*net_out.O{l-1}(i);
           end
           net_out.I{l}(n) = I;
           %net_out.I{l}(n) = I+net_out.hasBiasNeuron(l-1)*net_out.w{l-1}(i,n);
           net_out.O{l}(n) = net_out.factiv{l}(I);
       end
        
    end


end

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
    M = net.Nneurons(l);
    N = net.Nneurons(l+1);
    net.w{l} = randn(M,N)*sqrt(2/(M+N));
    net.dEdw{l} = zeros(M,N); 
    net.dwold{l} = zeros(M,N); 
  end
  
  %Computation of Objective function
  
  net.E = @(yc,yt) mean((yc-yt).^2);
  net.dE = @(yc,yt) 2*(yc-yt)/length(yc);
  
end