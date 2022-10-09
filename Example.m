clear all;
close all;
clc;

I_VS  = imread('demo/example_rgb.tiff');
I_NIR = imread('demo/example_nir.tiff');

I_Fused = ColorPreserveFusion(I_VS,I_NIR);

figure, imshow(I_Fused), title('VS-NIR Fused Image');
