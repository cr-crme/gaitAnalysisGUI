function out = c3dMarkers(c3d)

    if isfield(c3d, 'ezc3d')
        names = c3d.ezc3d.c3d.parameters.POINT.LABELS.DATA;
        out = struct();
        for i = 1:length(names)
            if (length(names{i}) < length('Angles') || ~strcmp(names{i}(end-5:end), 'Angles')) ... 
                    && (length(names{i}) < length('Angle') || ~strcmp(names{i}(end-4:end), 'Angle')) ... 
                    && (length(names{i}) < length('Power') || ~strcmp(names{i}(end-4:end), 'Power')) ...
                    && (length(names{i}) < length('Force') || ~strcmp(names{i}(end-4:end), 'Force')) ...
                    && (length(names{i}) < length('Moment') || ~strcmp(names{i}(end-5:end), 'Moment'))
                if strcmp(names{i}(1), '*')
                    name = sprintf('C_%s', names{i}(2:end));
                else
                    name = names{i}(1:end);
                end
            
                out.(name) = squeeze(c3d.ezc3d.c3d.data.points(:, i, :))';
            end
        end
    elseif isfield(c3d, 'btk')
        out = btkGetMarkers(c3d.btk);
    else
        error('C3D reader not found or not implemented');
    end

end