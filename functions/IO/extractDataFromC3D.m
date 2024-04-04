function data = extractDataFromC3D(c3d, selectAllCycles)
    % Recevoir les métadonnées
    data.metadata = c3dParameters(c3d); % On peut le faire sur un seul fichier, car tous le même sujet

    % Récupérer les angles au cours du temps
    [data.angle, data.angleInfos] = c3dAngles(c3d);

    % Récupérer les marqueurs au cours du temps
    data.markers = c3dMarkers(c3d);

    % Récupérer la cinétique
    data.moment = c3dMoments(c3d);
    if ~isempty(fieldnames(data.moment))
        if ~isfield(data.moment, 'LGroundReactionMoment')
            f = fieldnames(data.moment);
            data.moment.LGroundReactionMoment = nan(size(data.moment.(f{1})));
        end
        if ~isfield(data.moment, 'RGroundReactionMoment')
            f = fieldnames(data.moment);
            data.moment.RGroundReactionMoment = nan(size(data.moment.(f{1})));
        end
    end
    data.power = c3dPowers(c3d);


    % Extraire les plateformes de force
    [data.forceplate, data.forceplatinfo] = c3dForcePlatforms(c3d);
    data.ratioFrequence = data.forceplatinfo(1).frequency / data.angleInfos.frequency;
    
     % Extraire les événements
    data = extractEvents(c3d, data);
    
    % Compléter les fields qui manquent pour que l'analyse ne crash pas
    data = fillMissingData(data);
    
    % Normaliser les données
    data.norm = normalizeData(data, selectAllCycles);
    
    % mapping du cycle de marche pour les frame stamp (ex. le fram 35 représente quel % de marche)
    data = computePourcentCycleMarche(data);

    if isfield(data.norm, 'Left')
        for i = 1:length(data.norm.Left)
            % Déterminer les frames unipodaux
            data.norm.Left(i).stamps.Left_Foot_Strike.frameStamp = [1 100];
            data.norm.Left(i).stamps = extractStamps(data.norm.Left(i).stamps, data.angleInfos.frequency);
        end
    end
    if isfield(data.norm, 'Right')
        for i = 1:length(data.norm.Right)
            % Déterminer les frames unipodaux
            data.norm.Right(i).stamps.Right_Foot_Strike.frameStamp = [1 100];
            data.norm.Right(i).stamps = extractStamps(data.norm.Right(i).stamps, data.angleInfos.frequency);
        end
    end
end