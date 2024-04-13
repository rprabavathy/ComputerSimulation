clc;
close all;
clear all;
% read_image.m

%1) read in and display the image
im = double(imread('test_image.tif','TIF'));
dim = size(im);
figure('Units', 'pixels','position',[1 1 20+dim(2) 20+dim(1)]);
ax=axes('Units', 'pixels', 'position', [10, 10, dim(2), dim(1)],'visible','off','Ydir','reverse');
hold on;
image(im,'parent',ax);
colormap(gray(256)); % correct mapping: values<->colors
% a) display the Transformed Image in full resolution after DCT
dct = DCT(im);
dim = size(dct);
figure('Units', 'pixels','position',[1 1 20+dim(2) 20+dim(1)]);
ax=axes('Units', 'pixels', 'position', [10, 10, dim(2), dim(1)],'visible','off','Ydir','reverse');
hold on;
image(dct,'parent',ax);

colormap(gray(256)); % correct mapping: values<->colors

% a) display the Inputted Image in full resolution after IDCT
iDct = IDCT(dct);
dim = size(dct);
figure('Units', 'pixels','position',[1 1 20+dim(2) 20+dim(1)]);
ax=axes('Units', 'pixels', 'position', [10, 10, dim(2), dim(1)],'visible','off','Ydir','reverse');
hold on;
image(iDct,'parent',ax);
colormap(gray(256)); % correct mapping: values<->colors

% b) Cropped Image with rho = .35 for the test_image.tif
Y = crop(im, 0.35);
% display the cropped image
dim = size(Y);
figure('Units', 'pixels','position',[1 1 20+dim(2) 20+dim(1)]);
ax=axes('Units', 'pixels', 'position', [10, 10, dim(2), dim(1)],'visible','off','Ydir','reverse');
hold on;
image(Y,'parent',ax);
colormap(gray(256)); % correct mapping: values<->colors

%c)
%Cropped Image with rho=0.15 for the DCT image
Y1 = crop(dct, 0.15);
%Compression Ratio
CR1 = nnz(Y1)/numel(Y1);

%Applying Inverse transform for the Cropped Image for rho = 0.15
Z1 = IDCT(Y1);
% display the cropped DCT image by applying IDCT
dim = size(Z1);
figure('Units', 'pixels','position',[1 1 20+dim(2) 20+dim(1)]);
ax=axes('Units', 'pixels', 'position', [10, 10, dim(2), dim(1)],'visible','off','Ydir','reverse');
hold on;
image(Z1,'parent',ax);
colormap(gray(256)); % correct mapping: values<->colors
RD1 = norm(im-Z1)/norm(im);
fprintf('\nFor \rho = 0.15 Compression Rate is %f and Relative difference is %f', CR1,RD1);

%Cropped Image with rho=0.35 for the DCT image
Y2 = crop(dct, 0.35);
%Compression Ratio
CR2 = nnz(Y2)/numel(Y2);

%Applying Inverse transform for the Cropped Image for rho = 0.35
Z2 = IDCT(Y2);
% display the cropped image
dim = size(Z2);
figure('Units', 'pixels','position',[1 1 20+dim(2) 20+dim(1)]);
ax=axes('Units', 'pixels', 'position', [10, 10, dim(2), dim(1)],'visible','off','Ydir','reverse');
hold on;
image(Z2,'parent',ax);
colormap(gray(256)); % correct mapping: values<->colors
RD2 = norm(im-Z2)/norm(im);
fprintf('\nFor \rho = 0.35 Compression Rate is %f and Relative difference is %f', CR2,RD2);

%Cropped Image with rho=0.55 for the DCT image
Y3 = crop(dct, 0.55);
%Compression Ratio
CR3 = nnz(Y3)/numel(Y3);

%Applying Inverse transform for the Cropped Image of rho = 0.55
Z3 = IDCT(Y3);
% display the cropped image
dim = size(Z3);
figure('Units', 'pixels','position',[5 5 20+dim(2) 20+dim(1)]);
ax=axes('Units', 'pixels', 'position', [10, 10, dim(2), dim(1)],'visible','off','Ydir','reverse');
hold on;
image(Z3,'parent',ax);
colormap(gray(256)); % correct mapping: values<->colors
RD3 = norm(im-Z3)/norm(im);
fprintf('\nFor \rho = 0.55 Compression Rate is %f and Relative difference is %f', CR3,RD3);