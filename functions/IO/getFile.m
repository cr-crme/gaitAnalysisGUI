function [ c ] = getFile( c )
%GETFILE Summary of this function goes here
%   Detailed explanation goes here
    c = getFileGUI(c);
%     c.info.name = 'Tata';
%     c.info.height = 168    ;
%     c.info.mass = 50.1;
%     c.info.age = 11.5;
%     c.info.sexe = 0;
%     c.info.aide = 2;
%     c.info.aideStr = 'Canne (2)';
%     c.info.note = 'Yo!';
%     c.file.path = 'data/Pariterre/';
%     c.file.names = {'Steinert_BD01_Session1_6mwe_01.c3d'};
%     c.file.savepath = 'result/coucou.csv';
%     c.staticfile.names = {};
%     c.staticfile.path = 'data/';
%     c.eei.fc_repos = 80.4;
%     c.eei.fc_marche = 172.52;
%     c.eei.v_marche = 37.58;
%     c.selectAllCycle = 1;
%     c.automaticRemove = 1;
    
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
    [ToKeep.kinToKeep, ToKeep.dynToKeep] = selectFilesToUse(dataAll, c.automaticRemove);
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


    if ~isfield(c, 'dataAll')
        error('Aucune donnée conservée dans les essais');
    elseif ~isfield(c.dataAll, 'Right')
        c.dataAll.Right = [];
        c.dataAll.Right.kin = [];
    elseif ~isfield(c.dataAll, 'Left')
        c.dataAll.Left = [];
        c.dataAll.Left.kin = [];
    end

    
end

