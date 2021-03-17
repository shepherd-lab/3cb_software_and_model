function  grayscaleImage_correction(a_offset, b_slope)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
     global MachineParams Image
     A_const =  MachineParams.a_init;
     B_const =  MachineParams.b_init;
     current_image = Image.image;
     Image.image = current_image*B_const/b_slope - a_offset*B_const/b_slope + A_const;
     Image.OriginalImage = Image.image;
     clear current_image;
     
end

