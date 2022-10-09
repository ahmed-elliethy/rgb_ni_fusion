clear all;
close all;
clc;

I_VS  = imread('example_rgb.tiff');
I_NIR = imread('example_nir.tiff');

I_Fused = ColorPreserveFusion(I_VS,I_NIR);

figure, imshow(I_Fused), title('VS-NIR Fused Image');