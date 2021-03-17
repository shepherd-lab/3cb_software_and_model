function  icad_struct = extract_icad(theStruct)
% xml file
%General features
calc = [];
masses = [];
breast = [];
icad_struct = [];
breast.num_skinpoints = str2num(theStruct.Children(2).Children(12).Children.Attributes.Value);	   %number of skin points (m)
for m=1:breast.num_skinpoints
    for j=1:2 %x, y
        breast.skin_points(m,j) = str2num(theStruct.Children(2).Children(12).Children.Children(m).Children(j).Children.Data);   %skin_line.points(1:m)
    end
end
for i=1:2 %x, y
    breast.nipple_loc(i) = str2num(theStruct.Children(2).Children(9).Children(i).Children.Data);  %nipple location
end
breast.laterality = theStruct.Children(2).Children(5).Children.Data;	                          %laterality
breast.view = theStruct.Children(2).Children(4).Children.Data;	                                   %view
breast.rot90 = str2num(theStruct.Children(2).Children(6).Children.Data);	                                   %rotate_180
breast.auto_orient = str2num(theStruct.Children(2).Children(7).Children.Data);	                           %auto oriented
breast.cap_pixels = str2num(theStruct.Children(2).Children(8).Children.Data);                            %capped pixels
for i=1:4 %???
    breast.thumbnail(i) = str2num(theStruct.Children(2).Children(10).Children.Children(i).Children.Data);	   %thumbnail
end
breast.num_pectpoints = str2num(theStruct.Children(2).Children(11).Children.Attributes.Value); %number of pect points (m)
if breast.num_pectpoints ~= 0
    for p=1:breast.num_pectpoints
        for j=1:2
            breast.pect_points(p,j) = str2num(theStruct.Children(2).Children(11).Children.Children(p).Children(j).Children.Data);   %pect.points(1:p)
        end
    end   % p points
end
%Masses
num_masses = str2num(theStruct.Children(2).Children(14).Attributes.Value);
if num_masses ~= 0
    icad_struct.num_masses = num_masses;
    for k= 1:num_masses
        masses(k).mass_name = theStruct.Children(2).Children(14).Children(k).Attributes.Value;
        for i=1:4 %x1,y1, x2, y2
            masses(k).bound_box(i) = str2num(theStruct.Children(2).Children(14).Children(k).Children(1).Children(i).Children.Data);
        end
        masses(k).prob_finding = str2num(theStruct.Children(2).Children(14).Children(k).Children(6).Children.Data);
        masses(k).mean_inten = str2num(theStruct.Children(2).Children(14).Children(k).Children(7).Children.Data);
        masses(k).area = str2num(theStruct.Children(2).Children(14).Children(k).Children(8).Children.Data);
        masses(k).dist_chest = str2num(theStruct.Children(2).Children(14).Children(k).Children(9).Children.Data);
        for i=1:2
            masses(k).chest_coord(i) = str2num(theStruct.Children(2).Children(14).Children(k).Children(10).Children(i).Children.Data);
        end
        for i=1:2
            masses(k).centroid(i) = str2num(theStruct.Children(2).Children(14).Children(k).Children(11).Children(i).Children.Data);
        end
        masses(k).max_diam = str2num(theStruct.Children(2).Children(14).Children(k).Children(12).Children.Data);
        for i=1:2  %x, y
            masses(k).maxdiam_coord1(i) = str2num(theStruct.Children(2).Children(14).Children(k).Children(13).Children(i).Children.Data);
            masses(k).maxdiam_coord2(i) = str2num(theStruct.Children(2).Children(14).Children(k).Children(14).Children(i).Children.Data);
        end
        masses(k).type = theStruct.Children(2).Children(14).Children(k).Children(15).Children.Data;
        masses(k).dist_nipple = str2num(theStruct.Children(2).Children(14).Children(k).Children(16).Children.Data); %Children(1:2)
        masses(k).num_poly = str2num(theStruct.Children(2).Children(14).Children(k).Children(17).Attributes.Value);
        for m=1:masses(k).num_poly
            for j=1:2 %x, y
                masses(k).polyline(m,j) = str2num(theStruct.Children(2).Children(14).Children(k).Children(17).Children(m).Children(j).Children.Data);
            end %m points
        end
    end
    icad_struct.masses = masses;
