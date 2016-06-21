function [ c ] = getFile( c )
%GETFILE Summary of this function goes here
%   Detailed explanation goes here
     c = getFileGUI(c);
%    c.info.name = 'Benjamin';
%    c.info.height = 1756;
%    c.info.mass = 50.1;
%    c.info.age = 11.5;
%    c.info.sexe = 0;
%    c.info.aide = 2;
%    c.info.aideStr = 'Canne (2)';
%    c.info.note = 'Yo!';
%    c.file.path = 'data/Bogue/';
%    c.file.names = {'DMC_BD_11_marche10.c3d' };% 'DMC_BD_09_marche05.c3d' 'DMC_BD_09_marche08.c3d'  'DMC_BD_09_marche14.c3d'};
%    c.file.savepath = 'result/coucou.csv';
%    c.staticfile.names = {'DMC_BD_53_Statique.c3d'};
%    c.staticfile.path = 'data/Bogue/';
%    c.eei.fc_repos = 80.4;
%    c.eei.fc_marche = 172.52;
%    c.eei.v_marche = 37.58;
    
    % S'assurer qu'on veut analyser quelque chose
    if isempty(c)
        return;
    end
    
    if ~exist('result/matfiles', 'dir')
        mkdir('result/matfiles')
    end
    
    % Ouvrir et découper les données
    [dataAll, c.file, c.c3d] = openAndParseC3Ds(c.file);
    [dataStatic, c.staticfile, c3dStatic] = openAndParseC3Ds(c.staticfile);
    kinToKeep.Left = 1:length(dataStatic.Left);
    kinToKeep.Right = 1:length(dataStatic.Right);
    dynToKeep.Left = 1;
    dynToKeep.Right = 1;
    if ~isempty(c3dStatic)
        c.staticfile.data = meanAllResults(dataStatic, kinToKeep, dynToKeep, c.info);
        c.staticfile.c3d = c3dStatic;
    end
    
    % Faire choisir à l'utilisateur les essais à conserver
    [kinToKeep, dynToKeep] = selectFilesToUse(dataAll);
%     kinToKeep.Left = [1 2 7 8];
%     kinToKeep.Right = [1];
%     dynToKeep.Left = [1 7];
%     dynToKeep.Right = [1 ]; %#ok<NBRAK>
    
    
    % Élager les données selon ce qui a été choisi
    dataFinal = meanAllResults(dataAll, kinToKeep, dynToKeep, c.info);
    
    % Mettre les données dans la variable de sortie
    c.data = dataFinal;
end

