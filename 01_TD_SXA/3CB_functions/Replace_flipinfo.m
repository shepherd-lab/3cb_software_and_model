function Replace_flipinfo()
global Info
thickness_map = [];
ROI = [];
version_name = [];
fNamemat = [];
fNamemat = [Info.fname(1:end-4), '_Mat_v',Info.Version(8:end) ,'.mat', ];
try
    load(fNamemat);
catch
    errmsg = lasterr
    nextpatient(0);
end
flip_info = [];
flip_info = [Info.flipH Info.flipV]
save(fNamemat, 'thickness_map','ROI','flip_info','version_name');
nextpatient(0);
end

