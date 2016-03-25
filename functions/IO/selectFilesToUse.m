function [idx_kin_out, idx_dyn_out] = selectFilesToUse(data)
    
    % Nom des angles
    nameAngToKeep = fieldnames(data.Left(1).angle); % Pareil pour tous essais + côtés
    % Retirer le préfixe L ou R
    nameAngToKeepToPopMenu = nameAngToKeep;
    for i = 1:length(nameAngToKeepToPopMenu)
        nameAngToKeepToPopMenu{i} = nameAngToKeepToPopMenu{i}(2:end);
    end
    nameAngToKeepToPopMenu = unique(nameAngToKeepToPopMenu);
   
    trialWithPlateForme = [];
    cmp = 0;
    idxLeft = [];
    idxRight = [];
    for iSide = 1:2 % Tous les fichiers ouverts (gauche - droit)
        sides = fieldnames(data);
        for i = 1:length(data.(sides{iSide}));
            cmp = cmp+1;
            if strcmp(sides{iSide}, 'Left')
                idxLeft(end+1) = cmp; %#ok<AGROW>
            elseif strcmp(sides{iSide}, 'Right')
                idxRight(end+1) = cmp; %#ok<AGROW>
            end
            
            % Dispatch des noms de l'essai
            dataToShowName{cmp} = data.(sides{iSide})(i).filename; %#ok<AGROW>

            % Dispatch des angles
            for iN = 1:length(nameAngToKeepToPopMenu)
                dataToShow.(nameAngToKeepToPopMenu{iN})(:,:,cmp) = data.(sides{iSide})(i).angle.([sides{iSide}(1) nameAngToKeepToPopMenu{iN}]);
            end

            % Dispatch des plateforme de force
            dataToShowFP(cmp).pf = data.(sides{iSide})(i).forceplate; %#ok<AGROW>
            if data.(sides{iSide})(i).IsFootOnPF
                dataToShowName{cmp} = [dataToShowName{cmp} ' (pf)']; %#ok<AGROW>
                trialWithPlateForme = [trialWithPlateForme cmp]; %#ok<AGROW>
            end
        end
    end

    % Demander les essais cinématiques à conserver
    idx_kin = chooseFromAngle(dataToShow, dataToShowName, nameAngToKeepToPopMenu);

    % Demander les essais avec de la dynamique à conserver
    % Retirer ce qui a été retiré à l'instant précédent
    trialWithPlateForme = intersect(trialWithPlateForme, idx_kin);
%     idx_dyn = chooseFromDynamics_reverse(dataToShowFP, dataToShowName, trialWithPlateForme);
    idx_dyn = chooseFromDynamics(dataToShowFP, dataToShowName, trialWithPlateForme);
    
    % Séparer gauche droite
    [~,~,idx_kin_out.Left] = intersect(idx_kin, idxLeft);
    [~,~,idx_kin_out.Right] = intersect(idx_kin, idxRight);
    [~,~,idx_dyn_out.Left] = intersect(idx_dyn, idxLeft);
    [~,~,idx_dyn_out.Right] = intersect(idx_dyn, idxRight);
end