function dataFinal = meanAllResults(dataAll, kinToKeep, dynToKeep, info)

    sides = fieldnames(kinToKeep);
    for iS = 1:length(sides)
        s = sides{iS};
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

            kin_angle = [];
            for j = 1:length(angle_fnames)
                for i = 1:length(dataKinAll)
                    kin_angle.(angle_fnames{j})(:,:,i) = dataKinAll(i).angle.(angle_fnames{j});
                end
                kin_angleStd.(angle_fnames{j}) = std(kin_angle.(angle_fnames{j}),[],3);
                kin_angle.(angle_fnames{j}) = mean(kin_angle.(angle_fnames{j}),3);
            end
            kin_angle_50 = [];
            for j = 1:length(angle_fnames_50)
                for i = 1:length(dataKinAll)
                    kin_angle_50.(angle_fnames_50{j})(:,:,i) = dataKinAll(i).angle_50.(angle_fnames_50{j});
                end
                kin_angleStd_50.(angle_fnames_50{j}) = std(kin_angle_50.(angle_fnames_50{j}),[],3);
                kin_angle_50.(angle_fnames_50{j}) = mean(kin_angle_50.(angle_fnames_50{j}),3);
            end

            kin_markers = [];
            for j = 1:length(marker_fnames)
                if length(marker_fnames{j}) > 2 && strcmp(marker_fnames{j}(1:2), 'C_')
                    continue;
                end
                for i = 1:length(dataKinAll)
                    if strcmp(s, 'Left')
                        zeroPosition = dataKinAll(i).markers.LHEE;
                    elseif strcmp(s, 'Right')
                        zeroPosition = dataKinAll(i).markers.RHEE;
                    else
                        error('Côté erronné')
                    end
                    if zeroPosition(end,2) - zeroPosition(1,2) < 0
                        zeroPosition(:,[1 2]) = -zeroPosition(:,[1 2]);
                    end
                    zeroPosition = [repmat([min(zeroPosition(:,1)), zeroPosition(1,2)], [size(zeroPosition,1), 1]), zeros(size(zeroPosition(:,3)))];
                    d = dataKinAll(i).markers.(marker_fnames{j});
                    % S'assurer que la marche est vers l'avant (tourne autour de z)
                    if d(end,2) - d(1,2) < 0
                        d(:,[1 2]) = -d(:,[1 2]);
                    end
                    % Partir en fct de l'extrême min pour lat,  0 pour frontal et ne rien changer en hauteur 
                    kin_markers.(marker_fnames{j})(:,:,i) = d - zeroPosition; 
                
                end
                kin_markersStd.(marker_fnames{j}) = std(kin_markers.(marker_fnames{j}),[],3);
                kin_markers.(marker_fnames{j}) = mean(kin_markers.(marker_fnames{j}),3);
            end

            com_info = [];
            for j = 1:length(CentreOfMass)
                for i = 1:length(dataKinAll)
                    com_info.(CentreOfMass{j})(:,:,i) = dataKinAll(i).CentreOfMass.(CentreOfMass{j});
                end
                com_info.(CentreOfMass{j}) = mean(com_info.(CentreOfMass{j}),3);
            end

            kin_moment = [];
            for j = 1:length(moment_fnames)
                kin_moment.(moment_fnames{j}) = [];
                for i = 1:length(dataDynAll)
                    kin_moment.(moment_fnames{j})(:,:,i) = dataDynAll(i).moment.(moment_fnames{j});
                end
                if ~isempty(kin_moment.(moment_fnames{j}))
                    kin_momentStd.(moment_fnames{j}) = std(kin_moment.(moment_fnames{j}), [], 3);
                    kin_moment.(moment_fnames{j}) = mean(kin_moment.(moment_fnames{j}), 3);
                else
                    kin_momentStd.(moment_fnames{j}) = [];
                    kin_moment.(moment_fnames{j}) = [];
                end
            end

            kin_power = [];
            for j = 1:length(power_fnames)
                kin_power.(power_fnames{j}) = [];
                for i = 1:length(dataDynAll)
                    kin_power.(power_fnames{j})(:,:,i) = dataDynAll(i).power.(power_fnames{j});
                end
                if ~isempty(kin_power.(power_fnames{j}))
                    kin_powerStd.(power_fnames{j}) = std(kin_power.(power_fnames{j}),[],3);
                    kin_power.(power_fnames{j}) = mean(kin_power.(power_fnames{j}),3);
                else
                    kin_powerStd.(power_fnames{j}) = [];
                    kin_power.(power_fnames{j}) = [];
                end
            end

            dyn_forceplate = [];
            if ~isempty(dataDynAll)
                for pf = 1:length(dataAll.(s)(1).forceplate)
                    fp_fnames = {'Fx' 'Fy' 'Fz' 'Mx' 'My' 'Mz'};
                    for j = 1:length(fp_fnames)
                        for i = 1:length(dataDynAll)
                            comp_names = fieldnames(dataDynAll(i).forceplate(pf).channels);
                            if ~isempty(dataDynAll(i).forceplate(pf).channels.(comp_names{j}))
                                dyn_forceplate(pf).channels.(fp_fnames{j})(:,:,i) = dataDynAll(i).forceplate(pf).channels.(comp_names{j}); %#ok<AGROW>
                            end
                        end
                        if ~isempty(dyn_forceplate)
                            dyn_forceplateStd(pf).channels.(fp_fnames{j}) = std(dyn_forceplate(pf).channels.(fp_fnames{j}),[],3); %#ok<AGROW>
                            dyn_forceplate(pf).channels.(fp_fnames{j}) = mean(dyn_forceplate(pf).channels.(fp_fnames{j}),3); %#ok<AGROW>
                        end
                    end
                end
            end
            if isempty(dyn_forceplate)
                fp_fnames = {'Fx' 'Fy' 'Fz' 'Mx' 'My' 'Mz'};
                for j = 1:length(fp_fnames)
                    dyn_forceplate.channels.(fp_fnames{j}) = nan(100,1); 
                    dyn_forceplateStd.channels.(fp_fnames{j}) = nan(100,1);
                end
            end

            stamps = [];
            stampsToDo = {'Left_Foot_Off', setdiff( {'Left_Foot_Strike', 'Right_Foot_Strike'}, [s '_Foot_Strike']), 'Right_Foot_Off'};
            stampsToDo(2) = stampsToDo{2};
            for j=1:length(stampsToDo)
                for i = 1:length(dataKinAll)
                    stamps.(stampsToDo{j}).frameStamp(i) = dataKinAll(i).stamps.(stampsToDo{j}).frameStamp;
                end
                stamps.(stampsToDo{j}).frameStamp = round(mean(stamps.(stampsToDo{j}).frameStamp));
            end
            tempsCycle = mean([dataKinAll(:).tempsCycle]);

            % Le cas de Left_Foot_Strike est spécial car 2 valeurs (1 et 100)
            stamps.([s '_Foot_Strike']).frameStamp = [1 100]; 
            stamps = extractStamps(stamps, 100);

            % Assembler les données moyennées
            dataFinalTp.info = info; % Prendre les infos demandé à l'ouverture
            dataFinalTp.angleInfos = dataAll.Left(1).angleInfos; 
            dataFinalTp.angle = kin_angle;
            dataFinalTp.angle_50 = kin_angle_50;
            dataFinalTp.angleStd = kin_angleStd;
            dataFinalTp.angleStd_50 = kin_angleStd_50;
            dataFinalTp.markers = kin_markers;
            dataFinalTp.markersStd = kin_markersStd;
            dataFinalTp.CentreOfMass = com_info;
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

