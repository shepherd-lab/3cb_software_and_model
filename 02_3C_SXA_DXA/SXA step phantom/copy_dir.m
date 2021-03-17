function ret = copy_dir(disk_name,dir_name)
    a = dir(disk_name);
    len = size(a);
    for i = 2:len(1)
        copyfile(['E:\', a(i).name,'\*'],dir_name,'f');
        count = i
    end
    ret = len(1);