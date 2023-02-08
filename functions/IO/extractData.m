function ang = extractData(data, fieldOrFrameStamps, typeData, typeKin)

    if ischar(fieldOrFrameStamps)
        field = fieldOrFrameStamps;
        % Au tronc
        if isfield(['LThorax' typeKin], data.(typeData))
            ang.LThorax = data.(typeData).(['LThorax' typeKin])(data.stamps.(field).frameStamp,:);
            ang.RThorax = data.(typeData).(['RThorax' typeKin])(data.stamps.(field).frameStamp,:);
        else
            ang.LThorax = data.(typeData).(['LPelvis' typeKin]) * nan;
            ang.RThorax = data.(typeData).(['RPelvis' typeKin]) * nan;
        end

        % Au bassin
        ang.LPelvis = data.(typeData).(['LPelvis' typeKin])(data.stamps.(field).frameStamp,:);
        ang.RPelvis = data.(typeData).(['RPelvis' typeKin])(data.stamps.(field).frameStamp,:);

        % À la hanche
        ang.LHip = data.(typeData).(['LHip' typeKin])(data.stamps.(field).frameStamp,:);
        ang.RHip = data.(typeData).(['RHip' typeKin])(data.stamps.(field).frameStamp,:);

        % Au genou
        ang.LKnee = data.(typeData).(['LKnee' typeKin])(data.stamps.(field).frameStamp,:);
        ang.RKnee = data.(typeData).(['RKnee' typeKin])(data.stamps.(field).frameStamp,:);

        % À la cheville
        ang.LAnkle = data.(typeData).(['LAnkle' typeKin])(data.stamps.(field).frameStamp,:);
        ang.RAnkle = data.(typeData).(['RAnkle' typeKin])(data.stamps.(field).frameStamp,:);

        % Angle du pied
        ang.LFootProgress = data.(typeData).(['LFootProgress' typeKin])(data.stamps.(field).frameStamp,:);
        ang.RFootProgress = data.(typeData).(['RFootProgress' typeKin])(data.stamps.(field).frameStamp,:);

    else 
        f = fieldOrFrameStamps;
        ang.LHip = cell(length(f),1);
        ang.RHip = cell(length(f),1);
        ang.LKnee = cell(length(f),1);
        ang.RKnee = cell(length(f),1);
        ang.LAnkle = cell(length(f),1);
        ang.RAnkle = cell(length(f),1);
        if strcmp(typeData, 'angle') 
            doFootProgress = true;
            ang.LFootProgress = cell(length(f),1);
            ang.RFootProgress = cell(length(f),1);
        else
            doFootProgress = false;
        end
        for i = 1:length(f)
            if isfield( data.(typeData), ['LThorax' typeKin])
                ang.LThorax{i} = data.(typeData).(['LThorax' typeKin])(f{i},:);
                ang.RThorax{i} = data.(typeData).(['RThorax' typeKin])(f{i},:);
            else
                ang.LThorax{i} = fillvalue([], f{i}, 3);
                ang.RThorax{i} = fillvalue([], f{i}, 3);
            end
            
            if isfield( data.(typeData), ['LPelvis' typeKin])
                ang.LPelvis{i} = data.(typeData).(['LPelvis' typeKin])(f{i},:);
                ang.RPelvis{i} = data.(typeData).(['RPelvis' typeKin])(f{i},:);
            else
                ang.LPelvis{i} = fillvalue([], f{i}, 3);
                ang.RPelvis{i} = fillvalue([], f{i}, 3);
            end
            
            ang.LHip{i} = fillvalue(data.(typeData).(['LHip' typeKin]), f{i},3);
            ang.RHip{i} = fillvalue(data.(typeData).(['RHip' typeKin]), f{i},3);
            
            ang.LKnee{i} = fillvalue(data.(typeData).(['LKnee' typeKin]), f{i},3);
            ang.RKnee{i} = fillvalue(data.(typeData).(['RKnee' typeKin]), f{i},3);
            
            ang.LAnkle{i} = fillvalue(data.(typeData).(['LAnkle' typeKin]), f{i},3);
            ang.RAnkle{i} = fillvalue(data.(typeData).(['RAnkle' typeKin]), f{i},3);
            
            if doFootProgress
                ang.LFootProgress{i} = data.(typeData).(['LFootProgress' typeKin])(f{i},:);
                ang.RFootProgress{i} = data.(typeData).(['RFootProgress' typeKin])(f{i},:);
            end
        end
    end
end

function out = fillvalue(data, frames, col)
    if isempty(data)
        out = nan(length(frames),col);
    else
        out = data(frames,1:col);
    end
end