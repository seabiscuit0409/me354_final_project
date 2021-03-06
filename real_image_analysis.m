%=========================================================================%
% REAL IMAGE ANALYSIS SCRIPT    : ME354 FINAL PROJECT, AUT 2013
%=========================================================================%

%=========================================================================%
% REPOSITORY INFORMATION

% Developers             : David Manosalvas & Mehul Oswal
% Organization           : Stanford University
% Objective              : Compares the optical kernel from a real image
% using an experimentally obained sharp and blurred image
% Contact information    : deman@stanford.edu & moswal@stanford.edu
%=========================================================================%

%=========================================================================%
% INPUT OPTIONS
% 
%=========================================================================%
% Clear previous cache
clear all; close all; clc;

global gauss_size_factor disk_size_factor motion_size_factor
global gaussian_sigma

gauss_size_factor    = 1;
gaussian_sigma       = 1;
disk_size_factor     = 1;
motion_size_factor   = 1;

% Reads the images
Im1 = imread('DSC_0517.jpg'); % Sharp Image 
Im2 = imread('DSC_0518.jpg'); % Blurred image obtained by manually chaging 
                              % the focus in the camera

% Converts them to gray scale and normalizes them
u = double(rgb2gray(Im1));
u = u./max(max(u));

v = double(rgb2gray(Im2));
v = v./max(max(v));

% De-convolution approximation to find the optical kernel experimetally
[h_real] = large_noisy_kernel(u,v);

% Filtering the image to find the optical kernel

% Split the image into 9 parts
[u1,u2,u3,u4,u5,u6,u7,u8,u9] = picture_split(u);
[v1,v2,v3,v4,v5,v6,v7,v8,v9] = picture_split(v);

% Split the 5th part (center part) and splits it into 9 more
[u51,u52,u53,u54,u55,u56,u57,u58,u59] = picture_split(u5);
[v51,v52,v53,v54,v55,v56,v57,v58,v59] = picture_split(v5);

% Normalizing the image to be filtered
u55 = u55./max(max(u55));

% PSF charactristics for the filters initial guess
PSF_type        = 'disk';
PSF_dim         = 5;
factor          = 'global';
psf             = PSF_gen(PSF_type,PSF_dim,factor);
var_n           = 10^(-3.5);

% Filtering process

% u_aabc    : aa = image number
%           : b  = used kernel (1.disk 2.gaussian 3.motion)
%           : c  = filter (1.inverse 2.pseudo-inverse 3.wiener 4.geo-mean)

filter_type     = 'inverse';
[u_5511,G_5511]   = im_filter(v55,filter_type,psf,var_n);
filter_type     = 'pseudo_inverse';
[u_5512,G_5512]   = im_filter(v55,filter_type,psf,var_n);
filter_type     = 'wiener';
[u_5513,G_5513]   = im_filter(v55,filter_type,psf,var_n);
filter_type     = 'geo_mean';
[u_5514,G_5514]   = im_filter(v55,filter_type,psf,var_n);

figure; subplot(2,2,1); imshow(u55)
subplot(2,2,2); imshow(u_5512)
subplot(2,2,3); imshow(u_5513)
subplot(2,2,4); imshow(u_5514)

% Plotting the 2D filter obtained optical kernel
figure
plot(h_real)
hold on
[h_5511] = kernel_filter_2D_projection(G_5511,'-r');
[h_5512] = kernel_filter_2D_projection(G_5512,'-k');
[h_5513] = kernel_filter_2D_projection(G_5513,'-og');
[h_5514] = kernel_filter_2D_projection(G_5514,'-c');
axis([200 280 -.005 .045])

% Norm2 used to calculate the difference betweent the kernels
error_55(1) = norm(h_real-h_5511,2);
error_55(2) = norm(h_real-h_5512,2);
error_55(3) = norm(h_real-h_5513,2);
error_55(4) = norm(h_real-h_5514,2);

% Plot title | axis | legend
title('Optical kernel for an experimental image')
xlabel('pixels')
ylabel('Magnitude')
legend('Real',...
    'Inverse filter', ...
    'pseudo-inverse filter ' ,...
    'wiener filter ' ,...
    'geo-mean filter ');

% Automated metrics used to compare the effect of the filters
%[grad_55(1), simind_55(1), jn_55(1)] = sharpness_metrics(u_5511, u55);
[grad_55(2), simind_55(2), jn_55(2)] = sharpness_metrics(u_5512, u55);
[grad_55(3), simind_55(3), jn_55(3)] = sharpness_metrics(u_5513, u55);
[grad_55(4), simind_55(4), jn_55(4)] = sharpness_metrics(u_5514, u55);
[val_g_55,ind_g_55] = min(grad_55);
[val_s_55,ind_s_55] = max(simind_55);
[val_j_55,ind_j_55] = min(jn_55);