else
    icad_struct.num_masses = 0;
end
% k masses

%calcifications
num_clusters = str2num(theStruct.Children(2).Children(13).Attributes.Value);
if num_clusters ~= 0
    icad_struct.num_clusters = num_clusters;
    for n=1:num_clusters
        calc(n).clus_name = theStruct.Children(2).Children(13).Children(n).Attributes.Value;
        for i=1:4 %x1, y1, x2, y2
            calc(n).bound_box(i) = str2num(theStruct.Children(2).Children(13).Children(n).Children(1).Children(i).Children.Data);
        end
        calc(n).prob_finding = str2num(theStruct.Children(2).Children(13).Children(n).Children(6).Children.Data);
        calc(n).mean_inten = str2num(theStruct.Children(2).Children(13).Children(n).Children(7).Children.Data);
        calc(n).area = str2num(theStruct.Children(2).Children(13).Children(n).Children(8).Children.Data);
        calc(n).avg_calc_dist = str2num(theStruct.Children(2).Children(13).Children(n).Children(9).Children.Data);
        calc(n).stddev_calc_dist = str2num(theStruct.Children(2).Children(13).Children(n).Children(10).Children.Data);
        calc(n).dist_nipple = str2num(theStruct.Children(2).Children(13).Children(n).Children(11).Children.Data);
        calc(n).dist_chest = str2num(theStruct.Children(2).Children(13).Children(n).Children(12).Children.Data);
        for i=1:2  %x, y
            calc(n).chest_coord(i) = str2num(theStruct.Children(2).Children(13).Children(n).Children(13).Children(i).Children.Data);
        end
        for i=1:2  %x, y
            calc(n).centroid(i) = str2num(theStruct.Children(2).Children(13).Children(n).Children(14).Children(i).Children.Data);
        end
        calc(n).max_diam = str2num(theStruct.Children(2).Children(13).Children(n).Children(15).Children.Data);
        for i=1:2  %x, y
            calc(n).maxdiam_coord1(i) = str2num(theStruct.Children(2).Children(13).Children(n).Children(16).Children(i).Children.Data);
            calc(n).maxdiam_coord2(i) = str2num(theStruct.Children(2).Children(13).Children(n).Children(17).Children(i).Children.Data);
        end
        calc(n).num_ucalcs = str2num(theStruct.Children(2).Children(13).Children(n).Children(18).Children.Data);
        for nn=1:calc(n).num_ucalcs
            for i=1:2 %x, y
                calc(n).ucalcs(nn).ucalcs_cent(i) = str2num(theStruct.Children(2).Children(13).Children(n).Children(19).Children(nn).Children(1).Children(i).Children.Data);
            end
            calc(n).ucalcs(nn).num_points = str2num(theStruct.Children(2).Children(13).Children(n).Children(19).Children(nn).Children(2).Attributes.Value);
            for m=1:calc(n).ucalcs(nn).num_points
                for j=1:2
                    calc(n).ucalcs(nn).polyline(m,j) = str2num(theStruct.Children(2).Children(13).Children(n).Children(19).Children(nn).Children(2).Children(m).Children(j).Children.Data);
                end
            end      % num points m
        end
    end
    icad_struct.calc = calc;
    % num_clusters n
else
    icad_struct.num_clusters=0;
end

%    if ~isempty(calc)
%    icad_struct.calc = calc;
%    icad_struct.num_clusters = num_clusters;
%    end
%
%    if  ~isempty(masses)
%    icad_struct.masses = masses;
%    icad_struct.num_masses = num_masses;
%    end
icad_struct.breast = breast;
a = 1;

end

