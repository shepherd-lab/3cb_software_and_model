function clear_DXAfields()
    global Image
    
    if isfield(Image,'LE')
        Image = rmfield(Image, 'LE')
    end
    if isfield(Image,'HE')
        Image = rmfield(Image, 'HE')
    end
    if isfield(Image,'RST')
        Image = rmfield(Image, 'RST')
    end
    if isfield(Image,'material')
        Image = rmfield(Image, 'material')
    end
    if isfield(Image,'thickness')
        Image = rmfield(Image, 'thickness')
    end
    if isfield(Image,'thirdcomponent')
        Image = rmfield(Image, 'thirdcomponent')
    end