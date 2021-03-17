function [lesion_mask, outer_1_mask, outer_2_mask, outer_3_mask] = get_lesion_masks(xp, yp, xRes, yRes, m_ROI, n_ROI)
%This function gets the masks (the logical matrices) of  the lesion and
%surrounding regions.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%- INPUTS -%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%xp             Mx1 double      the x coordinates in reference to the
%                               new ROI origin (see function
%                               transf_xy_coords_2_ROI_ref)
%
%yp             Mx1 double      the y coordinates in reference to the
%                               new ROI origin (see function
%                               transf_xy_coords_2_ROI_ref)
%
%xRes           1x1 double      the spatial resolution of the input image
%                               in the x direction. This should be in mm
%                               units
%
%yRes           1x1 double      the spatial resolution of the input image
%                               in the x direction.  This should be in mm
%                               units.
%
%m_ROI          1x1 double      the number of rows of the breast ROI image
%
%n_ROI          1x1 double      the number of columns of the breast ROI
%                               image
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%- OUTPUTS -%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%lesion_mask    MxN logical     the lesion mask
%
%outer_1_mask   MxN logical     the 1st surrounding area mask
%
%outer_2_mask   MxN logical     the 2nd surrounding area mask
%
%outer_3_mask   MxN logical     the 3rd surrounding area mask
%


%calculate the number of pixels it takes to get a surrounding region
%distance.  Assume that x_res and y_res are the same (change this later)
d = 2; %2 mm perpendicular distance
d_pix = ceil(d/xRes);

%create the lesion mask
lesion_mask = poly2mask(xp, yp, m_ROI, n_ROI);

%create a distance matrix that contains the euclidean distance between a
%pixel and the nearest high
dMat = bwdist(lesion_mask, 'euclidean');

%Get the 1st surrounding area
outer_1_mask = (dMat > 0) & (dMat <= d_pix);

%Get the 2nd surrounding area
outer_2_mask = (dMat > d_pix) & (dMat <= d_pix*2);

%Get the 3rd surrounding area
outer_3_mask = (dMat > d_pix*2) & (dMat <= d_pix*3);

%Plot the masks if plotBool is high
plotBool = 0;
if plotBool
    figure(200), imagesc(lesion_mask), colormap('gray'), title('lesion mask');
    figure(201), imagesc(outer_1_mask), colormap('gray'), title('outer 1 mask');
    figure(202), imagesc(outer_2_mask), colormap('gray'), title('outer 2 mask');
    figure(203), imagesc(outer_3_mask), colormap('gray'), title('outer 3 mask');
end

end

