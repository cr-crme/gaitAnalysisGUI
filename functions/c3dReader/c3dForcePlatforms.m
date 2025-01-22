function [out, outInfo] = c3dForcePlatforms(c3d)
    
    out = [];
    if isfield(c3d, 'ezc3d')
        names = c3d.ezc3d.c3d.parameters.ANALOG.LABELS.DATA;
        for npf = 1:c3d.ezc3d.c3d.parameters.FORCE_PLATFORM.USED.DATA
            for i = 1:length(names)
                name = names{i};
                if length(name) >= 6 && strcmp(name(1:6), 'Force.')
                    name = name(7:end);
                end
                if length(name) >= 6 && strcmp(name(1:7), 'Moment.')
                    name = name(8:end);
                end
                if length(name) > 2 && str2double(name(3:end)) == npf && (...
                        strcmp(name(1:2), 'Fx')...
                        || strcmp(name(1:2), 'Fy')...
                        || strcmp(name(1:2), 'Fz')...
                        || strcmp(name(1:2), 'Mx')...
                        || strcmp(name(1:2), 'My')...
                        || strcmp(name(1:2), 'Mz')...
                        ) 
                    out(npf).channels.(name) = c3d.ezc3d.c3d.data.analogs(:, i); %#ok<AGROW>
                end
                if i < 7
                    outInfo.units.(name) = c3d.ezc3d.c3d.parameters.ANALOG.UNITS.DATA{i};
                end
            end
            out(npf).corners = c3d.ezc3d.c3d.parameters.FORCE_PLATFORM.CORNERS.DATA(:, :, npf);
            out(npf).origin = c3d.ezc3d.c3d.parameters.FORCE_PLATFORM.ORIGIN.DATA(:, npf);
            out(npf).type = c3d.ezc3d.c3d.parameters.FORCE_PLATFORM.TYPE.DATA;

        end
        outInfo.frequency = c3d.ezc3d.c3d.parameters.ANALOG.RATE.DATA;
        outInfo.cal_matrix = eye(6);
    elseif isfield(c3d, 'btk')
        [out, outInfo] = btkGetForcePlatforms(c3d.btk);
    else
        error('C3D reader not found or not implemented');
    end

end