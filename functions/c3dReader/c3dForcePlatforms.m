function [out, outInfo] = c3dForcePlatforms(c3d)

    if isfield(c3d, 'ezc3d')
        names = c3d.ezc3d.parameters.ANALOG.LABELS.DATA;
        for npf = 1:c3d.ezc3d.parameters.FORCE_PLATFORM.USED.DATA
            for i = 1:length(names)
                if length(names{i}) > 2 && str2double(names{i}(3:end)) == npf && (...
                        strcmp(names{i}(1:2), 'Fx')...
                        || strcmp(names{i}(1:2), 'Fy')...
                        || strcmp(names{i}(1:2), 'Fz')...
                        || strcmp(names{i}(1:2), 'Mx')...
                        || strcmp(names{i}(1:2), 'My')...
                        || strcmp(names{i}(1:2), 'Mz')...
                        ) 
                    out(npf).channels.(names{i}) = c3d.ezc3d.data.analogs(:, i); %#ok<AGROW>
                end
                if i < 7
                    outInfo.units.(names{i}) = c3d.ezc3d.parameters.ANALOG.UNITS.DATA{i};
                end
            end
            out.corners = c3d.ezc3d.parameters.FORCE_PLATFORM.CORNERS.DATA(:, :, npf);
            out.origin = c3d.ezc3d.parameters.FORCE_PLATFORM.ORIGIN.DATA(:, npf);
            out.type = c3d.ezc3d.parameters.FORCE_PLATFORM.TYPE.DATA;

        end
        outInfo.frequency = c3d.ezc3d.parameters.ANALOG.RATE.DATA;
        outInfo.cal_matrix = eye(6);
    elseif isfield(c3d, 'btk')
        [out, outInfo] = btkGetForcePlatforms(c3d.btk);
    else
        error('C3D reader not found or not implemented');
    end

end