% Exercise 11.3 Text Recognition
%Prabavathy Rajasekaran (2130757)
% Anjaly Kuriakose(2132537)
load weights
load digits
net = make_ffnet(3, [784 800 10], [true true false]);
net.w = w;
for d = 1:10
    [M ~] = size(test{d});
    net = ffnet_eval(net,test{d}(M,:));
    [M N] = max(net.O{end}(:));
    fprintf('The digit recognized for test{%d} is %d \n',d,N-1);
end