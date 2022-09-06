function out = c3dRead(filepath)
    out = [];
    if exist('ezc3dRead', 'file') > 0
        [out.ezc3d.c3d, out.ezc3d.forcePlatform] = ezc3dRead(filepath, true);
    end
    if exist('btkReadAcquisition', 'file') > 0
        out.btk = btkReadAcquisition(filepath);
    end
    
    if isempty(out)
        error('C3D reader not found or not implemented');
    end

end