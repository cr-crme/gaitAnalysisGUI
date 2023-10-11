function [out, outInfo] = c3dAngles(c3d)

    if isfield(c3d, 'ezc3d')
        names = c3d.ezc3d.c3d.parameters.POINT.LABELS.DATA;
        out = struct();
        for i = 1:length(names)
            if length(names{i}) > length('Angles') && ...
                    (strcmp(names{i}(end-5:end), 'Angles') || strcmp(names{i}(end-4:end), 'Angle'))
                out.(names{i}) = squeeze(c3d.ezc3d.c3d.data.points(:, i, :))';
            end
        end
        outInfo.frequency = c3d.ezc3d.c3d.parameters.POINT.RATE.DATA;
        if isfield(c3d.ezc3d.c3d.parameters.POINT, 'ANGLE_UNITS')
            outInfo.units.ALLANGLES = c3d.ezc3d.c3d.parameters.POINT.ANGLE_UNITS.DATA{1};
        end
    elseif isfield(c3d, 'btk')
        [out, outInfo] = btkGetAngles(c3d.btk);
    else
        error('C3D reader not found or not implemented');
    end

end