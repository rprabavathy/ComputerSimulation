%{
Jay Karippacheril Jacob - 2130800
Krutarth Trivedi - 2130962
%}
%% Testing the neuron network recognition functions implemented with test
...images to check the implementation.
load weights
load digits
whos
for i = 1 : 10
    net = make_ffnet(3, [784 800 10], [true true false]);
    net.w = w;
    net = ffnet_eval(net,test{i}(100,:));
    fprintf('\n The recognition for the test block  = %d \n',i);
    display(net.O{3});
%     figure;
%     plot(imagesc(reshape(test{i}(100,:),28,28)'));
%     colormap('gray');
end