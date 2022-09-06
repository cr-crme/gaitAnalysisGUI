function out = c3dMoments(c3d)

    if isfield(c3d, 'ezc3d')
        names = c3d.ezc3d.c3d.parameters.POINT.LABELS.DATA;
        out = struct();
        for i = 1:length(names)
            if length(names{i}) > length('Moment') && strcmp(names{i}(end-5:end), 'Moment')
                out.(names{i}) = squeeze(c3d.ezc3d.c3d.data.points(:, i, :))';
            end
        end
    elseif isfield(c3d, 'btk')
        out = btkGetMoments(c3d.btk);
    else
        error('C3D reader not found or not implemented');
    end

end