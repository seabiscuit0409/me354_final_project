% Trial File to play with filters.
clear all;close all;clc

A = im2double(...
    rgb2gray(...
    imread('new_pictures/DSCN6155.JPG')));
% imread('new_pictures/IMG_7310.JPG')
% II = A(973:2050,2509:3605);

II=A;
figure, imshow(II)
%%
% % Two PSF's added on top of each other to get the best sharpness
% psf1 = fspecial('disk',2);
% % PSF2 = zeros(size(PSF1));
% psf2 = fspecial('gaussian',10,8);
% 
% blurred_11 = imfilter(II, psf1, 'conv', 'circular');
% % blurred_11 = I;
% blurred_12 = imfilter(blurred_11, psf2, 'conv', 'circular');
% 
% figure, imshow(blurred_12)
% I = blurred_12;

%% 

I = II;
% making the PSFs of the same size. Can also be considered as zero
% padding.
PSF1 = fspecial('disk',10);
% PSF2 = zeros(size(PSF1));

PSF2 = fspecial('gaussian',60,8);
% PSF1 = zeros(size(PSF2));


nrows = max(size(PSF1,1), size(PSF2,1));
ncols = max(size(PSF1,2), size(PSF2,2));

row_cen = ceil(nrows./2);
col_cen = ceil(ncols./2);

nchannels = size(PSF1,3);

extendedPSF1 = zeros(nrows,ncols);
extendedPSF2 = zeros(nrows,ncols);

% Temporary variables
a = ceil(size(PSF1,1)./2);
b = size(PSF1,1)-a;
aa = ceil(size(PSF1,2)./2);
bb = size(PSF1,2)-aa;

c = ceil(size(PSF2,1)./2);
d = size(PSF2,1)-c;
cc = ceil(size(PSF2,2)./2);
dd = size(PSF2,2)-cc;


extendedPSF1(row_cen-a+1:row_cen+b,col_cen-aa+1:col_cen+bb) = PSF1; 
extendedPSF2(row_cen-c+1:row_cen+d,col_cen-cc+1:col_cen+dd) = PSF2; 

PSF1=extendedPSF1;
PSF2=extendedPSF2;


PSF = PSF1+PSF2;
noise_var = 0.001;
estimated_nsr = noise_var / var(I(:));
% 
psf = PSF;
var_n = noise_var;
v = I;
%%
% filter_type     = 'inverse';
% [u_111,G_111]   = im_filter(v,filter_type,psf,var_n);
% figure, imshow(real(u_111)), title(['Image restored using ',filter_type]);
% filter_type     = 'pseudo_inverse';
% [u_112,G_112]   = im_filter(v,filter_type,psf,var_n);
% figure, imshow(real(u_112)), title(['Image restored using ',filter_type]);
% filter_type     = 'wiener';
% [u_113,G_113]   = im_filter(v,filter_type,psf,var_n);
% figure, imshow(real(u_113)), title(['Image restored using ',filter_type]);
% filter_type     = 'geo_mean';
% [u_114,G_114]   = im_filter(v,filter_type,psf,var_n);
% figure, imshow(real(u_114)), title(['Image restored using ',filter_type]);
% filter_type     = 'least_squares';
% [u_115,G_115]   = im_filter(v,filter_type,psf,var_n);
% figure, imshow(real(u_115)), title(['Image restored using ',filter_type]);
% 
% figure, imshow(real(u_113))
% title('Noisy blurred image recovered using wiener')
% 
% %%
% % Plots the 2D projection of the kernel
% Im1 = u_113;
% figure
% [h_real] = real_kernel_2D_projection(real(Im1),v,'-b');
% hold on
% [h_111] = kernel_filter_2D_projection(G_111,'-r');
% [h_112] = kernel_filter_2D_projection(G_112,'-g');
% [h_113] = kernel_filter_2D_projection(G_113,'-y');
% [h_114] = kernel_filter_2D_projection(G_114,'-c');
% [h_115] = kernel_filter_2D_projection(G_115,':k');
% 
% 
% 
% error_11(1) = norm(h_real-h_111,2);
% error_11(2) = norm(h_real-h_112,2);
% error_11(3) = norm(h_real-h_113,2);
% error_11(4) = norm(h_real-h_114,2);
% error_11(5) = norm(h_real-h_115,2);
% 
% title(['Optical kernel for Peppers'])
% xlabel('pixels')
% ylabel('Magnitude')
% legend('Real', ['inverse filter ' num2str(error_11(1))],...
%     ['pseudo-inverse filter ' num2str(error_11(2))],...
%     ['wiener filter ' num2str(error_11(3))],...
%     ['geo-mean filter ', num2str(error_11(4))],...
%     ['least-squares filter ' num2str(error_11(5))]);
% 
% 
% Sharpness metric based on SSIM.
% disp('Original image to work with');
% [mssim_true, ~] = ssim_index(blurred_12, II, [0.01 0.03], fspecial('gaussian', 11, 1.5), 1)
% disp('inverse')
% [mssim1, ~] = ssim_index(u_111, II, [0.01 0.03], fspecial('gaussian', 11, 1.5), 1)
% disp('pseudo inverse')
% [mssim2, ~] = ssim_index(u_112, II, [0.01 0.03], fspecial('gaussian', 11, 1.5), 1)
% disp('wiener')
% [mssim3, ~] = ssim_index(u_113, II, [0.01 0.03], fspecial('gaussian', 11, 1.5), 1)
% disp('geo_mean')
% [mssim4, ~] = ssim_index(u_114, II, [0.01 0.03], fspecial('gaussian', 11, 1.5), 1)
% disp('least_squares')
% [mssim5, ~] = ssim_index(u_115, II, [0.01 0.03], fspecial('gaussian', 11, 1.5), 1)

%=========================================================================%

% Using our own wiener filter
[u,G] = im_filter(I,'wiener',PSF,noise_var);
figure, imshow(u)%, title('using our wiener filter')

% % Using the Wiener filter of matlab.
% wnr2 = deconvwnr(I, PSF, estimated_nsr);
% figure, imshow(wnr2), title('using Matlab wiener')
%=========================================================================%