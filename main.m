% Ce script demande un fichier c3d et l'analyse.
% En sortie, il y a un fichier excel dans le format demandé par le projet

% Normal header
clc
clear
close all
addpath('Libs');
addpath(genpath('functions'));
feature('DefaultCharacterSet','UTF8');


%%%%%% PRÉPARATION %%%%%%
% Load de la librairie BTK pour 
loadBtk();
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

%%%%%% Différents calculs pour l'essai statique %%%%%%
    % Évéments spatio-temporels
    c.staticfile.results = spatiotempComputations(c.staticfile.data);
    
    % Classage et calculs de paramètres cinématiques
    c.staticfile.results = kinematicsComputations(c.staticfile.data, c.staticfile.results);
    
    % Extraction et calculs sur la cinétique
    c.staticfile.results = kineticsComputations(c.staticfile.data, c.staticfile.results);
    
    % Copy struct si un côté est inexistant
    c.staticfile.results = createEmptyIfNecessary(c.staticfile.results);
    
    % Faire la moyenne gauche et droite sur toutes les valeurs
    c.staticfile.results.MeanLeg = meanLegs(c.staticfile.results.Left, c.staticfile.results.Right);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%% EXPORTER LES DONNÉES %%%%%%
% Enregistrer les données
save(['result/matfiles/' c.info.name], 'c');
% Écrire dans le fichier excel ce qui a été fait
writeExcel(c);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




