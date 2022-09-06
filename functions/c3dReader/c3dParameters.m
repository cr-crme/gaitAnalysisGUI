function out = c3dParameters(c3d)

    if isfield(c3d, 'ezc3d')
        out = c3d.ezc3d.c3d.parameters;
    elseif isfield(c3d, 'btk')
        out = btkGetMetaData(c3d.btk);
    else
        error('C3D reader not found or not implemented');
    end

end