function data = extractEvents(c3d, data)

    data.events = c3dEvents(c3d);
    tp_field = fieldnames(data.events);
    % Convertir les temps en frames (et retirer les frames retirés au début
    for i = 1:length(tp_field)
        % S'assurer que si l'essai est coupé avant ou après que des événements
        % soient définis, que ça les retire
        stamps = unique(data.events.(tp_field{i}));
        idxTrue = round(stamps * data.angleInfos.frequency) > c3dFirstFrame(c3d) & ...
                  round(stamps * data.angleInfos.frequency) < c3dLastFrame(c3d);
        
        data.stamps.(tp_field{i}).timeStamp = stamps(idxTrue) - (c3dFirstFrame(c3d)/data.angleInfos.frequency);
        data.stamps.(tp_field{i}).frameStamp = round(stamps(idxTrue) * data.angleInfos.frequency) - c3dFirstFrame(c3d);
        
        % Il y a des cas (étranges?) où les times frames descendent sous
        % zéro, il faut les retirer (ne devrait plus arriver depuis %idxTrue) 
        data.stamps.(tp_field{i}).frameStamp = data.stamps.(tp_field{i}).frameStamp(data.stamps.(tp_field{i}).frameStamp>0);
        data.stamps.(tp_field{i}).timeStamp = data.stamps.(tp_field{i}).timeStamp(data.stamps.(tp_field{i}).frameStamp>0);
    end

    data.stamps.FullTrial.frameStamps = 1:c3dLastFrame(c3d)-c3dFirstFrame(c3d);
    data.stamps.FullTrial.timeStamps = linspace(c3dFirstFrame(c3d)/data.angleInfos.frequency, c3dLastFrame(c3d)/data.angleInfos.frequency, length(data.stamps.FullTrial.frameStamps));
end