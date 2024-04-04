function [idx_kin_out, idx_dyn_out] = selectFilesToUse(data, automaticRemoveOfEmptyTrial)
    
    % Nom des angles
    if isfield(data, 'Left')
        dataRef = data.Left(1);
    elseif isfield(data, 'Right')
        dataRef = data.Right(1);
    else
        error('No data in the file')
    end
    
    nameAngToKeep = fieldnames(dataRef.angle);
    if isfield(data, 'Left')
        for i = 1:length(data.Left)
            nameAngToKeep = union(nameAngToKeep, fieldnames(data.Left(i).angle));
        end
    end
    if isfield(data, 'Right')
        for i = 1:length(data.Right)
            nameAngToKeep = union(nameAngToKeep, fieldnames(data.Right(i).angle));
        end
    end
    
    % Retirer le préfixe L ou R
    nameAngToKeepToPopMenu = nameAngToKeep;
    for i = 1:length(nameAngToKeepToPopMenu)
        nameAngToKeepToPopMenu{i} = nameAngToKeepToPopMenu{i}(2:end);
    end
    nameAngToKeepToPopMenu = unique(nameAngToKeepToPopMenu);
   
    % Nom des moments
    % Retirer le préfixe L ou R
    nameMomentToKeep = fieldnames(dataRef.moment); % Pareil pour tous essais + côtés
    for i = 1:length(nameMomentToKeep)
        nameMomentToKeep{i} = nameMomentToKeep{i}(2:end);
    end
    nameMomentToKeep = unique(nameMomentToKeep);
   
    
    trialWithPlateForme = [];
    cmp = 0;
    idxLeft = [];
    idxRight = [];
    sides = fieldnames(data);
    for iSide = 1:length(sides)
        for i = 1:length(data.(sides{iSide}))
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
                fieldname = [sides{iSide}(1) nameAngToKeepToPopMenu{iN}];
                if isfield(data.(sides{iSide})(i).angle, fieldname)
                    dataToShowAng.(nameAngToKeepToPopMenu{iN})(:,:,cmp) = data.(sides{iSide})(i).angle.(fieldname);
                else
                    dataToShowAng.(nameAngToKeepToPopMenu{iN})(:,:,cmp) = nan(100, 3);
                end
            end

            % Dispatch des moments aux articulations
            for iN = 1:length(nameMomentToKeep)
                dataToShowMoment.(nameMomentToKeep{iN})(:,:,cmp) = data.(sides{iSide})(i).moment.([sides{iSide}(1) nameMomentToKeep{iN}]);
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
    idx_kin = chooseFromAngle(dataToShowAng, dataToShowName, nameAngToKeepToPopMenu, automaticRemoveOfEmptyTrial);

    % Demander les essais avec moments à conserver
    trialWithPlateForme = intersect(trialWithPlateForme, idx_kin);
    idx_moment = chooseFromMoment(dataToShowMoment, dataToShowName, nameMomentToKeep, trialWithPlateForme);
    
    % Demander les essais avec de la dynamique à conserver
    % Retirer ce qui a été retiré à l'instant précédent
    trialWithPlateForme = intersect(trialWithPlateForme, idx_moment);
    idx_dyn = chooseFromDynamics(dataToShowFP, dataToShowName, trialWithPlateForme);
    
    % Séparer gauche droite
    [~,~,idx_kin_out.Left] = intersect(idx_kin, idxLeft);
    [~,~,idx_kin_out.Right] = intersect(idx_kin, idxRight);
    [~,~,idx_dyn_out.Left] = intersect(idx_dyn, idxLeft);
    [~,~,idx_dyn_out.Right] = intersect(idx_dyn, idxRight);
end
