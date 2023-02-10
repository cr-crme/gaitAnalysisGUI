function dataOut = normalizeData(data, selectAllCycles)

    % Nom des champs à normaliser
    fieldToNormalize = {'angle', 'markers', 'moment', 'power'};
    analFieldToNormalize = {'forceplate'};
    
    % Aller chercher les stamps pour savoir où couper
    stamps = extractStamps(data.stamps, data.angleInfos.frequency);
    
    % Trouver les deux cycles de cet essai (où on met le pied sur la plateforme +1)
    [idxPiedGauche,idxPiedDroit,onPlateFormeLeft,idxPlateFormePiedDroit, numPFGauche, numPFDroit] = findFootIdx(data, stamps, selectAllCycles);

    
    % Conserver les angles de 0 à 100% pour le pied gauche
    if isempty(numPFGauche) && isempty(onPlateFormeLeft)
        for i=1:size(idxPiedGauche,2)
            dataOut.Left(i) = resampleData(data, stamps, stamps.Left_Foot_FullCycle.frameStamps{idxPiedGauche(1,i)},...
                intersect(idxPiedGauche(1,i),idxPiedGauche(1,i)), 1, fieldToNormalize, analFieldToNormalize); 
            dataOut.Left(i).IsFootOnPF = false;
            dataOut.Left(i).idxPlateForme = [];
            dataOut.Left(i).forceplate.channels.Fx1 = [];
            dataOut.Left(i).forceplate.channels.Fy1 = [];
            dataOut.Left(i).forceplate.channels.Fz1 = [];
            dataOut.Left(i).forceplate.channels.Mx1 = [];
            dataOut.Left(i).forceplate.channels.My1 = [];
            dataOut.Left(i).forceplate.channels.Mz1 = [];
        end
    else
        for j=1:size(idxPiedGauche,2)
            % Trouver les nouveaux stamps
            dataOut.Left(j) = resampleData(data, stamps, stamps.Left_Foot_FullCycle.frameStamps{idxPiedGauche(j)},...
                intersect(idxPiedGauche(j),onPlateFormeLeft), numPFGauche, fieldToNormalize, analFieldToNormalize); 
        end
    end

    % Conserver les angles de 0 à 100% pour le pied droit
    if isempty(numPFDroit) && isempty(idxPlateFormePiedDroit)
        for i=1:size(idxPiedDroit,2)
            dataOut.Right(i) = resampleData(data, stamps, stamps.Right_Foot_FullCycle.frameStamps{idxPiedDroit(1,i)},...
                intersect(idxPiedDroit(1,i),idxPiedDroit(1,i)), 1, fieldToNormalize, analFieldToNormalize); 
            dataOut.Right(i).IsFootOnPF = false;
            dataOut.Right(i).idxPlateForme = [];
            dataOut.Right(i).forceplate.channels.Fx1 = [];
            dataOut.Right(i).forceplate.channels.Fy1 = [];
            dataOut.Right(i).forceplate.channels.Fz1 = [];
            dataOut.Right(i).forceplate.channels.Mx1 = [];
            dataOut.Right(i).forceplate.channels.My1 = [];
            dataOut.Right(i).forceplate.channels.Mz1 = [];
        end
    else
        for j=1:size(idxPiedDroit,2)
            % Trouver les nouveaux stamps
            dataOut.Right(j) = resampleData(data, stamps, stamps.Right_Foot_FullCycle.frameStamps{idxPiedDroit(j)},...
                intersect(idxPiedDroit(j),idxPlateFormePiedDroit), numPFDroit, fieldToNormalize, analFieldToNormalize);
        end
    end

    % Normaliser le centre de masse en fonction de la base de support
    if isfield(dataOut, 'Left')
        for i = 1:length(dataOut.Left)
            % Trouver le système d'axes 
            Y = diff(dataOut.Left(i).markers.LHEE([1 end],:))'; % Vers l'avant à partir de talon jusqu'à talon
            Z = [0 0 1]'; % Axe vers le haut
            X = cross(Y,Z);
            Y = cross(Z,X);
            X = X/norm(X); Y = Y/norm(Y); Z = Z/norm(Z);
            R = [X Y Z]; % Matrice de rotation
            
            % Tourner le CoM
            dataOut.Left(i).markers.CentreOfMassInRef = (R'*dataOut.Left(i).markers.CentreOfMass')';
            dataOut.Left(i).markers.LTOEInRef = (R'*dataOut.Left(i).markers.LTOE')';
            dataOut.Left(i).markers.RTOEInRef = (R'*dataOut.Left(i).markers.RTOE')';
        end
    end
    if isfield(dataOut, 'Right')
        for i = 1:length(dataOut.Right)
            % Trouver le système d'axes 
            Y = diff(dataOut.Right(i).markers.RHEE([1 end],:))'; % Vers l'avant à partir de talon jusqu'à talon
            Z = [0 0 1]'; % Axe vers le haut
            X = cross(Y,Z);
            Y = cross(Z,X);
            X = X/norm(X); Y = Y/norm(Y); Z = Z/norm(Z);
            R = [X Y Z]; % Matrice de rotation
            
            % Tourner le CoM
            dataOut.Right(i).markers.CentreOfMassInRef = (R'*dataOut.Right(i).markers.CentreOfMass')';
            dataOut.Right(i).markers.LTOEInRef = (R'*dataOut.Right(i).markers.LTOE')';
            dataOut.Right(i).markers.RTOEInRef = (R'*dataOut.Right(i).markers.RTOE')';
        end
    end
