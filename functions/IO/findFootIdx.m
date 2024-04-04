function [idxPiedGauche, idxPiedDroit, idxPlateFormePiedGauche, idxPlateFormePiedDroit, numPFGauche, numPFDroit] = findFootIdx(data, stamps)
   
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
        idxPiedGauche = ceil(length(stamps.Left_Foot_FullCycle.frameStamps)/2);
        idxPiedGauche(2,:) = idxPiedGauche+1;
    end
    % Si on n'a pas trouvé de plateforme, prendre les cycles du milieu
    if ~isRightFootFound
        idxPiedDroit = ceil(length(stamps.Right_Foot_FullCycle.frameStamps)/2);
        idxPiedDroit(2,:) = idxPiedDroit+1;
    end
    
    % Si on a trouvé deux fois la même plateforme, c'est que la stratégie
    % initiale n'a pas fonctionnée, il faut essayer avec la cinématique
    % (peut-être cette stratégie est plus robuste en tout temps? pour
    % l'instant il est design pour l'essai statique)
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