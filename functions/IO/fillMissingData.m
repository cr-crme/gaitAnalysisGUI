function data = fillMissingData(data)
    nFrames = data.metadata.TRIAL.ACTUAL_END_FIELD.DATA(1) - data.metadata.TRIAL.ACTUAL_START_FIELD.DATA(1) + 1;

    if ~isfield(data.markers, 'CentreOfMass')
        data.markers.CentreOfMass = nan(nFrames, 3);
    end

    if ~isfield(data.angle, 'LThoraxAngles')
        data.angle.LThoraxAngles = nan(nFrames, 3);
    end
    
    if ~isfield(data.angle, 'LThoraxAngles')
        data.angle.LThoraxAngles = nan(nFrames, 3);
    end
    
    if ~isfield(data.angle, 'RThoraxAngles')
        data.angle.RThoraxAngles = nan(nFrames, 3);
    end
end

