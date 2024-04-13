% Ex5.1
clc;
clear;
close;
%set the function parameters
N = 50;
L = 1;
a = L/N;
x = (0:N-1).'*a;
k = (0:N-1);
%Evaluate the function in the points
f = 7*sin(2*pi*x/L) + 3*sin(4*pi*x/L) + cos(8*pi*x/L);
%Calculate DFT via our function and Matlab's fft
ft = dft(f);
ftm = fft(f);
%Calculate IDFT via our function and Matlab's ifft
ftt = idft(ft);
fttm = ifft(ftm);
%print out the relative differences to check correctness
fprintf(' Relative difference dft vs fft : %e\n ', norm(ft-ftm)/norm(ft));
fprintf('Relative difference idft vs ifft : %e\n ', norm(ftt-fttm)/norm(ftt));
fprintf('Relative idft(dft(f)) -f : %e\n ', norm(ftt-f)/norm(f));

%Normalise the DFT
ft = a*dft(f);
%plot magnitude of DFT
stem(f,abs(ft),'r*');
xlabel('k [2\pi/L]','FontSize',15);
ylabel('|dft(f)|','FontSize',15);