function [dataAll, file, c3d] = openAndParseC3Ds(file)
    if isempty(file.names)
        dataAll.Left = [];
        dataAll.Right = [];
        file = []; 
        c3d = [];
        return;
    end

% Parse and open
    cmpLeft = 1;
    cmpRight = 1;
    for i=1:length(file.names)
        [~,file.names{i},file.ext{i}] = fileparts(file.names{i});
        file.fullpath{i} = [file.path file.names{i} file.ext{i}];
        
        % Ouvrir un fichier BTK
        c3d(i) = btkReadAcquisition(file.fullpath{i}); %#ok<AGROW>
        
        try
            data = extractDataFromC3D(c3d(i));
        catch me
            uiwait(errordlg(sprintf('Le fichier %s a retourné l''erreur suivante : \n %s', file.names{i}, me.message)));
            error('Le fichier %s a retourné l''erreur suivante : \n %s', file.names{i}, me.message);       
        end
            
            
        % Reclasser les données (faire qu'un essai soit un "fichier")
        for j = 1:length(data.norm.Left)
            data.norm.Left(j).filename = sprintf('%s_CôtéGauche_%d', file.names{i}, j);
            % Calcul spécial pour le centre de masse, calculer tout de suite le médiolatéral 
            data.norm.Left(j).CentreOfMass.ml = abs(max(data.norm.Left(j).markers.CentreOfMass(:,1)) - min(data.norm.Left(j).markers.CentreOfMass(:,1)));

            dataAll.Left(cmpLeft) = data.norm.Left(j); 
            cmpLeft = cmpLeft+1;
        end
        for j = 1:length(data.norm.Right)
            data.norm.Right(j).filename = sprintf('%s_CôtéDroit_%d', file.names{i}, j);
            % Calcul spécial pour le centre de masse, calculer tout de suite le médiolatéral 
            data.norm.Right(j).CentreOfMass.ml = abs(max(data.norm.Right(j).markers.CentreOfMass(:,1)) - min(data.norm.Right(j).markers.CentreOfMass(:,1)));
            dataAll.Right(cmpRight) = data.norm.Right(j); 
            
            cmpRight = cmpRight+1;
        end
    end
    % Prendre les infos du derniers (ils sont sensés être tous les mêmes)
    dataAll.Left(1).angleInfos = data.angleInfos;
    dataAll.Left(1).angleInfos.frequency = 1/(dataAll.Left(1).tempsCycle/100);
    
    dataAll.Right(1).angleInfos = data.angleInfos;
    dataAll.Right(1).angleInfos.frequency = 1/(dataAll.Right(1).tempsCycle/100);
end
