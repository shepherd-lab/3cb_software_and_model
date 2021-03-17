function coordStruct=coord_grid(coordDef)
%Creates a grid, expects coorDef to contain fields parameter_1 and
%parameter_2.  parameter_1 is an integer and corresponds to the number of
%gridpoints on a line originating from the nipple. 
%parameter_2 is an integer and corresponds to the
%number of gridpoints on a line from the ?left? breast edge.  
%gridpoints are chosen to not be directly on the nipple or the chest wall.
coordStruct.type='BREASTCOORD';
nippleNum=str2num(coordDef.parameter_1); %#ok<ST2NM>
leftRightNum=str2num(coordDef.parameter_2); %#ok<ST2NM>
for i=1:nippleNum
    for j=1:leftRightNum
        coordStruct.XY(i*nippleNum-nippleNum+j,1)=...
            i/(nippleNum+1);
        coordStruct.XY(i*nippleNum-nippleNum+j,2)=...
            j/(leftRightNum+1);
    end
end
end

