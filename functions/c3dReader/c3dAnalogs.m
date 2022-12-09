function out = c3dAnalogs(c3d)

    if isfield(c3d, 'ezc3d')
        c3d.ezc3d.c3d.data.analogs;
        names = c3d.ezc3d.c3d.parameters.ANALOG.LABELS.DATA;
        names = strrep(names, ' ', '_');
        names = strrep(names, '.', '_');
        out = struct();
        for i = 1:length(names)
            out.(names{i}) = c3d.ezc3d.c3d.data.analogs(:, i);
        end
    elseif isfield(c3d, 'btk')
        out = btkGetAnalogs(c3d.btk);
    else
        error('C3D reader not found or not implemented');
    end
    
    % Add the 16 characters name of each field
    names = fieldnames(out);
    for i = 1:length(names)
        if length(names{i}) > 16
            out.(names{i}(1:16)) = out.(names{i});
        end
    end

end