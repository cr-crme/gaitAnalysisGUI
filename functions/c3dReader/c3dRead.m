function out = c3dRead(filepath)

    if exist('ezc3dRead', 'file') > 0
        out.ezc3d = ezc3dRead(filepath);
    if exist('btkReadAcquisition', 'file') > 0
        out.btk = btkReadAcquisition(filepath);
    else
        error('C3D reader not found or not implemented');
    end

end