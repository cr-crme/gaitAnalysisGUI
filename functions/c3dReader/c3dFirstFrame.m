function out = c3dFirstFrame(c3d)

    if isfield(c3d, 'ezc3d')
        out = c3d.ezc3d.c3d.header.points.firstFrame;
    elseif isfield(c3d, 'btk')
        out = btkGetFirstFrame(c3d.btk);
    else
        error('C3D reader not found or not implemented');
    end

end