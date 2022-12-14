function data = extractEvents(c3d, data)

    data.events = btkGetEvents(c3d);
    tp_field = fieldnames(data.events);
    % Convertir les temps en frames (et retirer les frames retirés au début
    for i = 1:length(tp_field)
        % S'assurer que si l'essai est coupé avant ou après que des événements
        % soient définis, que ça les retire
        stamps = unique(data.events.(tp_field{i}));
        idxTrue = round(stamps * data.angleInfos.frequency) > btkGetFirstFrame(c3d) & ...
                  round(stamps * data.angleInfos.frequency) < btkGetLastFrame(c3d);
        
        data.stamps.(tp_field{i}).timeStamp = stamps(idxTrue) - (btkGetFirstFrame(c3d)/data.angleInfos.frequency);
        data.stamps.(tp_field{i}).frameStamp = round(stamps(idxTrue) * data.angleInfos.frequency) - btkGetFirstFrame(c3d);
        
        % Il y a des cas (étranges?) où les times frames descendent sous
        % zéro, il faut les retirer (ne devrait plus arriver depuis %idxTrue) 
        data.stamps.(tp_field{i}).frameStamp = data.stamps.(tp_field{i}).frameStamp(data.stamps.(tp_field{i}).frameStamp>0);
        data.stamps.(tp_field{i}).timeStamp = data.stamps.(tp_field{i}).timeStamp(data.stamps.(tp_field{i}).frameStamp>0);
    end

    data.stamps.FullTrial.frameStamps = 1:btkGetLastFrame(c3d)-btkGetFirstFrame(c3d);
    data.stamps.FullTrial.timeStamps = linspace(btkGetFirstFrame(c3d)/data.angleInfos.frequency, btkGetLastFrame(c3d)/data.angleInfos.frequency, length(data.stamps.FullTrial.frameStamps));
end