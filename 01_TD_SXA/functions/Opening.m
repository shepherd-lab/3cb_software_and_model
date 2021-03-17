%Opening image processing function
%Lionel HERVE
%10-5-04

function Output=Opening(Image,SIZE,direction)

if ~exist('direction')
    direction='NULL';
end

Output=Erosion(Image,SIZE,direction);
Output=Dilatation(Output,SIZE,direction);
