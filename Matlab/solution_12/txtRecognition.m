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
    disp(net.O{end})
end
