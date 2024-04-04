function dataFinal = meanAllResults(dataAll, kinToKeep, dynToKeep, info)
 
    sides = fieldnames(kinToKeep);
    for iS = 1:length(sides)
        s = sides{iS};
        if ~isfield(dataAll, s)
            continue
        end

        dataKinAll = dataAll.(s)(kinToKeep.(s));
        dataDynAll = dataAll.(s)(dynToKeep.(s));
 
        if ~isempty(dataKinAll)
            % Faire le moyennage des données
            angle_fnames = fieldnames(dataAll.(s)(1).angle);
            angle_fnames_50 = fieldnames(dataAll.(s)(1).angle_50);
            marker_fnames = fieldnames(dataAll.(s)(1).markers);
            moment_fnames = fieldnames(dataAll.(s)(1).moment);
            power_fnames = fieldnames(dataAll.(s)(1).power);
            CentreOfMass = fieldnames(dataAll.(s)(1).CentreOfMass);
            baseSustentation = fieldnames(dataAll.(s)(1).baseSustentation);

            kin_angleAll = [];
            kin_angle = [];
            kin_angleStd = [];
            for j = 1:length(angle_fnames)
                for i = 1:length(dataKinAll)
                    kin_angleAll.(angle_fnames{j})(:,:,i) = dataKinAll(i).angle.(angle_fnames{j});
                end
                kin_angleStd.(angle_fnames{j}) = std(kin_angleAll.(angle_fnames{j}),[],3);
                kin_angle.(angle_fnames{j}) = mean(kin_angleAll.(angle_fnames{j}),3);
            end
            kin_angleAll_50 = [];
            kin_angle_50 = [];
            kin_angleStd_50 = [];
            for j = 1:length(angle_fnames_50)
                for i = 1:length(dataKinAll)
                    kin_angleAll_50.(angle_fnames_50{j})(:,:,i) = dataKinAll(i).angle_50.(angle_fnames_50{j});
                end
                kin_angleStd_50.(angle_fnames_50{j}) = std(kin_angleAll_50.(angle_fnames_50{j}),[],3);
                kin_angle_50.(angle_fnames_50{j}) = mean(kin_angleAll_50.(angle_fnames_50{j}),3);
            end

            kin_markersAll = [];
            kin_markers = [];
            kin_markersStd = [];
            for j = 1:length(marker_fnames)
                if length(marker_fnames{j}) > 2 && strcmp(marker_fnames{j}(1:2), 'C_')
                    continue;
                end
                 for i = 1:length(dataKinAll)
                    if strcmp(s, 'Left')
                        if ~strfind(marker_fnames{j}, 'InRef')
                            zeroPosition = dataKinAll(i).markers.LHEE;
                        else
                            zeroPosition = zeros(size(dataKinAll(i).markers.LHEE));
                        end
                    elseif strcmp(s, 'Right')
                        if ~strfind(marker_fnames{j}, 'InRef')
                            zeroPosition = dataKinAll(i).markers.RHEE;
                        else
                            zeroPosition = zeros(size(dataKinAll(i).markers.LHEE));
                        end
                    else
                        error('Côté erronné')
                    end
                    if zeroPosition(end,2) - zeroPosition(1,2) < 0
                        zeroPosition(:,[1 2]) = -zeroPosition(:,[1 2]);
                    end
                    zeroPosition = [repmat([min(zeroPosition(:,1)), zeroPosition(1,2)], [size(zeroPosition,1), 1]), zeros(size(zeroPosition(:,3)))];
                    if isfield(dataKinAll(i).markers, marker_fnames{j})
                        d = dataKinAll(i).markers.(marker_fnames{j});
                    else
                        d = zeroPosition;
                    end
                    
                    % S'assurer que la marche est vers l'avant (tourne autour de z)
                    if d(end,2) - d(1,2) < 0
                        d(:,[1 2]) = -d(:,[1 2]);
                    end
                    % Partir en fct de l'extrême min pour lat,  0 pour frontal et ne rien changer en hauteur 
                    kin_markersAll.(marker_fnames{j})(:,:,i) = d - zeroPosition; 
                end
                kin_markersStd.(marker_fnames{j}) = std(kin_markersAll.(marker_fnames{j}),[],3);
                kin_markers.(marker_fnames{j}) = mean(kin_markersAll.(marker_fnames{j}),3);
            end
 
            com_infoAll = [];
            com_info = [];
            for j = 1:length(CentreOfMass)
                for i = 1:length(dataKinAll)
                    com_infoAll.(CentreOfMass{j})(:,:,i) = dataKinAll(i).CentreOfMass.(CentreOfMass{j});
                end
                com_info.(CentreOfMass{j}) = mean(com_infoAll.(CentreOfMass{j}),3);
            end
            
            base_infoAll = [];
            base_info = [];
            for j = 1:length(baseSustentation)
                for i = 1:length(dataKinAll)
                    base_infoAll.(baseSustentation{j})(:,:,i) = dataKinAll(i).baseSustentation.(baseSustentation{j});
                end
                base_info.(baseSustentation{j}) = mean(base_infoAll.(baseSustentation{j}),3);
            end

            kin_momentAll = [];
            kin_moment = [];
            kin_momentStd = [];
            for j = 1:length(moment_fnames)
                kin_momentAll.(moment_fnames{j}) = [];
                for i = 1:length(dataDynAll)
                    kin_momentAll.(moment_fnames{j})(:,:,i) = dataDynAll(i).moment.(moment_fnames{j});
                end
                if ~isempty(kin_momentAll.(moment_fnames{j}))
                    kin_momentStd.(moment_fnames{j}) = std(kin_momentAll.(moment_fnames{j}), [], 3);
                    kin_moment.(moment_fnames{j}) = mean(kin_momentAll.(moment_fnames{j}), 3);
                else
                    kin_momentStd.(moment_fnames{j}) = [];
                    kin_moment.(moment_fnames{j}) = [];
                end
            end

            kin_powerAll = [];
            kin_power = [];
            kin_powerStd = [];
            for j = 1:length(power_fnames)
                kin_powerAll.(power_fnames{j}) = [];
                for i = 1:length(dataDynAll)
                    kin_powerAll.(power_fnames{j})(:,:,i) = dataDynAll(i).power.(power_fnames{j});
                end
                if ~isempty(kin_powerAll.(power_fnames{j}))
                    kin_powerStd.(power_fnames{j}) = std(kin_powerAll.(power_fnames{j}),[],3);
                    kin_power.(power_fnames{j}) = mean(kin_powerAll.(power_fnames{j}),3);
                else
                    kin_powerStd.(power_fnames{j}) = [];
                    kin_power.(power_fnames{j}) = [];
                end
            end

            dyn_forceplateAll = [];
            dyn_forceplate = [];
            dyn_forceplateStd = [];
            if ~isempty(dataDynAll)
                for pf = 1:length(dataAll.(s)(1).forceplate)
                    fp_fnames = {'Fx' 'Fy' 'Fz' 'Mx' 'My' 'Mz'};
                    for j = 1:length(fp_fnames)
                        for i = 1:length(dataDynAll)
                            comp_names = fieldnames(dataDynAll(i).forceplate(pf).channels);
                            if ~isempty(dataDynAll(i).forceplate(pf).channels.(comp_names{j}))
                                dyn_forceplateAll(pf).channels.(fp_fnames{j})(:,:,i) = dataDynAll(i).forceplate(pf).channels.(comp_names{j}); %#ok<AGROW>
                            end
                        end
                        if ~isempty(dyn_forceplateAll)
                            dyn_forceplateStd(pf).channels.(fp_fnames{j}) = std(dyn_forceplateAll(pf).channels.(fp_fnames{j}),[],3); %#ok<AGROW>
                            dyn_forceplate(pf).channels.(fp_fnames{j}) = mean(dyn_forceplateAll(pf).channels.(fp_fnames{j}),3); %#ok<AGROW>
                        end
                    end
                end
            end
            if isempty(dyn_forceplateAll)
                fp_fnames = {'Fx' 'Fy' 'Fz' 'Mx' 'My' 'Mz'};
                for j = 1:length(fp_fnames)
                    dyn_forceplate.channels.(fp_fnames{j}) = nan(100,1); 
                    dyn_forceplateStd.channels.(fp_fnames{j}) = nan(100,1);
                end
            end
 
            stampsAll = [];
            stamps = [];
            stampsToDo = {'Left_Foot_Off', setdiff( {'Left_Foot_Strike', 'Right_Foot_Strike'}, [s '_Foot_Strike']), 'Right_Foot_Off'};
            stampsToDo(2) = stampsToDo{2};
            for j=1:length(stampsToDo)
                for i = 1:length(dataKinAll)
                    stampsAll.(stampsToDo{j}).frameStamp(i) = dataKinAll(i).stamps.(stampsToDo{j}).frameStamp;
                end
                stamps.(stampsToDo{j}).frameStamp = round(mean(stampsAll.(stampsToDo{j}).frameStamp));
            end
            tempsCycleAll = [dataKinAll(:).tempsCycle];
            tempsCycle = mean([dataKinAll(:).tempsCycle]);

            % Le cas de Left_Foot_Strike est spécial car 2 valeurs (1 et 100)
            stamps.([s '_Foot_Strike']).frameStamp = [1 100]; 
            stamps = extractStamps(stamps, 100);

            % Assembler les données moyennées
            dataFinalTp.info = info; % Prendre les infos demandé à l'ouverture
            if isfield(dataAll, 'Left')
                dataFinalTp.angleInfos = dataAll.Left(1).angleInfos; 
            elseif isfield(dataAll, 'Right')
                dataFinalTp.angleInfos = dataAll.Right(1).angleInfos; 
            else
                error('No data found in dataAll')
            end
            
            dataFinalTp.angle = kin_angle;
            dataFinalTp.angleStd = kin_angleStd;
            
            dataFinalTp.angle_50 = kin_angle_50;
            dataFinalTp.angleStd_50 = kin_angleStd_50;
            
            dataFinalTp.markers = kin_markers;
            dataFinalTp.markersStd = kin_markersStd;
            
            dataFinalTp.CentreOfMass = com_info;
            
            dataFinalTp.baseSustentation = base_info;
            
            dataFinalTp.moment = kin_moment;
            dataFinalTp.momentStd = kin_momentStd;

            dataFinalTp.power = kin_power;
            dataFinalTp.powerStd = kin_powerStd;

            dataFinalTp.forceplate = dyn_forceplate;
            dataFinalTp.forceplateStd = dyn_forceplateStd;

            dataFinalTp.stamps = stamps;

            dataFinalTp.tempsCycle = tempsCycle;
            
            dataFinalTp.angleInfos.frequency = 1/(dataFinalTp.tempsCycle/100); 
            
            % Inutile maintenant, mais j'ai besoin des stamps quand même!
            dataFinalTp = computePourcentCycleMarche(dataFinalTp);

            % Rearranger les données pour extraire certains paramètres
            dataFinalTp.eventData(i) = rearangeIntoEvents(dataFinalTp, ...
                    {'Left_Foot_Off' 'Right_Foot_Off' 'Left_Foot_Strike' 'Right_Foot_Strike'}, ...
                    {'LHipAngles' 'RHipAngles' 'LKneeAngles' 'RKneeAngles' 'LAnkleAngles' 'RAnkleAngles'});
        else
            dataFinalTp.info = [];
            dataFinalTp.angleInfos = [];
            dataFinalTp.angle = [];
            dataFinalTp.angle_50 = [];
            dataFinalTp.markers = [];
            dataFinalTp.CentreOfMass = [];
            dataFinalTp.moment = [];
            dataFinalTp.power = [];
            dataFinalTp.forceplate = [];
            dataFinalTp.stamps = [];
            dataFinalTp.tempsCycle = [];
        end
        dataFinal.(s) = dataFinalTp;
        clear dataFinalTp
    end
end
