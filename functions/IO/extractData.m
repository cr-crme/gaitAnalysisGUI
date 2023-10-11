function ang = extractData(data, fieldOrFrameStamps, typeData, typeKin)

    if ischar(fieldOrFrameStamps)
        field = fieldOrFrameStamps;
        % Au tronc
        ang.LThorax = data.(typeData).(['LThorax' typeKin])(data.stamps.(field).frameStamp,:);
        ang.RThorax = data.(typeData).(['RThorax' typeKin])(data.stamps.(field).frameStamp,:);

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
            for name = {'Thorax', 'Pelvis', 'Hip', 'Knee', 'Ankle', 'FootProgress'}
                for side = {'L', 'R'}
                    if strcmp(name{1}, 'FootProgress') && ~doFootProgress
                        continue
                    end

                    fullName = [side{1} name{1} typeKin];
                    if isfield(data.(typeData), fullName) && ~isempty(data.(typeData).(fullName))
                        ang.([side{1} name{1}]){i} = data.(typeData).(fullName)(f{i},:);
                    else
                        ang.([side{1} name{1}]){i} = fillvalue([], f{i}, 3);
                    end     
                end
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