end

function idx = findNewStampsFor(name, fullCycleStamps)
    f = name.frameStamp;
    for i = 1:length(f)
        if f(i) >= fullCycleStamps(1) && f(i) < fullCycleStamps(end)
            idx = floor(find(fullCycleStamps == f(i)) / length(fullCycleStamps) *100);
            if idx == 0
                idx = 1;
            end
            return;
        end
    end
end

function [idxPiedGauche, idxPiedDroit, idxPlateFormePiedGauche, idxPlateFormePiedDroit, numPFGauche, numPFDroit] = findFootIdx(data, stamps, selectAllCycles)
   
    isLeftFootFound = false;
    isRightFootFound = false;
    idxPlateFormePiedGauche = [];
    idxPlateFormePiedDroit = [];
    numPFGauche = [];
    numPFDroit = [];
    for iPf = 1:length(data.forceplate)
        nameChannels = fieldnames(data.forceplate(iPf).channels);
        % Find Fz
        FzName = nameChannels{cellfun(@(IDX) ~isempty(IDX), strfind(nameChannels, 'Fz'))};
        dataFz = data.forceplate(iPf).channels.(FzName);
%         figure; plot(dataFz); hold on
%         hinitg = plot(nan, 'ro');
%         hinitd = plot(nan, 'bo');
        for iC = 1:length(stamps.Left_Foot_FullCycle.frameStamps)
            if ~isLeftFootFound
                % Début et fin du cycle pour le pied gauche
                FootStamp = stamps.Left_Foot_FullStance.frameStamps{iC}([1 end])*data.ratioFrequence;
                if mean(abs(dataFz(FootStamp(1):FootStamp(1)+100))) > 10 && ... % moyenne > 10 Newton
                        mean(abs(dataFz(FootStamp(2)-100:FootStamp(2)))) > 10
%                     set(hinitg, 'xdata', FootStamp, 'ydata', [0 0]);
                    isLeftFootFound = true;
                    numPFGauche = iPf;
                    idxPiedGauche(1) = iC;
                    idxPlateFormePiedGauche = iC;
                    if iC == length(stamps.Left_Foot_FullCycle.frameStamps) && iC == 1
                        
                    elseif iC == length(stamps.Left_Foot_FullCycle.frameStamps)
                        idxPiedGauche(2) = iC-1;
                    else
                        idxPiedGauche(2) = iC+1;
                    end
                end
            end
            if ~isRightFootFound && iC <= length(stamps.Right_Foot_FullStance.frameStamps)
                % Début et fin du cycle pour le pied Droit
                FootStamp = stamps.Right_Foot_FullStance.frameStamps{iC}([1 end])*data.ratioFrequence;
                if mean(abs(dataFz(FootStamp(1):FootStamp(1)+100))) > 10 && ... % moyenne > 10 Newton
                        mean(abs(dataFz(FootStamp(2)-100:FootStamp(2)))) > 10
