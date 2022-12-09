function data = fillMissingData(data)
    nFrames = data.metadata.TRIAL.ACTUAL_END_FIELD.DATA(1) - data.metadata.TRIAL.ACTUAL_START_FIELD.DATA(1) + 1;

    if ~isfield('CentreOfMass', data.markers)
        data.markers.CentreOfMass = nan(nFrames, 3);
    end

    if ~isfield('LThoraxAngles', data.angle)
        data.angle.LThoraxAngles = nan(nFrames, 3);
    end
    
    if ~isfield('LThoraxAngles', data.angle)
        data.angle.LThoraxAngles = nan(nFrames, 3);
    end
    
    if ~isfield('RThoraxAngles', data.angle)
        data.angle.RThoraxAngles = nan(nFrames, 3);
    end
end

