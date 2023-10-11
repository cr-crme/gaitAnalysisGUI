% Ce script demande un fichier c3d et l'analyse.
% En sortie, il y a un fichier excel dans le format demandé par le projet

% Normal header
clc
clear
close all
addpath('Libs');
addpath(genpath('functions'));
feature('DefaultCharacterSet','UTF8');

%%%%%% OPTIONS %%%%%
useEMG = false; % true; % 
%%%%%%%%%%%%%%%%%%%%


%%%%%% PRÉPARATION %%%%%%
% Load de la librairie pour la lecture des c3d
loadEzc3d();
c.debug = true;
%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% OUVRIR ET BASIC EXTRACTION %%%%%%
% Demander quels fichiers traiter
c = getFile(c);
if isempty(c)
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%% Différents calculs pour les essais %%%%%%
    % EEI
    c.results = eeiComputations(c.eei);
   
    % Évéments spatio-temporels
    c.results = spatiotempComputations(c.data, c.results);
    
    % Classage et calculs de paramètres cinématiques
    c.results = kinematicsComputations(c.data, c.results);
    
    % Extraction et calculs sur la cinétique
    c.results = kineticsComputations(c.data, c.results);
    
    % Copy struct si un côté est inexistant
    c.results = createEmptyIfNecessary(c.results);
    
    % Faire la moyenne gauche et droite sur toutes les valeurs
    c.results.MeanLeg = meanLegs(c.results.Left, c.results.Right);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% Différents calculs par essai %%%%%%
    sides = fieldnames(c.dataAll);
    for iS = 1:length(sides)
        s = sides{iS};
        types = fieldnames(c.dataAll.(s));
        for iT = 1:length(types)
            t = types{iT};

            for i = 1:length(c.dataAll.(s).(t))
                % Évéments spatio-temporels
                resultTP.(s) = spatiotempComputations(c.dataAll.(s).(t)(i)).(s);

                % Classage et calculs de paramètres cinématiques
                resultTP.(s) = kinematicsComputations(c.dataAll.(s).(t)(i), resultTP).(s);

                % Extraction et calculs sur la cinétique
                resultTP.(s) = kineticsComputations(c.dataAll.(s).(t)(i), resultTP).(s);

                % Copy struct si un côté est inexistant
                resultTP.(s) = createEmptyIfNecessary(resultTP).(s);

                % Exporter le résultat
                c.resultsAll.(t).(s)(i) = resultTP.(s);
                clear resultTP
            end
        end
    end
    clear sides s iS types t iT i    
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%%%%%% Différents calculs pour l'essai statique %%%%%%
    % Évéments spatio-temporels
    if ~isempty(c.staticfile)
        c.staticfile.results = spatiotempComputations(c.staticfile.data);

        % Classage et calculs de paramètres cinématiques
        c.staticfile.results = kinematicsComputations(c.staticfile.data, c.staticfile.results);

        % Extraction et calculs sur la cinétique
        c.staticfile.results = kineticsComputations(c.staticfile.data, c.staticfile.results);

        % Copy struct si un côté est inexistant
        c.staticfile.results = createEmptyIfNecessary(c.staticfile.results);

        % Faire la moyenne gauche et droite sur toutes les valeurs
        c.staticfile.results.MeanLeg = meanLegs(c.staticfile.results.Left, c.staticfile.results.Right);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%EMG%%
if useEMG
    c.EMG = extractmultipleEMG(c.c3d);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% EXPORTER LES DONNÉES %%%%%%
% Enregistrer les données
save(['result/matfiles/' c.info.name], 'c');
% Écrire dans le fichier excel ce qui a été fait
writeExcelMean(c);
writeExcelEachTrial(c);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




