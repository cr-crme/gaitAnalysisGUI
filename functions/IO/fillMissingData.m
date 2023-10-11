function data = fillMissingData(data)
    nFrames = data.metadata.TRIAL.ACTUAL_END_FIELD.DATA(1) - data.metadata.TRIAL.ACTUAL_START_FIELD.DATA(1) + 1;

    if ~isfield(data.markers, 'CentreOfMass')
        data.markers.CentreOfMass = nan(nFrames, 3);
    end
    
    structuresToCheck = {
        'Thorax', 'Pelvis', 'Hip', 'Knee', 'Ankle', 'FootProgress'
    };

    for name = structuresToCheck
        data = checkAndFillAngleBasedStructure(data, name{1}, nFrames);
    end
end

function data = checkAndFillAngleBasedStructure(data, fieldToCheck, nFrames)
    for side = ['L', 'R']
        if ~isfield(data.angle, [side fieldToCheck])
            data.angle.([side fieldToCheck]) = nan(nFrames, 3);
        end
        if ~isfield(data.angle, [side fieldToCheck 'Angles'])
            data.angle.([side fieldToCheck 'Angles']) = nan(nFrames, 3);
        end
    
    
        if ~isfield(data.moment, [side fieldToCheck])
            data.moment.([side fieldToCheck]) = nan(nFrames, 3);
        end
        if ~isfield(data.angle, [side fieldToCheck 'Moment'])
            data.moment.([side fieldToCheck 'Moment']) = nan(nFrames, 3);
        end
    end
end
