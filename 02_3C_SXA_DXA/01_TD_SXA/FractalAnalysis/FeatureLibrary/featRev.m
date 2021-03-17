function revision=featRev(isExe)
    if isExe
        revision='NotImplemented';
    else
        revision=get_SXA_revision(@featRev);
    end
end