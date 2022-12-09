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
%    c.file.path = 'data/';
%    c.file.names = {'DMC_BD_011_6mwe_min01.c3d' 'DMC_BD_011_6mwe_min06.c3d'};
%    c.file.savepath = 'result/coucou.csv';
%    c.staticfile.names = [];
%    c.staticfile.path = '';
%    c.eei.fc_repos = 80.4;
%    c.eei.fc_marche = 172.52;
%    c.eei.v_marche = 37.58;
%    c.selectAllCycle = 1;
    
    % S'assurer qu'on veut analyser quelque chose
    if isempty(c)
        return;
    end
    
    if ~exist('result/matfiles', 'dir')
        mkdir('result/matfiles')
    end
    
    % Ouvrir et découper les données
    [dataAll, c.file, c.c3d] = openAndParseC3Ds(c.file, c.selectAllCycle);
    [dataStatic, c.staticfile, c3dStatic] = openAndParseC3Ds(c.staticfile, false);
    ToKeep.kinToKeep.Left = 1:length(dataStatic.Left);
    ToKeep.kinToKeep.Right = 1:length(dataStatic.Right);
    ToKeep.dynToKeep.Left = 1;
    ToKeep.dynToKeep.Right = 1;
    if ~isempty(c3dStatic)
        c.staticfile.data = meanAllResults(dataStatic, ToKeep.kinToKeep, ToKeep.dynToKeep, c.info);
        c.staticfile.c3d = c3dStatic;
    end
    
    % Faire choisir à l'utilisateur les essais à conserver
    [ToKeep.kinToKeep, ToKeep.dynToKeep] = selectFilesToUse(dataAll);
%     ToKeep.kinToKeep.Left = [1 2 7 8];
%     ToKeep.kinToKeep.Right = [1];
%     ToKeep.dynToKeep.Left = [1 7];
%     ToKeep.dynToKeep.Right = [1 ]; %#ok<NBRAK>
    
    
    % Élager les données selon ce qui a été choisi
    dataFinal = meanAllResults(dataAll, ToKeep.kinToKeep, ToKeep.dynToKeep, c.info);
    
    % Mettre les données dans la variable de sortie
    c.data = dataFinal;
    
    % Sauvegarder toutes les données pour stats
    types = fieldnames(ToKeep);
    for iT = 1:length(types)
        sides = fieldnames(ToKeep.(types{iT}));
        for iS = 1:length(sides)
            emptyStruct.(types{iT}).(sides{iS}) = [];
        end
    end
    
    names = {'kin', 'dyn'};
%     c.dataAll.Left.kin = []; createEmptyStructFromStruct(dataFinal);
%     c.dataAll.Right.kin = createEmptyStructFromStruct(dataFinal);
%     c.dataAll.Left.dyn = createEmptyStructFromStruct(dataFinal);
%     c.dataAll.Right.dyn = createEmptyStructFromStruct(dataFinal);
    for iT = 1:length(types)
        for iS = 1:length(sides)
            first = true;
            for j = 1:length(ToKeep.(types{iT}).(sides{iS}))
                tpStruct = emptyStruct; % Mettre les deux structures à vide
                tpStruct.(types{iT}).(sides{iS}) = ToKeep.(types{iT}).(sides{iS})(j);
                if first
                    c.dataAll.(sides{iS}).(names{iT}) = meanAllResults(dataAll, tpStruct.kinToKeep, tpStruct.dynToKeep, c.info);
                    first = false;
                else
                    c.dataAll.(sides{iS}).(names{iT})(end+1) = meanAllResults(dataAll, tpStruct.kinToKeep, tpStruct.dynToKeep, c.info);
                end
            end
        end
    end

end

function newStruct = createEmptyStructFromStruct(originStruct)
    fields = fieldnames(originStruct);
    for i = 1:length(fields)
        field = fields{i};
        if isstruct(originStruct(1).(field))
            newStruct.(field) = createEmptyStructFromStruct(originStruct(1).(field));
        else
            newStruct.(field) = [];
        end
    end
end

function [dataAll, file, c3d] = openAndParseC3Ds(file, selectAllCycle)
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
        c3d(i) = c3dRead(file.fullpath{i}); %#ok<AGROW>
        
        try
            data = extractDataFromC3D(c3d(i), selectAllCycle);
        catch me
            message = sprintf('Le fichier %s a retourné l''erreur suivante : \n %s\nDans la fonction %s\n%s, ligne %d', file.names{i}, me.message, me.stack(1).name, me.stack(1).file, me.stack(1).line);
            uiwait(errordlg(message));
            error(message); %#ok<SPERR>
        end
            
            
        % Reclasser les données (faire qu'un essai soit un "fichier")
        for j = 1:length(data.norm.Left)
            data.norm.Left(j).filename = sprintf('%s_CôtéGauche_%d', file.names{i}, j);
            % Calcul spécial pour le centre de masse, calculer tout de suite le médiolatéral 
            data.norm.Left(j).CentreOfMass.ml = abs(max(data.norm.Left(j).markers.CentreOfMassInRef(:,1)) - min(data.norm.Left(j).markers.CentreOfMassInRef(:,1)));

            BS_Left_Foot_0_OppPushOff = abs(data.norm.Left(j).markers.LTOEInRef(data.norm.Left(j).stamps.Left_Foot_0_OppPushOff.frameStamps{:},1) - data.norm.Left(j).markers.RTOEInRef(data.norm.Left(j).stamps.Left_Foot_0_OppPushOff.frameStamps{:},1));
            data.norm.Left(j).baseSustentation.maxPreMoyenne = max(BS_Left_Foot_0_OppPushOff);
            data.norm.Left(j).baseSustentation.minPreMoyenne = min(BS_Left_Foot_0_OppPushOff);
            
            dataAll.Left(cmpLeft) = data.norm.Left(j); 
            cmpLeft = cmpLeft+1;
        end
        for j = 1:length(data.norm.Right)
            data.norm.Right(j).filename = sprintf('%s_CôtéDroit_%d', file.names{i}, j);
            % Calcul spécial pour le centre de masse, calculer tout de suite le médiolatéral 
            data.norm.Right(j).CentreOfMass.ml = abs(max(data.norm.Right(j).markers.CentreOfMassInRef(:,1)) - min(data.norm.Right(j).markers.CentreOfMassInRef(:,1)));
            
            BS_Right_Foot_0_OppPushOff = abs(data.norm.Right(j).markers.RTOEInRef(data.norm.Right(j).stamps.Right_Foot_0_OppPushOff.frameStamps{:},1) - data.norm.Right(j).markers.LTOEInRef(data.norm.Right(j).stamps.Right_Foot_0_OppPushOff.frameStamps{:},1));
            data.norm.Right(j).baseSustentation.maxPreMoyenne = max(BS_Right_Foot_0_OppPushOff);
            data.norm.Right(j).baseSustentation.minPreMoyenne = min(BS_Right_Foot_0_OppPushOff);
            
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
