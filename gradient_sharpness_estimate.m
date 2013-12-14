%=========================================================================%
% GRADIENT BASED SHARPNESS METRIC          : ME354 FINAL PROJECT, AUT 2013
%=========================================================================%

%=========================================================================%
% REPOSITORY INFORMATION

% Developers             : David Manosalvas & Mehul Oswal
% Organization           : Stanford University
% Objective              : To use a gradient based metric to deterrmine the
% level of blurriness that an image has.
% Contact information    : deman@stanford.edu & moswal@stanford.edu
% This function os based on the work of Tolga Birdal
% <http://www.tbirdal.me>
%=========================================================================%

%=========================================================================%
% INPUT OPTIONS
% u     = Image which is going to be evaluated for blurriness
%
% OUTPUT OPTIONS
% sharpness = A gradient based metric that quantifies the level of
% burriness. The higher the value the sharper the image is.
%=========================================================================%

function [sharpness]=gradient_sharpness_estimate(u)

[ux, uy]=gradient(u);

S=sqrt(ux.*ux+uy.*uy);
sharpness=sum(sum(S))./(numel(ux));

end