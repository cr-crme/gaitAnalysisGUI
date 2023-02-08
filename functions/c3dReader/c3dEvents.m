function out = c3dEvents(c3d)

    if isfield(c3d, 'ezc3d')
        out = struct();
        for i = 1:c3d.ezc3d.c3d.parameters.EVENT.USED.DATA
            if ~strcmp(c3d.ezc3d.c3d.parameters.EVENT.LABELS.DATA{i}, 'Foot Strike') && ~strcmp(c3d.ezc3d.c3d.parameters.EVENT.LABELS.DATA{i}, 'Foot Off')
                continue
            end
            
            name = strrep(sprintf('%s_%s', ...
                c3d.ezc3d.c3d.parameters.EVENT.CONTEXTS.DATA{i}, ...
                c3d.ezc3d.c3d.parameters.EVENT.LABELS.DATA{i}), ' ', '_');

            if ~isfield(out, name)
                out.(name) = [];
            end
            out.(name)(1, length(out.(name)) + 1) = c3d.ezc3d.c3d.parameters.EVENT.TIMES.DATA(2, i);
        end
    elseif isfield(c3d, 'btk')
        out = btkGetEvents(c3d.btk);
    else
        error('C3D reader not found or not implemented');
    end

end