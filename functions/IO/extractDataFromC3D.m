function data = extractDataFromC3D(c3d)
    % Recevoir les métadonnées
    data.metadata = btkGetMetaData(c3d); % On peut le faire sur un seul fichier, car tous le même sujet

    % Récupérer les angles au cours du temps
    [data.angle, data.angleInfos] = btkGetAngles(c3d);

    % Récupérer les marqueurs au cours du temps
    data.markers = btkGetMarkers(c3d);

    % Récupérer la cinétique
    data.moment = btkGetMoments(c3d);
    data.power = btkGetPowers(c3d);


    % Extraire les plateformes de force
    [data.forceplate, data.forceplatinfo] = btkGetForcePlatforms(c3d);
    data.ratioFrequence = data.forceplatinfo(1).frequency / data.angleInfos.frequency;
    
     % Extraire les événements
    data = extractEvents(c3d, data);
    
    % Normaliser les données
    data.norm = normalizeData(data);
    
    % mapping du cycle de marche pour les frame stamp (ex. le fram 35 représente quel % de marche)
    data = computePourcentCycleMarche(data);

    for i = 1:length(data.norm.Left)
        % Déterminer les frames unipodaux
        data.norm.Left(i).stamps.Left_Foot_Strike.frameStamp = [1 100];
        data.norm.Left(i).stamps = extractStamps(data.norm.Left(i).stamps, data.angleInfos.frequency);
    end
    for i = 1:length(data.norm.Right)
        % Déterminer les frames unipodaux
        data.norm.Right(i).stamps.Right_Foot_Strike.frameStamp = [1 100];
        data.norm.Right(i).stamps = extractStamps(data.norm.Right(i).stamps, data.angleInfos.frequency);
    end
end