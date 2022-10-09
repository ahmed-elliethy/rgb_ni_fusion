%========================================================================
% ColorPreserveFusion, Version 1.0
% Copyright(c) 2020 A.Elliethy, M.Awad
% All Rights Reserved.
%
%----------------------------------------------------------------------
% Permission to use, copy, or modify this software and its documentation
% for educational and research purposes only and without fee is hereby
% granted, provided that this copyright notice and the original authors'
% names appear on all copies and supporting documentation. This program
% shall not be used, rewritten, or adapted as the basis of a commercial
% software or hardware product without first obtaining permission of the
% authors. The authors make no representations about the suitability of
% this software for any purpose. It is provided "as is" without express
% or implied warranty.
%
% The software code is provided "as is" with ABSOLUTELY NO WARRANTY
% expressed or implied. Use at your own risk.
%----------------------------------------------------------------------
%
% This is an implementation of the fusion approach that combines both
% visible (VS) and near-infrared (NIR) images to produce an enhanced
% fused image that contains better scene details and similar colors to
% the VS image. Please refer to the following paper:
%
% M. Awad, A. Elliethy, and H. A. Aly, “Adaptive near-infrared and visible
% fusion for fast image enhancement,” IEEE Trans. Comp. Imaging, pp.1–11,
% Nov. 2019.
%
% Kindly report any suggestions or corrections to the author emails:
% awad.mrms@gmail.com, a.s.elliethy@mtc.edu.eg, haly@ieee.org
%
%----------------------------------------------------------------------
%
% Input : (1) vs_image: the visible RGB colored image being fused.
%         (2) nir_image: the near-infrared grey-scaled image being fused.
%
% Output: (1) fused_image: the enhanced RGB colored fused image.
%
% Default Usage:
%   Given 2 test images vs_im and nir_im, whose default type is uint8
%   and dynamic range is 0-255
%
%   fused_im = ColorPreserveFusion(vs_im, nir_im);
%
% See the results:
%
%   imshow(fused_im)  % Shows the output fused image
%
%========================================================================

function [fused_image] = ColorPreserveFusion(vs_image, nir_image)

    vs_image = im2double(vs_image);
    nir_image = im2double(nir_image);
    N = 5;
    vs_ycbcr = rgb2ycbcr(vs_image);
    vs_lum = vs_ycbcr(:,:,1);
    [LC_ir, max_min_I_ir, max_gr_ir] = LCP(nir_image,N);
    [LC_rgb,  max_min_I_rgb, max_gr_rgb] = LCP(vs_lum,N);
    alpha = 0.5;
    LC_ir_our = (alpha*max_min_I_ir) + ((1-alpha)*max_gr_ir);
    LC_rgb_our = (alpha*max_min_I_rgb) + ((1-alpha)*max_gr_rgb);
    fuse_map = max(0,(LC_ir_our-LC_rgb_our)./LC_ir_our);
    [ro,cl,C] = size(vs_image);
    C_cut = sqrt(log(sqrt(2)))/pi;
    Omega_c = 0.05;
    SIGMA = C_cut/Omega_c;
    RGBNIR_fusion_new = vs_image;
    HSIZE = 19;
    h = fspecial('gaussian',HSIZE,SIGMA);
    g = -h ;
    g (ceil(HSIZE/2),ceil(HSIZE/2)) = g (ceil(HSIZE/2),ceil(HSIZE/2)) + 1;
    nl_ir = imfilter(nir_image,h,'conv','same','replicate');
    nh_ir = nir_image - nl_ir;
    nl_rgb = imfilter(vs_lum,h,'conv','same','replicate');
    nh_rgb = vs_lum - nl_rgb;
    for c = 1:C
        color = vs_image(:,:,c);
        RGBNIR_fusion_new(1:ro,1:cl,c) = color + 1.5.*fuse_map.*nh_ir;
    end
    fused_image = im2uint8(RGBNIR_fusion_new);

end