%                     set(hinitd, 'xdata', FootStamp, 'ydata', [0 0]);
                    isRightFootFound = true;
                    numPFDroit = iPf;
                    idxPiedDroit(1) = iC;
                    idxPlateFormePiedDroit = iC;
                    if iC == length(stamps.Right_Foot_FullCycle.frameStamps) && iC == 1
                        
                    elseif iC == length(stamps.Right_Foot_FullCycle.frameStamps)
                        idxPiedDroit(2) = iC-1;
                    else
                        idxPiedDroit(2) = iC+1;
                    end
                end
            end
        end       
    end

    % Si on n'a pas trouvé de plateforme, prendre les cycles du milieu
    if ~isLeftFootFound
        if selectAllCycles
            idxPiedGauche(1,:) = 1:length(stamps.Left_Foot_FullCycle.frameStamps);
        else
            idxPiedGauche = floor(length(stamps.Left_Foot_FullCycle.frameStamps)/2);
        end
        if idxPiedGauche == 0
            idxPiedGauche = 1; % Un seul cycle a été trouvé
        else
            idxPiedGauche(2,:) = idxPiedGauche+1;
        end
    end
    % Si on n'a pas trouvé de plateforme, prendre les cycles du milieu
    if ~isRightFootFound
        if selectAllCycles
            idxPiedDroit(1,:) = 1:length(stamps.Right_Foot_FullCycle.frameStamps);
        else
            idxPiedDroit = floor(length(stamps.Right_Foot_FullCycle.frameStamps)/2);
        end
        if idxPiedDroit == 0
            idxPiedDroit = 1; % Un seul cycle a été trouvé
        else
            idxPiedDroit(2,:) = idxPiedDroit+1;
        end
    end
    
    % Si on a trouvé deux fois la même plateforme, c'est que la stratégie
    % initiale n'a pas fonctionnée, il faut essayer avec la cinématique
    % (peut-être cette stratégie est plus robuste en tout temps? pour
    % l'instant il est design pour l'essai statique)
    
    % Does not work very well for static trials! workaround written in main
    if isLeftFootFound && isRightFootFound && numPFGauche == numPFDroit
        % Prendre la maléole du pied gauche et droit et déterminer dans
        % quelle plateforme ils sont situé
        LANK = mean(data.markers.LANK,1);
        RANK = mean(data.markers.RANK,1);
        for iPF = 1:length(data.forceplate)
            if LANK(1) > min(data.forceplate(iPF).corners(1,:)) && ...
               LANK(1) < max(data.forceplate(iPF).corners(1,:)) && ...
               LANK(2) > min(data.forceplate(iPF).corners(2,:)) && ...
               LANK(2) < max(data.forceplate(iPF).corners(2,:)) 
                numPFGauche = iPF;
            end
            if RANK(1) > min(data.forceplate(iPF).corners(1,:)) && ...
               RANK(1) < max(data.forceplate(iPF).corners(1,:)) && ...
               RANK(2) > min(data.forceplate(iPF).corners(2,:)) && ...
               RANK(2) < max(data.forceplate(iPF).corners(2,:)) 
                numPFDroit = iPF;
            end
            
        end
    end
end

function dataOut = resampleData(data, stamps, frames, isFootOnPlateForme, numPF, fieldToNormalize, analFieldToNormalize)
    
    % Frames et leur conversion pour les deux cycles de marche
    newFrames = linspace(frames(1), frames(end), 100);
    dataOut.tempsCycle = (frames(end) - frames(1)) / 100; % ms => s
    for iF = 1:length(fieldToNormalize)
        fields = fieldnames(data.(fieldToNormalize{iF}));
        for iF2 = 1:length(fields) 
            % Les mettre sur 100%
            dataOut.(fieldToNormalize{iF}).(fields{iF2}) = interp1(frames, data.(fieldToNormalize{iF}).(fields{iF2})(frames,:), newFrames); 
        end
    end
    
    % Frames et leur conversion pour les deux cycles de marche à 51 éléments
    newFrames = linspace(frames(1),frames(end), 51);
    for iF = 1:length(fieldToNormalize)
        fields = fieldnames(data.(fieldToNormalize{iF}));
        for iF2 = 1:length(fields) 
            dataOut.([fieldToNormalize{iF} '_50']).(fields{iF2}) = interp1(frames, data.(fieldToNormalize{iF}).(fields{iF2})(frames,:), newFrames); 
        end
    end

    % Données dynamiques
    % Frames et leur conversion pour les deux cycles de marche
    framesPF = frames(1)*data.ratioFrequence:(frames(end)+1)*data.ratioFrequence-1;
    newFramesPF = linspace(framesPF(1), framesPF(end), 1000);
    for iF = 1:length(analFieldToNormalize)
        if strcmp(analFieldToNormalize{iF}, 'forceplate')
            ndevices = numPF;
        else
            ndevices = 1:length(data.(analFieldToNormalize{iF}));
        end
        cmp = 1;
        for iN = ndevices % Pour chaque analogique de ce nom
            names = fieldnames(data.(analFieldToNormalize{iF})(iN).channels);
            for iC = 1:length(names)
                dataOut.(analFieldToNormalize{iF})(cmp).channels.(names{iC}) = interp1(framesPF, data.(analFieldToNormalize{iF})(iN).channels.(names{iC})(framesPF,:), newFramesPF); 
            end
            cmp = cmp+1;
        end
    end
    
    % Trouver si le pied a touché la pf sur ces timeframes
    if isFootOnPlateForme
        dataOut.IsFootOnPF = true;
        dataOut.idxPlateForme = 1; %numPF; Puisque les données sont retirées.. initialement index vers les données
    else
        dataOut.IsFootOnPF = false;
        dataOut.idxPlateForme = [];
    end
    
    % Extraire les nouveaux stamps (les heel strikes et toe off)
    dataOut.stamps.Left_Foot_Strike.frameStamp = findNewStampsFor(stamps.Left_Foot_Strike, frames);
    dataOut.stamps.Left_Foot_Off.frameStamp = findNewStampsFor(stamps.Left_Foot_Off, frames);
    dataOut.stamps.Right_Foot_Strike.frameStamp = findNewStampsFor(stamps.Right_Foot_Strike, frames);
    dataOut.stamps.Right_Foot_Off.frameStamp = findNewStampsFor(stamps.Right_Foot_Off, frames);

end