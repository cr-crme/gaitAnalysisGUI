function writeExcel(c)

    % Informations générique sur le fichier à produire
    filepath = c.file.savepath;
    sep = ',';
    
    % Si on démarre un nouveau fichier, il faut écrire l'entete
    if ~exist(filepath, 'file')
        header = {  'Info'  'Notes'                             ''
                    'Info'  'Numéro sujet'                      ''
                    'Info'  'Initiales'                         ''
                    'Info'  'Aide technique (durant marche)'    ''
                    'Info'  'Aide technique'                    ''
                    'Info'  'Age (année)'                       ''
                    'Info'  'Genre (0-garçon 1-fille)'         ''
                    'Info'  'Masse (kg)'                        ''
                    'Info'  'Taille (cm)'                       ''
                    % Moment à l'attaque
%                     'Force attaque' 'Hanche_Extension (N)'      'DG'
%                     'Force attaque' 'Hanche_Extension (N)'      'D'
%                     'Force attaque' 'Hanche_Extension (N)'      'G'
%                     'Force attaque' 'Hanche_Flexion (N)'        'DG'
%                     'Force attaque' 'Hanche_Flexion (N)'        'D'
%                     'Force attaque' 'Hanche_Flexion (N)'        'G'
%                     'Force attaque' 'Hanche_Abduction (N)'      'DG'
%                     'Force attaque' 'Hanche_Abduction (N)'      'D'
%                     'Force attaque' 'Hanche_Abduction (N)'      'G'
%                     'Force attaque' 'Genou_Extension (N)'       'DG'
%                     'Force attaque' 'Genou_Extension (N)'       'D'
%                     'Force attaque' 'Genou_Extension (N)'       'G'
%                     'Force attaque' 'Genou_Flexion (N)'         'DG'
%                     'Force attaque' 'Genou_Flexion (N)'         'D'
%                     'Force attaque' 'Genou_Flexion (N)'         'G'
%                     % Moment à la poussée
%                     'Force poussée' 'Hanche_Extension (N)'      'DG'
%                     'Force poussée' 'Hanche_Extension (N)'      'D'
%                     'Force poussée' 'Hanche_Extension (N)'      'G'
%                     'Force poussée' 'Hanche_Flexion (N)'        'DG'
%                     'Force poussée' 'Hanche_Flexion (N)'        'D'
%                     'Force poussée' 'Hanche_Flexion (N)'        'G'
%                     'Force poussée' 'Hanche_Abduction (N)'      'DG'
%                     'Force poussée' 'Hanche_Abduction (N)'      'D'
%                     'Force poussée' 'Hanche_Abduction (N)'      'G'
%                     'Force poussée' 'Genou_Extension (N)'       'DG'
%                     'Force poussée' 'Genou_Extension (N)'       'D'
%                     'Force poussée' 'Genou_Extension (N)'       'G'
%                     'Force poussée' 'Genou_Flexion (N)'         'DG'
%                     'Force poussée' 'Genou_Flexion (N)'         'D'
%                     'Force poussée' 'Genou_Flexion (N)'         'G'
                    % Force musculaire isom�trique
                    'ForceIsometrique'  'Genou_Ext'       'DG'
                    'ForceIsometrique'  'Genou_Ext'       'D'
                    'ForceIsometrique'  'Genou_Ext'       'G'
                    'ForceIsometrique'  'Genou_Flex'      'DG'
                    'ForceIsometrique'  'Genou_Flex'      'D'
                    'ForceIsometrique'  'Genou_Flex'      'G'
                    'ForceIsometrique'  'Hanche_Ext'      'DG'
                    'ForceIsometrique'  'Hanche_Ext'      'D'
                    'ForceIsometrique'  'Hanche_Ext'      'G'
                    'ForceIsometrique'  'Hanche_Flex'     'DG'
                    'ForceIsometrique'  'Hanche_Flex'     'D'
                    'ForceIsometrique'  'Hanche_Flex'     'G'
                    'ForceIsometrique'  'Hanche_Abd'      'DG'
                    'ForceIsometrique'  'Hanche_Abd'      'D'
                    'ForceIsometrique'  'Hanche_Abd'      'G'
                    % EEI
                    'EEI'   'FC_Repos'                          ''
                    'EEI'   'FC_Marche'                         ''
                    'EEI'   'Vmarche (m/min)'                   ''
                    'EEI'   'EEI (batt/min)'                    ''
                    % GDI
                    'GDI'   'GDI'                               'DG'
                    'GDI'   'GDI'                               'D'
                    'GDI'   'GDI'                               'G'
                    % Param spatio-tempo
                    '% de cycle' 'Décollement (%)'             'DG'
                    '% de cycle' 'Décollement (%)'             'D'
                    '% de cycle' 'Décollement (%)'             'G'
                    '% de cycle' 'Contact talon pied opposé (%)' 'DG'
                    '% de cycle' 'Contact talon pied opposé (%)' 'D'
                    '% de cycle' 'Contact talon pied opposé (%)' 'G'
                    '% de cycle' 'Décollement pied opposé (%)' 'DG'
                    '% de cycle' 'Décollement pied opposé (%)' 'D'
                    '% de cycle' 'Décollement pied opposé (%)' 'G'
                    '% de cycle' 'Temps simple appuie (%)'     'DG'
                    '% de cycle' 'Temps simple appuie (%)'     'D'
                    '% de cycle' 'Temps simple appuie (%)'     'G'
                    'Param spatio-temporel' 'Longueur pas (m)'  'DG'
                    'Param spatio-temporel' 'Longueur pas (m)'  'D'
                    'Param spatio-temporel' 'Longueur pas (m)'  'G'
                    'Param spatio-temporel' 'Longueur cycle (m)' 'DG'
                    'Param spatio-temporel' 'Longueur cycle (m)' 'D'
                    'Param spatio-temporel' 'Longueur cycle (m)' 'G'
                    'Param spatio-temporel' 'Durée cycle (s)'   'DG'
                    'Param spatio-temporel' 'Durée cycle (s)'   'D'
                    'Param spatio-temporel' 'Durée cycle (s)'   'G'
                    'Param spatio-temporel' 'Vitesse cycle (m/s)' 'DG'
                    'Param spatio-temporel' 'Vitesse cycle (m/s)' 'D'
                    'Param spatio-temporel' 'Vitesse cycle (m/s)' 'G'
                    % Cinématique au contact initial en sagittal
                    'Cinématique', 'Tronc contact init sagittal (°)' 'DG'
                    'Cinématique', 'Tronc contact init sagittal (°)' 'D'
                    'Cinématique', 'Tronc contact init sagittal (°)' 'G'
                    'Cinématique', 'Bassin contact init sagittal (°)' 'DG'
                    'Cinématique', 'Bassin contact init sagittal (°)' 'D'
                    'Cinématique', 'Bassin contact init sagittal (°)' 'G'
                    'Cinématique', 'Genou contact init sagittal (°)' 'DG'
                    'Cinématique', 'Genou contact init sagittal (°)' 'D'
                    'Cinématique', 'Genou contact init sagittal (°)' 'G'
                    'Cinématique', 'Chevile contact init sagittal (°)' 'DG'
                    'Cinématique', 'Chevile contact init sagittal (°)' 'D'
                    'Cinématique', 'Chevile contact init sagittal (°)' 'G'
                    'Cinématique', 'Foot progress contact init sagittal (°)' 'DG'
                    'Cinématique', 'Foot progress contact init sagittal (°)' 'D'
                    'Cinématique', 'Foot progress contact init sagittal (°)' 'G'
                    % Cinématique au contact initial en frontal
                    'Cinématique', 'Tronc contact init frontal (°)' 'DG'
                    'Cinématique', 'Tronc contact init frontal (°)' 'D'
                    'Cinématique', 'Tronc contact init frontal (°)' 'G'
                    'Cinématique', 'Bassin contact init frontal (°)' 'DG'
                    'Cinématique', 'Bassin contact init frontal (°)' 'D'
                    'Cinématique', 'Bassin contact init frontal (°)' 'G'
                    'Cinématique', 'Genou contact init frontal (°)' 'DG'
                    'Cinématique', 'Genou contact init frontal (°)' 'D'
                    'Cinématique', 'Genou contact init frontal (°)' 'G'
                    'Cinématique', 'Chevile contact init frontal (°)' 'DG'
                    'Cinématique', 'Chevile contact init frontal (°)' 'D'
                    'Cinématique', 'Chevile contact init frontal (°)' 'G'
                    'Cinématique', 'Foot progress contact init frontal (°)' 'DG'
                    'Cinématique', 'Foot progress contact init frontal (°)' 'D'
                    'Cinématique', 'Foot progress contact init frontal (°)' 'G'
                    % Cinématique au contact initial en transverse
                    'Cinématique', 'Tronc contact init transverse (°)' 'DG'
                    'Cinématique', 'Tronc contact init transverse (°)' 'D'
                    'Cinématique', 'Tronc contact init transverse (°)' 'G'
                    'Cinématique', 'Bassin contact init transverse (°)' 'DG'
                    'Cinématique', 'Bassin contact init transverse (°)' 'D'
                    'Cinématique', 'Bassin contact init transverse (°)' 'G'
                    'Cinématique', 'Genou contact init transverse (°)' 'DG'
                    'Cinématique', 'Genou contact init transverse (°)' 'D'
                    'Cinématique', 'Genou contact init transverse (°)' 'G'
                    'Cinématique', 'Chevile contact init transverse (°)' 'DG'
                    'Cinématique', 'Chevile contact init transverse (°)' 'D'
                    'Cinématique', 'Chevile contact init transverse (°)' 'G'
                    'Cinématique', 'Foot progress contact init transverse (°)' 'DG'
                    'Cinématique', 'Foot progress contact init transverse (°)' 'D'
                    'Cinématique', 'Foot progress contact init transverse (°)' 'G'
                    
                    % Cinématique au pushoff en sagittal
                    'Cinématique', 'Tronc poussée sagittal (°)' 'DG'
                    'Cinématique', 'Tronc poussée sagittal (°)' 'D'
                    'Cinématique', 'Tronc poussée sagittal (°)' 'G'
                    'Cinématique', 'Bassin poussée sagittal (°)' 'DG'
                    'Cinématique', 'Bassin poussée sagittal (°)' 'D'
                    'Cinématique', 'Bassin poussée sagittal (°)' 'G'
                    'Cinématique', 'Genou poussée sagittal (°)' 'DG'
                    'Cinématique', 'Genou poussée sagittal (°)' 'D'
                    'Cinématique', 'Genou poussée sagittal (°)' 'G'
                    'Cinématique', 'Chevile poussée sagittal (°)' 'DG'
                    'Cinématique', 'Chevile poussée sagittal (°)' 'D'
                    'Cinématique', 'Chevile poussée sagittal (°)' 'G'
                    'Cinématique', 'Foot progress poussée sagittal (°)' 'DG'
                    'Cinématique', 'Foot progress poussée sagittal (°)' 'D'
                    'Cinématique', 'Foot progress poussée sagittal (°)' 'G'
                    % Cinématique au poussée en frontal
                    'Cinématique', 'Tronc poussée frontal (°)' 'DG'
                    'Cinématique', 'Tronc poussée frontal (°)' 'D'
                    'Cinématique', 'Tronc poussée frontal (°)' 'G'
                    'Cinématique', 'Bassin poussée frontal (°)' 'DG'
                    'Cinématique', 'Bassin poussée frontal (°)' 'D'
                    'Cinématique', 'Bassin poussée frontal (°)' 'G'
                    'Cinématique', 'Genou poussée frontal (°)' 'DG'
                    'Cinématique', 'Genou poussée frontal (°)' 'D'
                    'Cinématique', 'Genou poussée frontal (°)' 'G'
                    'Cinématique', 'Chevile poussée frontal (°)' 'DG'
                    'Cinématique', 'Chevile poussée frontal (°)' 'D'
                    'Cinématique', 'Chevile poussée frontal (°)' 'G'
                    'Cinématique', 'Foot progress poussée frontal (°)' 'DG'
                    'Cinématique', 'Foot progress poussée frontal (°)' 'D'
                    'Cinématique', 'Foot progress poussée frontal (°)' 'G'
                    % Cinématique au poussée en transverse
                    'Cinématique', 'Tronc poussée transverse (°)' 'DG'
                    'Cinématique', 'Tronc poussée transverse (°)' 'D'
                    'Cinématique', 'Tronc poussée transverse (°)' 'G'
                    'Cinématique', 'Bassin poussée transverse (°)' 'DG'
                    'Cinématique', 'Bassin poussée transverse (°)' 'D'
                    'Cinématique', 'Bassin poussée transverse (°)' 'G'
                    'Cinématique', 'Genou poussée transverse (°)' 'DG'
                    'Cinématique', 'Genou poussée transverse (°)' 'D'
                    'Cinématique', 'Genou poussée transverse (°)' 'G'
                    'Cinématique', 'Chevile poussée transverse (°)' 'DG'
                    'Cinématique', 'Chevile poussée transverse (°)' 'D'
                    'Cinématique', 'Chevile poussée transverse (°)' 'G'
                    'Cinématique', 'Foot progress poussée transverse (°)' 'DG'
                    'Cinématique', 'Foot progress poussée transverse (°)' 'D'
                    'Cinématique', 'Foot progress poussée transverse (°)' 'G'
                    
                    % Cinématique angle minimum durant le support
                    'Cinématique', 'Tronc min unipodal sagittal (°)' 'DG'
                    'Cinématique', 'Tronc min unipodal sagittal (°)' 'D'
                    'Cinématique', 'Tronc min unipodal sagittal (°)' 'G'
                    'Cinématique', 'Bassin min unipodal sagittal (°)' 'DG'
                    'Cinématique', 'Bassin min unipodal sagittal (°)' 'D'
                    'Cinématique', 'Bassin min unipodal sagittal (°)' 'G'
                    'Cinématique', 'Genou min unipodal sagittal (°)' 'DG'
                    'Cinématique', 'Genou min unipodal sagittal (°)' 'D'
                    'Cinématique', 'Genou min unipodal sagittal (°)' 'G'
                    'Cinématique', 'Chevile min unipodal sagittal (°)' 'DG'
                    'Cinématique', 'Chevile min unipodal sagittal (°)' 'D'
                    'Cinématique', 'Chevile min unipodal sagittal (°)' 'G'
                    'Cinématique', 'Foot progress min unipodal sagittal (°)' 'DG'
                    'Cinématique', 'Foot progress min unipodal sagittal (°)' 'D'
                    'Cinématique', 'Foot progress min unipodal sagittal (°)' 'G'
                    % Cinématique min unipodal en frontal
                    'Cinématique', 'Tronc min unipodal frontal (°)' 'DG'
                    'Cinématique', 'Tronc min unipodal frontal (°)' 'D'
                    'Cinématique', 'Tronc min unipodal frontal (°)' 'G'
                    'Cinématique', 'Bassin min unipodal frontal (°)' 'DG'
                    'Cinématique', 'Bassin min unipodal frontal (°)' 'D'
                    'Cinématique', 'Bassin min unipodal frontal (°)' 'G'
                    'Cinématique', 'Genou min unipodal frontal (°)' 'DG'
                    'Cinématique', 'Genou min unipodal frontal (°)' 'D'
                    'Cinématique', 'Genou min unipodal frontal (°)' 'G'
                    'Cinématique', 'Chevile min unipodal frontal (°)' 'DG'
                    'Cinématique', 'Chevile min unipodal frontal (°)' 'D'
                    'Cinématique', 'Chevile min unipodal frontal (°)' 'G'
                    'Cinématique', 'Foot progress min unipodal frontal (°)' 'DG'
                    'Cinématique', 'Foot progress min unipodal frontal (°)' 'D'
                    'Cinématique', 'Foot progress min unipodal frontal (°)' 'G'
                    % Cinématique min unipodal en transverse
                    'Cinématique', 'Tronc min unipodal transverse (°)' 'DG'
                    'Cinématique', 'Tronc min unipodal transverse (°)' 'D'
                    'Cinématique', 'Tronc min unipodal transverse (°)' 'G'
                    'Cinématique', 'Bassin min unipodal transverse (°)' 'DG'
                    'Cinématique', 'Bassin min unipodal transverse (°)' 'D'
                    'Cinématique', 'Bassin min unipodal transverse (°)' 'G'
                    'Cinématique', 'Genou min unipodal transverse (°)' 'DG'
                    'Cinématique', 'Genou min unipodal transverse (°)' 'D'
                    'Cinématique', 'Genou min unipodal transverse (°)' 'G'
                    'Cinématique', 'Chevile min unipodal transverse (°)' 'DG'
                    'Cinématique', 'Chevile min unipodal transverse (°)' 'D'
                    'Cinématique', 'Chevile min unipodal transverse (°)' 'G'
                    'Cinématique', 'Foot progress min unipodal transverse (°)' 'DG'
                    'Cinématique', 'Foot progress min unipodal transverse (°)' 'D'
                    'Cinématique', 'Foot progress min unipodal transverse (°)' 'G'
                    
                    % Cinématique angle maximum durant le support
                    'Cinématique', 'Tronc max unipodal sagittal (°)' 'DG'
                    'Cinématique', 'Tronc max unipodal sagittal (°)' 'D'
                    'Cinématique', 'Tronc max unipodal sagittal (°)' 'G'
                    'Cinématique', 'Bassin max unipodal sagittal (°)' 'DG'
                    'Cinématique', 'Bassin max unipodal sagittal (°)' 'D'
                    'Cinématique', 'Bassin max unipodal sagittal (°)' 'G'
                    'Cinématique', 'Genou max unipodal sagittal (°)' 'DG'
                    'Cinématique', 'Genou max unipodal sagittal (°)' 'D'
                    'Cinématique', 'Genou max unipodal sagittal (°)' 'G'
                    'Cinématique', 'Chevile max unipodal sagittal (°)' 'DG'
                    'Cinématique', 'Chevile max unipodal sagittal (°)' 'D'
                    'Cinématique', 'Chevile max unipodal sagittal (°)' 'G'
                    'Cinématique', 'Foot progress max unipodal sagittal (°)' 'DG'
                    'Cinématique', 'Foot progress max unipodal sagittal (°)' 'D'
                    'Cinématique', 'Foot progress max unipodal sagittal (°)' 'G'
                    % Cinématique max unipodal en frontal
                    'Cinématique', 'Tronc max unipodal frontal (°)' 'DG'
                    'Cinématique', 'Tronc max unipodal frontal (°)' 'D'
                    'Cinématique', 'Tronc max unipodal frontal (°)' 'G'
                    'Cinématique', 'Bassin max unipodal frontal (°)' 'DG'
                    'Cinématique', 'Bassin max unipodal frontal (°)' 'D'
                    'Cinématique', 'Bassin max unipodal frontal (°)' 'G'
                    'Cinématique', 'Genou max unipodal frontal (°)' 'DG'
                    'Cinématique', 'Genou max unipodal frontal (°)' 'D'
                    'Cinématique', 'Genou max unipodal frontal (°)' 'G'
                    'Cinématique', 'Chevile max unipodal frontal (°)' 'DG'
                    'Cinématique', 'Chevile max unipodal frontal (°)' 'D'
                    'Cinématique', 'Chevile max unipodal frontal (°)' 'G'
                    'Cinématique', 'Foot progress max unipodal frontal (°)' 'DG'
                    'Cinématique', 'Foot progress max unipodal frontal (°)' 'D'
                    'Cinématique', 'Foot progress max unipodal frontal (°)' 'G'
                    % Cinématique max unipodal en transverse
                    'Cinématique', 'Tronc max unipodal transverse (°)' 'DG'
                    'Cinématique', 'Tronc max unipodal transverse (°)' 'D'
                    'Cinématique', 'Tronc max unipodal transverse (°)' 'G'
                    'Cinématique', 'Bassin max unipodal transverse (°)' 'DG'
                    'Cinématique', 'Bassin max unipodal transverse (°)' 'D'
                    'Cinématique', 'Bassin max unipodal transverse (°)' 'G'
                    'Cinématique', 'Genou max unipodal transverse (°)' 'DG'
                    'Cinématique', 'Genou max unipodal transverse (°)' 'D'
                    'Cinématique', 'Genou max unipodal transverse (°)' 'G'
                    'Cinématique', 'Chevile max unipodal transverse (°)' 'DG'
                    'Cinématique', 'Chevile max unipodal transverse (°)' 'D'
                    'Cinématique', 'Chevile max unipodal transverse (°)' 'G'
                    'Cinématique', 'Foot progress max unipodal transverse (°)' 'DG'
                    'Cinématique', 'Foot progress max unipodal transverse (°)' 'D'
                    'Cinématique', 'Foot progress max unipodal transverse (°)' 'G'
                    
                    % Cinématique angle minimum durant l'appuie
                    'Cinématique', 'Tronc min appui sagittal (°)' 'DG'
                    'Cinématique', 'Tronc min appui sagittal (°)' 'D'
                    'Cinématique', 'Tronc min appui sagittal (°)' 'G'
                    'Cinématique', 'Bassin min appui sagittal (°)' 'DG'
                    'Cinématique', 'Bassin min appui sagittal (°)' 'D'
                    'Cinématique', 'Bassin min appui sagittal (°)' 'G'
                    'Cinématique', 'Genou min appui sagittal (°)' 'DG'
                    'Cinématique', 'Genou min appui sagittal (°)' 'D'
                    'Cinématique', 'Genou min appui sagittal (°)' 'G'
                    'Cinématique', 'Chevile min appui sagittal (°)' 'DG'
                    'Cinématique', 'Chevile min appui sagittal (°)' 'D'
                    'Cinématique', 'Chevile min appui sagittal (°)' 'G'
                    'Cinématique', 'Foot progress min appui sagittal (°)' 'DG'
                    'Cinématique', 'Foot progress min appui sagittal (°)' 'D'
                    'Cinématique', 'Foot progress min appui sagittal (°)' 'G'
                    % Cinématique min appui en frontal
                    'Cinématique', 'Tronc min appui frontal (°)' 'DG'
                    'Cinématique', 'Tronc min appui frontal (°)' 'D'
                    'Cinématique', 'Tronc min appui frontal (°)' 'G'
                    'Cinématique', 'Bassin min appui frontal (°)' 'DG'
                    'Cinématique', 'Bassin min appui frontal (°)' 'D'
                    'Cinématique', 'Bassin min appui frontal (°)' 'G'
                    'Cinématique', 'Genou min appui frontal (°)' 'DG'
                    'Cinématique', 'Genou min appui frontal (°)' 'D'
                    'Cinématique', 'Genou min appui frontal (°)' 'G'
                    'Cinématique', 'Chevile min appui frontal (°)' 'DG'
                    'Cinématique', 'Chevile min appui frontal (°)' 'D'
                    'Cinématique', 'Chevile min appui frontal (°)' 'G'
                    'Cinématique', 'Foot progress min appui frontal (°)' 'DG'
                    'Cinématique', 'Foot progress min appui frontal (°)' 'D'
                    'Cinématique', 'Foot progress min appui frontal (°)' 'G'
                    % Cinématique min appui en transverse
                    'Cinématique', 'Tronc min appui transverse (°)' 'DG'
                    'Cinématique', 'Tronc min appui transverse (°)' 'D'
                    'Cinématique', 'Tronc min appui transverse (°)' 'G'
                    'Cinématique', 'Bassin min appui transverse (°)' 'DG'
                    'Cinématique', 'Bassin min appui transverse (°)' 'D'
                    'Cinématique', 'Bassin min appui transverse (°)' 'G'
                    'Cinématique', 'Genou min appui transverse (°)' 'DG'
                    'Cinématique', 'Genou min appui transverse (°)' 'D'
                    'Cinématique', 'Genou min appui transverse (°)' 'G'
                    'Cinématique', 'Chevile min appui transverse (°)' 'DG'
                    'Cinématique', 'Chevile min appui transverse (°)' 'D'
                    'Cinématique', 'Chevile min appui transverse (°)' 'G'
                    'Cinématique', 'Foot progress min appui transverse (°)' 'DG'
                    'Cinématique', 'Foot progress min appui transverse (°)' 'D'
                    'Cinématique', 'Foot progress min appui transverse (°)' 'G'
                    
                    % Cinématique angle maximum durant l'appui
                    'Cinématique', 'Tronc max appui sagittal (°)' 'DG'
                    'Cinématique', 'Tronc max appui sagittal (°)' 'D'
                    'Cinématique', 'Tronc max appui sagittal (°)' 'G'
                    'Cinématique', 'Bassin max appui sagittal (°)' 'DG'
                    'Cinématique', 'Bassin max appui sagittal (°)' 'D'
                    'Cinématique', 'Bassin max appui sagittal (°)' 'G'
                    'Cinématique', 'Genou max appui sagittal (°)' 'DG'
                    'Cinématique', 'Genou max appui sagittal (°)' 'D'
                    'Cinématique', 'Genou max appui sagittal (°)' 'G'
                    'Cinématique', 'Chevile max appui sagittal (°)' 'DG'
                    'Cinématique', 'Chevile max appui sagittal (°)' 'D'
                    'Cinématique', 'Chevile max appui sagittal (°)' 'G'
                    'Cinématique', 'Foot progress max appui sagittal (°)' 'DG'
                    'Cinématique', 'Foot progress max appui sagittal (°)' 'D'
                    'Cinématique', 'Foot progress max appui sagittal (°)' 'G'
                    % Cinématique max appui en frontal
                    'Cinématique', 'Tronc max appui frontal (°)' 'DG'
                    'Cinématique', 'Tronc max appui frontal (°)' 'D'
                    'Cinématique', 'Tronc max appui frontal (°)' 'G'
                    'Cinématique', 'Bassin max appui frontal (°)' 'DG'
                    'Cinématique', 'Bassin max appui frontal (°)' 'D'
                    'Cinématique', 'Bassin max appui frontal (°)' 'G'
                    'Cinématique', 'Genou max appui frontal (°)' 'DG'
                    'Cinématique', 'Genou max appui frontal (°)' 'D'
                    'Cinématique', 'Genou max appui frontal (°)' 'G'
                    'Cinématique', 'Chevile max appui frontal (°)' 'DG'
                    'Cinématique', 'Chevile max appui frontal (°)' 'D'
                    'Cinématique', 'Chevile max appui frontal (°)' 'G'
                    'Cinématique', 'Foot progress max appui frontal (°)' 'DG'
                    'Cinématique', 'Foot progress max appui frontal (°)' 'D'
                    'Cinématique', 'Foot progress max appui frontal (°)' 'G'
                    % Cinématique max appui en transverse
                    'Cinématique', 'Tronc max appui transverse (°)' 'DG'
                    'Cinématique', 'Tronc max appui transverse (°)' 'D'
                    'Cinématique', 'Tronc max appui transverse (°)' 'G'
                    'Cinématique', 'Bassin max appui transverse (°)' 'DG'
                    'Cinématique', 'Bassin max appui transverse (°)' 'D'
                    'Cinématique', 'Bassin max appui transverse (°)' 'G'
                    'Cinématique', 'Genou max appui transverse (°)' 'DG'
                    'Cinématique', 'Genou max appui transverse (°)' 'D'
                    'Cinématique', 'Genou max appui transverse (°)' 'G'
                    'Cinéma c.results.Left.comRangeHeighttique', 'Chevile max appui transverse (°)' 'DG'
                    'Cinématique', 'Chevile max appui transverse (°)' 'D'
                    'Cinématique', 'Chevile max appui transverse (°)' 'G'
                    'Cinématique', 'Foot progress max appui transverse (°)' 'DG'
                    'Cinématique', 'Foot progress max appui transverse (°)' 'D'
                    'Cinématique', 'Foot progress max appui transverse (°)' 'G'
                    
                    % Cinématique RoM durant unipodal
                    'Cinématique', 'Tronc RoM unipodal sagittal (°)' 'DG'
                    'Cinématique', 'Tronc RoM unipodal sagittal (°)' 'D'
                    'Cinématique', 'Tronc RoM unipodal sagittal (°)' 'G'
                    'Cinématique', 'Bassin RoM unipodal sagittal (°)' 'DG'
                    'Cinématique', 'Bassin RoM unipodal sagittal (°)' 'D'
                    'Cinématique', 'Bassin RoM unipodal sagittal (°)' 'G'
                    'Cinématique', 'Genou RoM unipodal sagittal (°)' 'DG'
                    'Cinématique', 'Genou RoM unipodal sagittal (°)' 'D'
                    'Cinématique', 'Genou RoM unipodal sagittal (°)' 'G'
                    'Cinématique', 'Chevile RoM unipodal sagittal (°)' 'DG'
                    'Cinématique', 'Chevile RoM unipodal sagittal (°)' 'D'
                    'Cinématique', 'Chevile RoM unipodal sagittal (°)' 'G'
                    'Cinématique', 'Foot progress RoM unipodal sagittal (°)' 'DG'
                    'Cinématique', 'Foot progress RoM unipodal sagittal (°)' 'D'
                    'Cinématique', 'Foot progress RoM unipodal sagittal (°)' 'G'
                    % Cinématique RoM unipodal en frontal
                    'Cinématique', 'Tronc RoM unipodal frontal (°)' 'DG'
                    'Cinématique', 'Tronc RoM unipodal frontal (°)' 'D'
                    'Cinématique', 'Tronc RoM unipodal frontal (°)' 'G'
                    'Cinématique', 'Bassin RoM unipodal frontal (°)' 'DG'
                    'Cinématique', 'Bassin RoM unipodal frontal (°)' 'D'
                    'Cinématique', 'Bassin RoM unipodal frontal (°)' 'G'
                    'Cinématique', 'Genou RoM unipodal frontal (°)' 'DG'
                    'Cinématique', 'Genou RoM unipodal frontal (°)' 'D'
                    'Cinématique', 'Genou RoM unipodal frontal (°)' 'G'
                    'Cinématique', 'Chevile RoM unipodal frontal (°)' 'DG'
                    'Cinématique', 'Chevile RoM unipodal frontal (°)' 'D'
                    'Cinématique', 'Chevile RoM unipodal frontal (°)' 'G'
                    'Cinématique', 'Foot progress RoM unipodal frontal (°)' 'DG'
                    'Cinématique', 'Foot progress RoM unipodal frontal (°)' 'D'
                    'Cinématique', 'Foot progress RoM unipodal frontal (°)' 'G'
                    % Cinématique RoM unipodal en transverse
                    'Cinématique', 'Tronc RoM unipodal transverse (°)' 'DG'
                    'Cinématique', 'Tronc RoM unipodal transverse (°)' 'D'
                    'Cinématique', 'Tronc RoM unipodal transverse (°)' 'G'
                    'Cinématique', 'Bassin RoM unipodal transverse (°)' 'DG'
                    'Cinématique', 'Bassin RoM unipodal transverse (°)' 'D'
                    'Cinématique', 'Bassin RoM unipodal transverse (°)' 'G'
                    'Cinématique', 'Genou RoM unipodal transverse (°)' 'DG'
                    'Cinématique', 'Genou RoM unipodal transverse (°)' 'D'
                    'Cinématique', 'Genou RoM unipodal transverse (°)' 'G'
                    'Cinématique', 'Chevile RoM unipodal transverse (°)' 'DG'
                    'Cinématique', 'Chevile RoM unipodal transverse (°)' 'D'
                    'Cinématique', 'Chevile RoM unipodal transverse (°)' 'G'
                    'Cinématique', 'Foot progress RoM unipodal transverse (°)' 'DG'
                    'Cinématique', 'Foot progress RoM unipodal transverse (°)' 'D'
                    'Cinématique', 'Foot progress RoM unipodal transverse (°)' 'G'
                    
                    % Cinématique RoM durant l'appui
                    'Cinématique', 'Tronc RoM appui sagittal (°)' 'DG'
                    'Cinématique', 'Tronc RoM appui sagittal (°)' 'D'
                    'Cinématique', 'Tronc RoM appui sagittal (°)' 'G'
                    'Cinématique', 'Bassin RoM appui sagittal (°)' 'DG'
                    'Cinématique', 'Bassin RoM appui sagittal (°)' 'D'
                    'Cinématique', 'Bassin RoM appui sagittal (°)' 'G'
                    'Cinématique', 'Genou RoM appui sagittal (°)' 'DG'
                    'Cinématique', 'Genou RoM appui sagittal (°)' 'D'
                    'Cinématique', 'Genou RoM appui sagittal (°)' 'G'
                    'Cinématique', 'Chevile RoM appui sagittal (°)' 'DG'
                    'Cinématique', 'Chevile RoM appui sagittal (°)' 'D'
                    'Cinématique', 'Chevile RoM appui sagittal (°)' 'G'
                    'Cinématique', 'Foot progress RoM appui sagittal (°)' 'DG'
                    'Cinématique', 'Foot progress RoM appui sagittal (°)' 'D'
                    'Cinématique', 'Foot progress RoM appui sagittal (°)' 'G'
                    % Cinématique RoM appui en frontal
                    'Cinématique', 'Tronc RoM appui frontal (°)' 'DG'
                    'Cinématique', 'Tronc RoM appui frontal (°)' 'D'
                    'Cinématique', 'Tronc RoM appui frontal (°)' 'G'
                    'Cinématique', 'Bassin RoM appui frontal (°)' 'DG'
                    'Cinématique', 'Bassin RoM appui frontal (°)' 'D'
                    'Cinématique', 'Bassin RoM appui frontal (°)' 'G'
                    'Cinématique', 'Genou RoM appui frontal (°)' 'DG'
                    'Cinématique', 'Genou RoM appui frontal (°)' 'D'
                    'Cinématique', 'Genou RoM appui frontal (°)' 'G'
                    'Cinématique', 'Chevile RoM appui frontal (°)' 'DG'
                    'Cinématique', 'Chevile RoM appui frontal (°)' 'D'
                    'Cinématique', 'Chevile RoM appui frontal (°)' 'G'
                    'Cinématique', 'Foot progress RoM appui frontal (°)' 'DG'
                    'Cinématique', 'Foot progress RoM appui frontal (°)' 'D'
                    'Cinématique', 'Foot progress RoM appui frontal (°)' 'G'
                    % Cinématique RoM appui en transverse
                    'Cinématique', 'Tronc RoM appui transverse (°)' 'DG'
                    'Cinématique', 'Tronc RoM appui transverse (°)' 'D'
                    'Cinématique', 'Tronc RoM appui transverse (°)' 'G'
                    'Cinématique', 'Bassin RoM appui transverse (°)' 'DG'
                    'Cinématique', 'Bassin RoM appui transverse (°)' 'D'
                    'Cinématique', 'Bassin RoM appui transverse (°)' 'G'
                    'Cinématique', 'Genou RoM appui transverse (°)' 'DG'
                    'Cinématique', 'Genou RoM appui transverse (°)' 'D'
                    'Cinématique', 'Genou RoM appui transverse (°)' 'G'
                    'Cinématique', 'Chevile RoM appui transverse (°)' 'DG'
                    'Cinématique', 'Chevile RoM appui transverse (°)' 'D'
                    'Cinématique', 'Chevile RoM appui transverse (°)' 'G'
                    'Cinématique', 'Foot progress RoM appui transverse (°)' 'DG'
                    'Cinématique', 'Foot progress RoM appui transverse (°)' 'D'
                    'Cinématique', 'Foot progress RoM appui transverse (°)' 'G'
                    
                    % Cinématique mean durant unipodal
                    'Cinématique', 'Tronc moyenne unipodal sagittal (°)' 'DG'
                    'Cinématique', 'Tronc moyenne unipodal sagittal (°)' 'D'
                    'Cinématique', 'Tronc moyenne unipodal sagittal (°)' 'G'
                    'Cinématique', 'Bassin moyenne unipodal sagittal (°)' 'DG'
                    'Cinématique', 'Bassin moyenne unipodal sagittal (°)' 'D'
                    'Cinématique', 'Bassin moyenne unipodal sagittal (°)' 'G'
                    'Cinématique', 'Genou moyenne unipodal sagittal (°)' 'DG'
                    'Cinématique', 'Genou moyenne unipodal sagittal (°)' 'D'
                    'Cinématique', 'Genou moyenne unipodal sagittal (°)' 'G'
                    'Cinématique', 'Chevile moyenne unipodal sagittal (°)' 'DG'
                    'Cinématique', 'Chevile moyenne unipodal sagittal (°)' 'D'
                    'Cinématique', 'Chevile moyenne unipodal sagittal (°)' 'G'
                    'Cinématique', 'Foot progress moyenne unipodal sagittal (°)' 'DG'
                    'Cinématique', 'Foot progress moyenne unipodal sagittal (°)' 'D'
                    'Cinématique', 'Foot progress moyenne unipodal sagittal (°)' 'G'
                    % Cinématique moyenne unipodal en frontal
                    'Cinématique', 'Tronc moyenne unipodal frontal (°)' 'DG'
                    'Cinématique', 'Tronc moyenne unipodal frontal (°)' 'D'
                    'Cinématique', 'Tronc moyenne unipodal frontal (°)' 'G'
                    'Cinématique', 'Bassin moyenne unipodal frontal (°)' 'DG'
                    'Cinématique', 'Bassin moyenne unipodal frontal (°)' 'D'
                    'Cinématique', 'Bassin moyenne unipodal frontal (°)' 'G'
                    'Cinématique', 'Genou moyenne unipodal frontal (°)' 'DG'
                    'Cinématique', 'Genou moyenne unipodal frontal (°)' 'D'
                    'Cinématique', 'Genou moyenne unipodal frontal (°)' 'G'
                    'Cinématique', 'Chevile moyenne unipodal frontal (°)' 'DG'
                    'Cinématique', 'Chevile moyenne unipodal frontal (°)' 'D'
                    'Cinématique', 'Chevile moyenne unipodal frontal (°)' 'G'
                    'Cinématique', 'Foot progress moyenne unipodal frontal (°)' 'DG'
                    'Cinématique', 'Foot progress moyenne unipodal frontal (°)' 'D'
                    'Cinématique', 'Foot progress moyenne unipodal frontal (°)' 'G'
                    % Cinématique moyenne unipodal en transverse
                    'Cinématique', 'Tronc moyenne unipodal transverse (°)' 'DG'
                    'Cinématique', 'Tronc moyenne unipodal transverse (°)' 'D'
                    'Cinématique', 'Tronc moyenne unipodal transverse (°)' 'G'
                    'Cinématique', 'Bassin moyenne unipodal transverse (°)' 'DG'
                    'Cinématique', 'Bassin moyenne unipodal transverse (°)' 'D'
                    'Cinématique', 'Bassin moyenne unipodal transverse (°)' 'G'
                    'Cinématique', 'Genou moyenne unipodal transverse (°)' 'DG'
                    'Cinématique', 'Genou moyenne unipodal transverse (°)' 'D'
                    'Cinématique', 'Genou moyenne unipodal transverse (°)' 'G'
                    'Cinématique', 'Chevile moyenne unipodal transverse (°)' 'DG'
                    'Cinématique', 'Chevile moyenne unipodal transverse (°)' 'D'
                    'Cinématique', 'Chevile moyenne unipodal transverse (°)' 'G'
                    'Cinématique', 'Foot progress moyenne unipodal transverse (°)' 'DG'
                    'Cinématique', 'Foot progress moyenne unipodal transverse (°)' 'D'
                    'Cinématique', 'Foot progress moyenne unipodal transverse (°)' 'G'
                    
                    % Cinématique moyenne durant l'appui
                    'Cinématique', 'Tronc moyenne appui sagittal (°)' 'DG'
                    'Cinématique', 'Tronc moyenne appui sagittal (°)' 'D'
                    'Cinématique', 'Tronc moyenne appui sagittal (°)' 'G'
                    'Cinématique', 'Bassin moyenne appui sagittal (°)' 'DG'
                    'Cinématique', 'Bassin moyenne appui sagittal (°)' 'D'
                    'Cinématique', 'Bassin moyenne appui sagittal (°)' 'G'
                    'Cinématique', 'Genou moyenne appui sagittal (°)' 'DG'
                    'Cinématique', 'Genou moyenne appui sagittal (°)' 'D'
                    'Cinématique', 'Genou moyenne appui sagittal (°)' 'G'
                    'Cinématique', 'Chevile moyenne appui sagittal (°)' 'DG'
                    'Cinématique', 'Chevile moyenne appui sagittal (°)' 'D'
                    'Cinématique', 'Chevile moyenne appui sagittal (°)' 'G'
                    'Cinématique', 'Foot progress moyenne appui sagittal (°)' 'DG'
                    'Cinématique', 'Foot progress moyenne appui sagittal (°)' 'D'
                    'Cinématique', 'Foot progress moyenne appui sagittal (°)' 'G'
                    % Cinématique moyenne appui en frontal
                    'Cinématique', 'Tronc moyenne appui frontal (°)' 'DG'
                    'Cinématique', 'Tronc moyenne appui frontal (°)' 'D'
                    'Cinématique', 'Tronc moyenne appui frontal (°)' 'G'
                    'Cinématique', 'Bassin moyenne appui frontal (°)' 'DG'
                    'Cinématique', 'Bassin moyenne appui frontal (°)' 'D'
                    'Cinématique', 'Bassin moyenne appui frontal (°)' 'G'
                    'Cinématique', 'Genou moyenne appui frontal (°)' 'DG'
                    'Cinématique', 'Genou moyenne appui frontal (°)' 'D'
                    'Cinématique', 'Genou moyenne appui frontal (°)' 'G'
                    'Cinématique', 'Chevile moyenne appui frontal (°)' 'DG'
                    'Cinématique', 'Chevile moyenne appui frontal (°)' 'D'
                    'Cinématique', 'Chevile moyenne appui frontal (°)' 'G'
                    'Cinématique', 'Foot progress moyenne appui frontal (°)' 'DG'
                    'Cinématique', 'Foot progress moyenne appui frontal (°)' 'D'
                    'Cinématique', 'Foot progress moyenne appui frontal (°)' 'G'
                    % Cinématique moyenne appui en transverse
                    'Cinématique', 'Tronc moyenne appui transverse (°)' 'DG'
                    'Cinématique', 'Tronc moyenne appui transverse (°)' 'D'
                    'Cinématique', 'Tronc moyenne appui transverse (°)' 'G'
                    'Cinématique', 'Bassin moyenne appui transverse (°)' 'DG'
                    'Cinématique', 'Bassin moyenne appui transverse (°)' 'D'
                    'Cinématique', 'Bassin moyenne appui transverse (°)' 'G'
                    'Cinématique', 'Genou moyenne appui transverse (°)' 'DG'
                    'Cinématique', 'Genou moyenne appui transverse (°)' 'D'
                    'Cinématique', 'Genou moyenne appui transverse (°)' 'G'
                    'Cinématique', 'Chevile moyenne appui transverse (°)' 'DG'
                    'Cinématique', 'Chevile moyenne appui transverse (°)' 'D'
                    'Cinématique', 'Chevile moyenne appui transverse (°)' 'G'
                    'Cinématique', 'Foot progress moyenne appui transverse (°)' 'DG'
                    'Cinématique', 'Foot progress moyenne appui transverse (°)' 'D'
                    'Cinématique', 'Foot progress moyenne appui transverse (°)' 'G'
                    
                    % Vitesse de certaines articulations en sagittal 
                    'Vitesse',      'Extension max hanche de 20% à 80% sagittal (°/s)'   'DG'
                    'Vitesse',      'Extension max hanche de 20% à 80% sagittal (°/s)'   'D'
                    'Vitesse',      'Extension max hanche de 20% à 80% sagittal (°/s)'   'G'
                    'Vitesse',      'Flexion max hanche de 20% à 80% sagittal (°/s)'     'DG'
                    'Vitesse',      'Flexion max hanche de 20% à 80% sagittal (°/s)'     'D'
                    'Vitesse',      'Flexion max hanche de 20% à 80% sagittal (°/s)'     'G'
                    'Vitesse',      'Extension max genou de poussée à 100% sagittal (°/s)'   'DG'
                    'Vitesse',      'Extension max genou de poussée à 100% sagittal (°/s)'   'D'
                    'Vitesse',      'Extension max genou de poussée à 100% sagittal (°/s)'   'G'
                    'Vitesse',      'Flexion max genou de poussée à 100% sagittal (°/s)'     'DG'
                    'Vitesse',      'Flexion max genou de poussée à 100% sagittal (°/s)'     'D'
                    'Vitesse',      'Flexion max genou de poussée à 100% sagittal (°/s)'     'G'
                    'Vitesse',      'Extension max cheville de oppContact à 100% sagittal (°/s)'   'DG'
                    'Vitesse',      'Extension max cheville de oppContact à 100% sagittal (°/s)'   'D'
                    'Vitesse',      'Extension max cheville de oppContact à 100% sagittal (°/s)'   'G'
                    'Vitesse',      'Flexion max cheville de oppContact à 100% sagittal (°/s)'     'DG'
                    'Vitesse',      'Flexion max cheville de oppContact à 100% sagittal (°/s)'     'D'
                    'Vitesse',      'Flexion max cheville de oppContact à 100% sagittal (°/s)'     'G'
                    % Vitesse de certaines articulations en frontal 
                    'Vitesse',      'Extension max hanche de 20% à 80% frontal (°/s)'   'DG'
                    'Vitesse',      'Extension max hanche de 20% à 80% frontal (°/s)'   'D'
                    'Vitesse',      'Extension max hanche de 20% à 80% frontal (°/s)'   'G'
                    'Vitesse',      'Flexion max hanche de 20% à 80% frontal (°/s)'     'DG'
                    'Vitesse',      'Flexion max hanche de 20% à 80% frontal (°/s)'     'D'
                    'Vitesse',      'Flexion max hanche de 20% à 80% frontal (°/s)'     'G'
                    'Vitesse',      'Extension max genou de poussée à 100% frontal (°/s)'   'DG'
                    'Vitesse',      'Extension max genou de poussée à 100% frontal (°/s)'   'D'
                    'Vitesse',      'Extension max genou de poussée à 100% frontal (°/s)'   'G'
                    'Vitesse',      'Flexion max genou de poussée à 100% frontal (°/s)'     'DG'
                    'Vitesse',      'Flexion max genou de poussée à 100% frontal (°/s)'     'D'
                    'Vitesse',      'Flexion max genou de poussée à 100% frontal (°/s)'     'G'
                    'Vitesse',      'Extension max cheville de oppContact à 100% frontal (°/s)'   'DG'
                    'Vitesse',      'Extension max cheville de oppContact à 100% frontal (°/s)'   'D'
                    'Vitesse',      'Extension max cheville de oppContact à 100% frontal (°/s)'   'G'
                    'Vitesse',      'Flexion max cheville de oppContact à 100% frontal (°/s)'     'DG'
                    'Vitesse',      'Flexion max cheville de oppContact à 100% frontal (°/s)'     'D'
                    'Vitesse',      'Flexion max cheville de oppContact à 100% frontal (°/s)'     'G'
                    % Vitesse de certaines articulations en transverse 
                    'Vitesse',      'Extension max hanche de 20% à 80% transverse (°/s)'   'DG'
                    'Vitesse',      'Extension max hanche de 20% à 80% transverse (°/s)'   'D'
                    'Vitesse',      'Extension max hanche de 20% à 80% transverse (°/s)'   'G'
                    'Vitesse',      'Flexion max hanche de 20% à 80% transverse (°/s)'     'DG'
                    'Vitesse',      'Flexion max hanche de 20% à 80% transverse (°/s)'     'D'
                    'Vitesse',      'Flexion max hanche de 20% à 80% transverse (°/s)'     'G'
                    'Vitesse',      'Extension max genou de poussée à 100% transverse (°/s)'   'DG'
                    'Vitesse',      'Extension max genou de poussée à 100% transverse (°/s)'   'D'
                    'Vitesse',      'Extension max genou de poussée à 100% transverse (°/s)'   'G'
                    'Vitesse',      'Flexion max genou de poussée à 100% transverse (°/s)'     'DG'
                    'Vitesse',      'Flexion max genou de poussée à 100% transverse (°/s)'     'D'
                    'Vitesse',      'Flexion max genou de poussée à 100% transverse (°/s)'     'G'
                    'Vitesse',      'Extension max cheville de oppContact à 100% transverse (°/s)'   'DG'
                    'Vitesse',      'Extension max cheville de oppContact à 100% transverse (°/s)'   'D'
                    'Vitesse',      'Extension max cheville de oppContact à 100% transverse (°/s)'   'G'
                    'Vitesse',      'Flexion max cheville de oppContact à 100% transverse (°/s)'     'DG'
                    'Vitesse',      'Flexion max cheville de oppContact à 100% transverse (°/s)'     'D'
                    'Vitesse',      'Flexion max cheville de oppContact à 100% transverse (°/s)'     'G'
                    
                    
                    % Cinématique du CoM
                    'Cinématique', 'Amplitude CoM Hauteur (% taille)'       'DG'
                    'Cinématique', 'Amplitude CoM Hauteur (% taille)'       'D'
                    'Cinématique', 'Amplitude CoM Hauteur (% taille)'       'G'
                    'Cinématique', 'Amplitude CoM min Hauteur (% taille)'   'DG'
                    'Cinématique', 'Amplitude CoM min Hauteur (% taille)'   'D'
                    'Cinématique', 'Amplitude CoM min Hauteur (% taille)'   'G'
                    'Cinématique', 'Amplitude CoM max Hauteur (% taille)'   'DG'
                    'Cinématique', 'Amplitude CoM max Hauteur (% taille)'   'D'
                    'Cinématique', 'Amplitude CoM max Hauteur (% taille)'   'G'
                    'Cinématique', 'Amplitude CoM Medio Latéral (mm)'       'DG'
                    'Cinématique', 'Amplitude CoM Medio Latéral (mm)'       'D'
                    'Cinématique', 'Amplitude CoM Medio Latéral (mm)'       'G'
                    'Cinématique', 'Amplitude CoM Base support (mm)'        'DG'
                    'Cinématique', 'Amplitude CoM Base support (mm)'        'D'
                    'Cinématique', 'Amplitude CoM Base support (mm)'        'G'
                    'Cinématique', 'Amplitude CoM Base support (%)'         'DG'
                    'Cinématique', 'Amplitude CoM Base support (%)'         'D'
                    'Cinématique', 'Amplitude CoM Base support (%)'         'G'
                    
                    % Vitesse min du CoM en médiolatéral
                    'Cinématique', 'Vitesse min CoM axe médiolatéral (mm/s)'       'DG'
                    'Cinématique', 'Vitesse min CoM axe médiolatéral (mm/s)'       'D'
                    'Cinématique', 'Vitesse min CoM axe médiolatéral (mm/s)'       'G'
                    % Vitesse min du CoM en frontal
                    'Cinématique', 'Vitesse min CoM axe transverse (mm/s)'         'DG'
                    'Cinématique', 'Vitesse min CoM axe transverse (mm/s)'         'D'
                    'Cinématique', 'Vitesse min CoM axe transverse (mm/s)'         'G'
                    % Vitesse min du CoM en transverse
                    'Cinématique', 'Vitesse min CoM axe vertical (mm/s)'           'DG'
                    'Cinématique', 'Vitesse min CoM axe vertical (mm/s)'           'D'
                    'Cinématique', 'Vitesse min CoM axe vertical (mm/s)'           'G'
                    % Vitesse max du CoM en médiolatéral
                    'Cinématique', 'Vitesse max CoM axe médiolatéral (mm/s)'       'DG'
                    'Cinématique', 'Vitesse max CoM axe médiolatéral (mm/s)'       'D'
                    'Cinématique', 'Vitesse max CoM axe médiolatéral (mm/s)'       'G'
                    % Vitesse max du CoM en frontal
                    'Cinématique', 'Vitesse max CoM axe transverse (mm/s)'         'DG'
                    'Cinématique', 'Vitesse max CoM axe transverse (mm/s)'         'D'
                    'Cinématique', 'Vitesse max CoM axe transverse (mm/s)'         'G'
                    % Vitesse max du CoM en transverse
                    'Cinématique', 'Vitesse max CoM axe vertical (mm/s)'           'DG'
                    'Cinématique', 'Vitesse max CoM axe vertical (mm/s)'           'D'
                    'Cinématique', 'Vitesse max CoM axe vertical (mm/s)'           'G'
                    
                    % Accélération min du CoM en médiolatéral
                    'Cinématique', 'Accélération min CoM axe médiolatéral (mm/s²)'       'DG'
                    'Cinématique', 'Accélération min CoM axe médiolatéral (mm/s²)'       'D'
                    'Cinématique', 'Accélération min CoM axe médiolatéral (mm/s²)'       'G'
                    % Accélération min du CoM en frontal
                    'Cinématique', 'Accélération min CoM axe transverse (mm/s²)'         'DG'
                    'Cinématique', 'Accélération min CoM axe transverse (mm/s²)'         'D'
                    'Cinématique', 'Accélération min CoM axe transverse (mm/s²)'         'G'
                    % Accélération min du CoM en transverse
                    'Cinématique', 'Accélération min CoM axe vertical (mm/s²)'           'DG'
                    'Cinématique', 'Accélération min CoM axe vertical (mm/s²)'           'D'
                    'Cinématique', 'Accélération min CoM axe vertical (mm/s²)'           'G'
                    % Accélération max du CoM en médiolatéral
                    'Cinématique', 'Accélération max CoM axe médiolatéral (mm/s²)'       'DG'
                    'Cinématique', 'Accélération max CoM axe médiolatéral (mm/s²)'       'D'
                    'Cinématique', 'Accélération max CoM axe médiolatéral (mm/s²)'       'G'
                    % Accélération max du CoM en frontal
                    'Cinématique', 'Accélération max CoM axe transverse (mm/s²)'         'DG'
                    'Cinématique', 'Accélération max CoM axe transverse (mm/s²)'         'D'
                    'Cinématique', 'Accélération max CoM axe transverse (mm/s²)'         'G'
                    % Accélération max du CoM en transverse
                    'Cinématique', 'Accélération max CoM axe vertical (mm/s²)'           'DG'
                    'Cinématique', 'Accélération max CoM axe vertical (mm/s²)'           'D'
                    'Cinématique', 'Accélération max CoM axe vertical (mm/s²)'           'G'
                    
                    % Secousse min du CoM en médiolatéral
                    'Cinématique', 'Secousse min CoM axe médiolatéral (mm/s³)'       'DG'
                    'Cinématique', 'Secousse min CoM axe médiolatéral (mm/s³)'       'D'
                    'Cinématique', 'Secousse min CoM axe médiolatéral (mm/s³)'       'G'
                    % Secousse min du CoM en frontal
                    'Cinématique', 'Secousse min CoM axe transverse (mm/s³)'         'DG'
                    'Cinématique', 'Secousse min CoM axe transverse (mm/s³)'         'D'
                    'Cinématique', 'Secousse min CoM axe transverse (mm/s³)'         'G'
                    % Secousse min du CoM en transverse
                    'Cinématique', 'Secousse min CoM axe vertical (mm/s³)'           'DG'
                    'Cinématique', 'Secousse min CoM axe vertical (mm/s³)'           'D'
                    'Cinématique', 'Secousse min CoM axe vertical (mm/s³)'           'G'
                    % Secousse max du CoM en médiolatéral
                    'Cinématique', 'Secousse max CoM axe médiolatéral (mm/s³)'       'DG'
                    'Cinématique', 'Secousse max CoM axe médiolatéral (mm/s³)'       'D'
                    'Cinématique', 'Secousse max CoM axe médiolatéral (mm/s³)'       'G'
                    % Secousse max du CoM en frontal
                    'Cinématique', 'Secousse max CoM axe transverse (mm/s³)'         'DG'
                    'Cinématique', 'Secousse max CoM axe transverse (mm/s³)'         'D'
                    'Cinématique', 'Secousse max CoM axe transverse (mm/s³)'         'G'
                    % Secousse max du CoM en transverse
                    'Cinématique', 'Secousse max CoM axe vertical (mm/s³)'           'DG'
                    'Cinématique', 'Secousse max CoM axe vertical (mm/s³)'           'D'
                    'Cinématique', 'Secousse max CoM axe vertical (mm/s³)'           'G'
                    
                    % Couples articulaires au contact talon en sagittal
                    'Moment'        'Pic extension hanche au contact talon sagittal (N/m)'   'DG'
                    'Moment'        'Pic extension hanche au contact talon sagittal (N/m)'   'D'
                    'Moment'        'Pic extension hanche au contact talon sagittal (N/m)'   'G'
                    'Moment'        'Pic flexion hanche au contact talon sagittal (N/m)'   'DG'
                    'Moment'        'Pic flexion hanche au contact talon sagittal (N/m)'   'D'
                    'Moment'        'Pic flexion hanche au contact talon sagittal (N/m)'   'G'
                    'Moment'        'Pic extension genou au contact talon sagittal (N/m)'    'DG'
                    'Moment'        'Pic extension genou au contact talon sagittal (N/m)'    'D'
                    'Moment'        'Pic extension genou au contact talon sagittal (N/m)'    'G'
                    'Moment'        'Pic flexion genou au contact talon sagittal (N/m)'    'DG'
                    'Moment'        'Pic flexion genou au contact talon sagittal (N/m)'    'D'
                    'Moment'        'Pic flexion genou au contact talon sagittal (N/m)'    'G'
                    'Moment'        'Pic extension cheville au contact talon sagittal (N/m)'    'DG'
                    'Moment'        'Pic extension cheville au contact talon sagittal (N/m)'    'D'
                    'Moment'        'Pic extension cheville au contact talon sagittal (N/m)'    'G'
                    'Moment'        'Pic flexion cheville au contact talon sagittal (N/m)'    'DG'
                    'Moment'        'Pic flexion cheville au contact talon sagittal (N/m)'    'D'
                    'Moment'        'Pic flexion cheville au contact talon sagittal (N/m)'    'G'
                    % Couples articulaires au contact talon en frontal
                    'Moment'        'Pic extension hanche au contact talon frontal (N/m)'   'DG'
                    'Moment'        'Pic extension hanche au contact talon frontal (N/m)'   'D'
                    'Moment'        'Pic extension hanche au contact talon frontal (N/m)'   'G'
                    'Moment'        'Pic flexion hanche au contact talon frontal (N/m)'   'DG'
                    'Moment'        'Pic flexion hanche au contact talon frontal (N/m)'   'D'
                    'Moment'        'Pic flexion hanche au contact talon frontal (N/m)'   'G'
                    'Moment'        'Pic extension genou au contact talon frontal (N/m)'    'DG'
                    'Moment'        'Pic extension genou au contact talon frontal (N/m)'    'D'
                    'Moment'        'Pic extension genou au contact talon frontal (N/m)'    'G'
                    'Moment'        'Pic flexion genou au contact talon frontal (N/m)'    'DG'
                    'Moment'        'Pic flexion genou au contact talon frontal (N/m)'    'D'
                    'Moment'        'Pic flexion genou au contact talon frontal (N/m)'    'G'
                    'Moment'        'Pic extension cheville au contact talon frontal (N/m)'    'DG'
                    'Moment'        'Pic extension cheville au contact talon frontal (N/m)'    'D'
                    'Moment'        'Pic extension cheville au contact talon frontal (N/m)'    'G'
                    'Moment'        'Pic flexion cheville au contact talon frontal (N/m)'    'DG'
                    'Moment'        'Pic flexion cheville au contact talon frontal (N/m)'    'D'
                    'Moment'        'Pic flexion cheville au contact talon frontal (N/m)'    'G'
                    % Couples articulaires au contact talon en transverse
                    'Moment'        'Pic extension hanche au contact talon transverse (N/m)'   'DG'
                    'Moment'        'Pic extension hanche au contact talon transverse (N/m)'   'D'
                    'Moment'        'Pic extension hanche au contact talon transverse (N/m)'   'G'
                    'Moment'        'Pic flexion hanche au contact talon transverse (N/m)'   'DG'
                    'Moment'        'Pic flexion hanche au contact talon transverse (N/m)'   'D'
                    'Moment'        'Pic flexion hanche au contact talon transverse (N/m)'   'G'
                    'Moment'        'Pic extension genou au contact talon transverse (N/m)'    'DG'
                    'Moment'        'Pic extension genou au contact talon transverse (N/m)'    'D'
                    'Moment'        'Pic extension genou au contact talon transverse (N/m)'    'G'
                    'Moment'        'Pic flexion genou au contact talon transverse (N/m)'    'DG'
                    'Moment'        'Pic flexion genou au contact talon transverse (N/m)'    'D'
                    'Moment'        'Pic flexion genou au contact talon transverse (N/m)'    'G'
                    'Moment'        'Pic extension cheville au contact talon transverse (N/m)'    'DG'
                    'Moment'        'Pic extension cheville au contact talon transverse (N/m)'    'D'
                    'Moment'        'Pic extension cheville au contact talon transverse (N/m)'    'G'
                    'Moment'        'Pic flexion cheville au contact talon transverse (N/m)'    'DG'
                    'Moment'        'Pic flexion cheville au contact talon transverse (N/m)'    'D'
                    'Moment'        'Pic flexion cheville au contact talon transverse (N/m)'    'G'
                    
                    % Couples articulaires à la poussée en sagittal
                    'Moment'        'Pic extension hanche à la poussée sagittal (N/m)'   'DG'
                    'Moment'        'Pic extension hanche à la poussée sagittal (N/m)'   'D'
                    'Moment'        'Pic extension hanche à la poussée sagittal (N/m)'   'G'
                    'Moment'        'Pic flexion hanche à la poussée sagittal (N/m)'   'DG'
                    'Moment'        'Pic flexion hanche à la poussée sagittal (N/m)'   'D'
                    'Moment'        'Pic flexion hanche à la poussée sagittal (N/m)'   'G'
                    'Moment'        'Pic extension genou à la poussée sagittal (N/m)'    'DG'
                    'Moment'        'Pic extension genou à la poussée sagittal (N/m)'    'D'
                    'Moment'        'Pic extension genou à la poussée sagittal (N/m)'    'G'
                    'Moment'        'Pic flexion genou à la poussée sagittal (N/m)'    'DG'
                    'Moment'        'Pic flexion genou à la poussée sagittal (N/m)'    'D'
                    'Moment'        'Pic flexion genou à la poussée sagittal (N/m)'    'G'
                    'Moment'        'Pic extension cheville à la poussée sagittal (N/m)'    'DG'
                    'Moment'        'Pic extension cheville à la poussée sagittal (N/m)'    'D'
                    'Moment'        'Pic extension cheville à la poussée sagittal (N/m)'    'G'
                    'Moment'        'Pic flexion cheville à la poussée sagittal (N/m)'    'DG'
                    'Moment'        'Pic flexion cheville à la poussée sagittal (N/m)'    'D'
                    'Moment'        'Pic flexion cheville à la poussée sagittal (N/m)'    'G'
                    % Couples articulaires à la poussée en frontal
                    'Moment'        'Pic extension hanche à la poussée frontal (N/m)'   'DG'
                    'Moment'        'Pic extension hanche à la poussée frontal (N/m)'   'D'
                    'Moment'        'Pic extension hanche à la poussée frontal (N/m)'   'G'
                    'Moment'        'Pic flexion hanche à la poussée frontal (N/m)'   'DG'
                    'Moment'        'Pic flexion hanche à la poussée frontal (N/m)'   'D'
                    'Moment'        'Pic flexion hanche à la poussée frontal (N/m)'   'G'
                    'Moment'        'Pic extension genou à la poussée frontal (N/m)'    'DG'
                    'Moment'        'Pic extension genou à la poussée frontal (N/m)'    'D'
                    'Moment'        'Pic extension genou à la poussée frontal (N/m)'    'G'
                    'Moment'        'Pic flexion genou à la poussée frontal (N/m)'    'DG'
                    'Moment'        'Pic flexion genou à la poussée frontal (N/m)'    'D'
                    'Moment'        'Pic flexion genou à la poussée frontal (N/m)'    'G'
                    'Moment'        'Pic extension cheville à la poussée frontal (N/m)'    'DG'
                    'Moment'        'Pic extension cheville à la poussée frontal (N/m)'    'D'
                    'Moment'        'Pic extension cheville à la poussée frontal (N/m)'    'G'
                    'Moment'        'Pic flexion cheville à la poussée frontal (N/m)'    'DG'
                    'Moment'        'Pic flexion cheville à la poussée frontal (N/m)'    'D'
                    'Moment'        'Pic flexion cheville à la poussée frontal (N/m)'    'G'
                    % Couples articulaires à la poussée en transverse
                    'Moment'        'Pic extension hanche à la poussée transverse (N/m)'   'DG'
                    'Moment'        'Pic extension hanche à la poussée transverse (N/m)'   'D'
                    'Moment'        'Pic extension hanche à la poussée transverse (N/m)'   'G'
                    'Moment'        'Pic flexion hanche à la poussée transverse (N/m)'   'DG'
                    'Moment'        'Pic flexion hanche à la poussée transverse (N/m)'   'D'
                    'Moment'        'Pic flexion hanche à la poussée transverse (N/m)'   'G'
                    'Moment'        'Pic extension genou à la poussée transverse (N/m)'    'DG'
                    'Moment'        'Pic extension genou à la poussée transverse (N/m)'    'D'
                    'Moment'        'Pic extension genou à la poussée transverse (N/m)'    'G'
                    'Moment'        'Pic flexion genou à la poussée transverse (N/m)'    'DG'
                    'Moment'        'Pic flexion genou à la poussée transverse (N/m)'    'D'
                    'Moment'        'Pic flexion genou à la poussée transverse (N/m)'    'G'
                    'Moment'        'Pic extension cheville à la poussée transverse (N/m)'    'DG'
                    'Moment'        'Pic extension cheville à la poussée transverse (N/m)'    'D'
                    'Moment'        'Pic extension cheville à la poussée transverse (N/m)'    'G'
                    'Moment'        'Pic flexion cheville à la poussée transverse (N/m)'    'DG'
                    'Moment'        'Pic flexion cheville à la poussée transverse (N/m)'    'D'
                    'Moment'        'Pic flexion cheville à la poussée transverse (N/m)'    'G'
                    
                    % Puissance max articulaires à l'appui en sagitta
                    'Puissance'     'Pic extension hanche à l''appui sagittal (N/m)'   'DG'
                    'Puissance'     'Pic extension hanche à l''appui sagittal (N/m)'   'D'
                    'Puissance'     'Pic extension hanche à l''appui sagittal (N/m)'   'G'
                    'Puissance'     'Pic flexion hanche à l''appui sagittal (N/m)'   'DG'
                    'Puissance'     'Pic flexion hanche à l''appui sagittal (N/m)'   'D'
                    'Puissance'     'Pic flexion hanche à l''appui sagittal (N/m)'   'G'
                    'Puissance'     'Pic extension genou à l''appui sagittal (N/m)'    'DG'
                    'Puissance'     'Pic extension genou à l''appui sagittal (N/m)'    'D'
                    'Puissance'     'Pic extension genou à l''appui sagittal (N/m)'    'G'
                    'Puissance'     'Pic flexion genou à l''appui sagittal (N/m)'    'DG'
                    'Puissance'     'Pic flexion genou à l''appui sagittal (N/m)'    'D'
                    'Puissance'     'Pic flexion genou à l''appui sagittal (N/m)'    'G'
                    % Couples articulaires à l''appui en frontal
                    'Puissance'     'Pic extension hanche à l''appui frontal (N/m)'   'DG'
                    'Puissance'     'Pic extension hanche à l''appui frontal (N/m)'   'D'
                    'Puissance'     'Pic extension hanche à l''appui frontal (N/m)'   'G'
                    'Puissance'     'Pic flexion hanche à l''appui frontal (N/m)'   'DG'
                    'Puissance'     'Pic flexion hanche à l''appui frontal (N/m)'   'D'
                    'Puissance'     'Pic flexion hanche à l''appui frontal (N/m)'   'G'
                    'Puissance'     'Pic extension genou à l''appui frontal (N/m)'    'DG'
                    'Puissance'     'Pic extension genou à l''appui frontal (N/m)'    'D'
                    'Puissance'     'Pic extension genou à l''appui frontal (N/m)'    'G'
                    'Puissance'     'Pic flexion genou à l''appui frontal (N/m)'    'DG'
                    'Puissance'     'Pic flexion genou à l''appui frontal (N/m)'    'D'
                    'Puissance'     'Pic flexion genou à l''appui frontal (N/m)'    'G'
                    % Couples articulaires à l''appui en transverse
                    'Puissance'     'Pic extension hanche à l''appui transverse (N/m)'   'DG'
                    'Puissance'     'Pic extension hanche à l''appui transverse (N/m)'   'D'
                    'Puissance'     'Pic extension hanche à l''appui transverse (N/m)'   'G'
                    'Puissance'     'Pic flexion hanche à l''appui transverse (N/m)'   'DG'
                    'Puissance'     'Pic flexion hanche à l''appui transverse (N/m)'   'D'
                    'Puissance'     'Pic flexion hanche à l''appui transverse (N/m)'   'G'
                    'Puissance'     'Pic extension genou à l''appui transverse (N/m)'    'DG'
                    'Puissance'     'Pic extension genou à l''appui transverse (N/m)'    'D'
                    'Puissance'     'Pic extension genou à l''appui transverse (N/m)'    'G'
                    'Puissance'     'Pic flexion genou à l''appui transverse (N/m)'    'DG'
                    'Puissance'     'Pic flexion genou à l''appui transverse (N/m)'    'D'
                    'Puissance'     'Pic flexion genou à l''appui transverse (N/m)'    'G'
                    
                    % Puissance max articulaires à la poussée en sagittal
                    'Puissance'     'Pic extension cheville à la poussée sagittal (N/m)'   'DG'
                    'Puissance'     'Pic extension cheville à la poussée sagittal (N/m)'   'D'
                    'Puissance'     'Pic extension cheville à la poussée sagittal (N/m)'   'G'
                    'Puissance'     'Pic flexion cheville à la poussée sagittal (N/m)'   'DG'
                    'Puissance'     'Pic flexion cheville à la poussée sagittal (N/m)'   'D'
                    'Puissance'     'Pic flexion cheville à la poussée sagittal (N/m)'   'G'
                     % Couples articulaires à la poussée en frontal
                    'Puissance'     'Pic extension cheville à la poussée frontal (N/m)'   'DG'
                    'Puissance'     'Pic extension cheville à la poussée frontal (N/m)'   'D'
                    'Puissance'     'Pic extension cheville à la poussée frontal (N/m)'   'G'
                    'Puissance'     'Pic flexion cheville à la poussée frontal (N/m)'   'DG'
                    'Puissance'     'Pic flexion cheville à la poussée frontal (N/m)'   'D'
                    'Puissance'     'Pic flexion cheville à la poussée frontal (N/m)'   'G'
                    % Couples articulaires à la poussée en transverse
                    'Puissance'     'Pic extension cheville à la poussée transverse (N/m)'   'DG'
                    'Puissance'     'Pic extension cheville à la poussée transverse (N/m)'   'D'
                    'Puissance'     'Pic extension cheville à la poussée transverse (N/m)'   'G'
                    'Puissance'     'Pic flexion cheville à la poussée transverse (N/m)'   'DG'
                    'Puissance'     'Pic flexion cheville à la poussée transverse (N/m)'   'D'
                    'Puissance'     'Pic flexion cheville à la poussée transverse (N/m)'   'G'
                    };
        fid = fopen(c.file.savepath, 'w+');
        fprintf(fid, sprintf('%%s%s',sep), header{:,1});
        fprintf(fid, '\n');
        fprintf(fid, sprintf('%%s%s',sep), header{:,2});
        fprintf(fid, '\n');
        fprintf(fid, sprintf('%%s%s',sep), header{:,3});
        fprintf(fid, '\n');
        subject = 1;
    else
        % Sinon, lire combien il y a de sujet, puis concaténer
        fid_tp = fopen(filepath, 'r');
        % Sauter l'entete
        for i = 1:3
            fgetl(fid_tp);
        end
        subject = 1;
        while ~feof(fid_tp)
            t = fgetl(fid_tp);
            % Parse t pour savoir si c'est un sujet
            if ~isempty(strfind(t, ','));
                subject = subject + 1;
            end
        end
        fclose(fid_tp);
        fid = fopen(filepath, 'a+');
    end

    outdata = { '%s',       c.info.note
                '%d',       subject
                '%s',       c.info.name 
                '%s',       c.info.aideStr
                '%d',       c.info.aide
                '%1.2f',    c.info.age
                '%d',       c.info.sexe
                '%1.1f',    c.info.mass
                '%1.1f',    c.info.height/10
%                 % Moments à l'attaque
%                 '%1.2f',    c.results.MeanLeg.momentMax_0_OppFootOff.Hip(1) % Hanche Peak extension attaque
%                 '%1.2f',    c.results.Right.momentMax_0_OppFootOff.RHip(1)
%                 '%1.2f',    c.results.Left.momentMax_0_OppFootOff.LHip(1)
%                 '%1.2f',    c.results.MeanLeg.momentMin_0_OppFootOff.Hip(1) % Hanche Peak flexion attaque
%                 '%1.2f',    c.results.Right.momentMin_0_OppFootOff.RHip(1)
%                 '%1.2f',    c.results.Left.momentMin_0_OppFootOff.LHip(1)
%                 '%1.2f',    c.results.MeanLeg.momentMin_0_OppFootOff.Hip(2) % Hanche Peak abduction attaque
%                 '%1.2f',    c.results.Right.momentMin_0_OppFootOff.RHip(2)
%                 '%1.2f',    c.results.Left.momentMin_0_OppFootOff.LHip(2)
%                 '%1.2f',    c.results.MeanLeg.momentMax_0_OppFootOff.Knee(1) % Genou Peak extension attaque
%                 '%1.2f',    c.results.Right.momentMax_0_OppFootOff.RHip(1)
%                 '%1.2f',    c.results.Left.momentMax_0_OppFootOff.LHip(1)
%                 '%1.2f',    c.results.MeanLeg.momentMin_0_OppFootOff.Knee(1) % Genou Peak extension attaque
%                 '%1.2f',    c.results.Right.momentMin_0_OppFootOff.RHip(1)
%                 '%1.2f',    c.results.Left.momentMin_0_OppFootOff.LHip(1)
%                 % Moments à la poussée
%                 '%1.2f',    c.results.MeanLeg.momentMax_OppStrike_100.Hip(1) % Hanche Peak extension poussée
%                 '%1.2f',    c.results.Right.momentMax_OppStrike_100.RHip(1)
%                 '%1.2f',    c.results.Left.momentMax_OppStrike_100.LHip(1)
%                 '%1.2f',    c.results.MeanLeg.momentMin_OppStrike_100.Hip(1) % Hanche Peak flexion poussée
%                 '%1.2f',    c.results.Right.momentMin_OppStrike_100.RHip(1)
%                 '%1.2f',    c.results.Left.momentMin_OppStrike_100.LHip(1)
%                 '%1.2f',    c.results.MeanLeg.momentMin_OppStrike_100.Hip(2) % Hanche Peak abduction poussée
%                 '%1.2f',    c.results.Right.momentMin_OppStrike_100.RHip(2)
%                 '%1.2f',    c.results.Left.momentMin_OppStrike_100.LHip(2)
%                 '%1.2f',    c.results.MeanLeg.momentMax_OppStrike_100.Knee(1) % Genou Peak extension poussée
%                 '%1.2f',    c.results.Right.momentMax_OppStrike_100.RHip(1)
%                 '%1.2f',    c.results.Left.momentMax_OppStrike_100.LHip(1)
%                 '%1.2f',    c.results.MeanLeg.momentMin_OppStrike_100.Knee(1) % Genou Peak extension poussée
%                 '%1.2f',    c.results.Right.momentMin_OppStrike_100.RHip(1)
%                 '%1.2f',    c.results.Left.momentMin_OppStrike_100.LHip(1)
                % Force musculaire isom�trique
                '%s',       ''
                '%s',       ''
                '%s',       ''
                '%s',       ''
                '%s',       ''
                '%s',       ''
                '%s',       ''
                '%s',       ''
                '%s',       ''
                '%s',       ''
                '%s',       ''
                '%s',       ''
                '%s',       ''
                '%s',       ''
                '%s',       ''
                % EEI
                '%1.2f',    c.results.eei.fc_repos
                '%1.2f',    c.results.eei.fc_marche
                '%1.2f',    c.results.eei.v_marche
                '%1.2f',    c.results.eei.eei
                % GDI
                '%s',       ''
                '%s',       ''
                '%s',       ''
                % Param spatio-tempo
                '%1.1f'     c.results.MeanLeg.pctToeOff
                '%1.1f'     c.results.Right.pctToeOff
                '%1.1f' 	c.results.Left.pctToeOff
                '%1.1f'     c.results.MeanLeg.pctContactTalOppose
                '%1.1f'     c.results.Right.pctContactTalOppose
                '%1.1f'     c.results.Left.pctContactTalOppose
                '%1.1f'     c.results.MeanLeg.pctToeOffOppose
                '%1.1f'     c.results.Right.pctToeOffOppose
                '%1.1f'     c.results.Left.pctToeOffOppose
                '%1.1f'     c.results.MeanLeg.pctSimpleAppuie
                '%1.1f'     c.results.Right.pctSimpleAppuie
                '%1.1f'     c.results.Left.pctSimpleAppuie
                '%1.2f'     c.results.MeanLeg.distPas
                '%1.2f'     c.results.Right.distPas
                '%1.2f'     c.results.Left.distPas
                '%1.2f'     c.results.MeanLeg.distFoulee
                '%1.2f'     c.results.Right.distFoulee
                '%1.2f'     c.results.Left.distFoulee
                '%1.2f'     c.results.MeanLeg.tempsFoulee
                '%1.2f'     c.results.Right.tempsFoulee
                '%1.2f'     c.results.Left.tempsFoulee
                '%1.2f'     c.results.MeanLeg.vitFoulee
                '%1.2f'     c.results.Right.vitFoulee
                '%1.2f'     c.results.Left.vitFoulee
                % Cinématique
                % Angle à l'attaque en sagittal
                '%1.2f'     c.results.MeanLeg.angAtFoot_Strike.Thorax(1,1) 
                '%1.2f'     c.results.Right.angAtFoot_Strike.RThorax(1,1)
                '%1.2f'     c.results.Left.angAtFoot_Strike.LThorax(1,1)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Strike.Pelvis(1,1)
                '%1.2f'     c.results.Right.angAtFoot_Strike.RPelvis(1,1)
                '%1.2f'     c.results.Left.angAtFoot_Strike.LPelvis(1,1)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Strike.Knee(1,1)
                '%1.2f'     c.results.Right.angAtFoot_Strike.RKnee(1,1)
                '%1.2f'     c.results.Left.angAtFoot_Strike.LKnee(1,1)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Strike.Ankle(1,1)
                '%1.2f'     c.results.Right.angAtFoot_Strike.RAnkle(1,1)
                '%1.2f'     c.results.Left.angAtFoot_Strike.LAnkle(1,1)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Strike.FootProgress(1,1)
                '%1.2f'     c.results.Right.angAtFoot_Strike.RFootProgress(1,1)
                '%1.2f'     c.results.Left.angAtFoot_Strike.LFootProgress(1,1)
                % Angle à l'attaque en frontal
                '%1.2f'     c.results.MeanLeg.angAtFoot_Strike.Thorax(1,2) 
                '%1.2f'     c.results.Right.angAtFoot_Strike.RThorax(1,2)
                '%1.2f'     c.results.Left.angAtFoot_Strike.LThorax(1,2)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Strike.Pelvis(1,2)
                '%1.2f'     c.results.Right.angAtFoot_Strike.RPelvis(1,2)
                '%1.2f'     c.results.Left.angAtFoot_Strike.LPelvis(1,2)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Strike.Knee(1,2)
                '%1.2f'     c.results.Right.angAtFoot_Strike.RKnee(1,2)
                '%1.2f'     c.results.Left.angAtFoot_Strike.LKnee(1,2)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Strike.Ankle(1,2)
                '%1.2f'     c.results.Right.angAtFoot_Strike.RAnkle(1,2)
                '%1.2f'     c.results.Left.angAtFoot_Strike.LAnkle(1,2)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Strike.FootProgress(1,2)
                '%1.2f'     c.results.Right.angAtFoot_Strike.RFootProgress(1,2)
                '%1.2f'     c.results.Left.angAtFoot_Strike.LFootProgress(1,2)
                % Angle à l'attaque en transverse
                '%1.2f'     c.results.MeanLeg.angAtFoot_Strike.Thorax(1,3) 
                '%1.2f'     c.results.Right.angAtFoot_Strike.RThorax(1,3)
                '%1.2f'     c.results.Left.angAtFoot_Strike.LThorax(1,3)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Strike.Pelvis(1,3)
                '%1.2f'     c.results.Right.angAtFoot_Strike.RPelvis(1,3)
                '%1.2f'     c.results.Left.angAtFoot_Strike.LPelvis(1,3)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Strike.Knee(1,3)
                '%1.2f'     c.results.Right.angAtFoot_Strike.RKnee(1,3)
                '%1.2f'     c.results.Left.angAtFoot_Strike.LKnee(1,3)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Strike.Ankle(1,3)
                '%1.2f'     c.results.Right.angAtFoot_Strike.RAnkle(1,3)
                '%1.2f'     c.results.Left.angAtFoot_Strike.LAnkle(1,3)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Strike.FootProgress(1,3)
                '%1.2f'     c.results.Right.angAtFoot_Strike.RFootProgress(1,3)
                '%1.2f'     c.results.Left.angAtFoot_Strike.LFootProgress(1,3)
                
                % Angle à la poussée en sagittal
                '%1.2f'     c.results.MeanLeg.angAtFoot_Off.Thorax(1) 
                '%1.2f'     c.results.Right.angAtFoot_Off.RThorax(1)
                '%1.2f'     c.results.Left.angAtFoot_Off.LThorax(1)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Off.Pelvis(1)
                '%1.2f'     c.results.Right.angAtFoot_Off.RPelvis(1)
                '%1.2f'     c.results.Left.angAtFoot_Off.LPelvis(1)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Off.Knee(1)
                '%1.2f'     c.results.Right.angAtFoot_Off.RKnee(1)
                '%1.2f'     c.results.Left.angAtFoot_Off.LKnee(1)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Off.Ankle(1)
                '%1.2f'     c.results.Right.angAtFoot_Off.RAnkle(1)
                '%1.2f'     c.results.Left.angAtFoot_Off.LAnkle(1)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Off.FootProgress(1)
                '%1.2f'     c.results.Right.angAtFoot_Off.RFootProgress(1)
                '%1.2f'     c.results.Left.angAtFoot_Off.LFootProgress(1)
                % Angle à la poussée en frontal
                '%1.2f'     c.results.MeanLeg.angAtFoot_Off.Thorax(2) 
                '%1.2f'     c.results.Right.angAtFoot_Off.RThorax(2)
                '%1.2f'     c.results.Left.angAtFoot_Off.LThorax(2)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Off.Pelvis(2)
                '%1.2f'     c.results.Right.angAtFoot_Off.RPelvis(2)
                '%1.2f'     c.results.Left.angAtFoot_Off.LPelvis(2)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Off.Knee(2)
                '%1.2f'     c.results.Right.angAtFoot_Off.RKnee(2)
                '%1.2f'     c.results.Left.angAtFoot_Off.LKnee(2)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Off.Ankle(2)
                '%1.2f'     c.results.Right.angAtFoot_Off.RAnkle(2)
                '%1.2f'     c.results.Left.angAtFoot_Off.LAnkle(2)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Off.FootProgress(2)
                '%1.2f'     c.results.Right.angAtFoot_Off.RFootProgress(2)
                '%1.2f'     c.results.Left.angAtFoot_Off.LFootProgress(2)
                % Angle à la poussée en transverse
                '%1.2f'     c.results.MeanLeg.angAtFoot_Off.Thorax(3) 
                '%1.2f'     c.results.Right.angAtFoot_Off.RThorax(3)
                '%1.2f'     c.results.Left.angAtFoot_Off.LThorax(3)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Off.Pelvis(3)
                '%1.2f'     c.results.Right.angAtFoot_Off.RPelvis(3)
                '%1.2f'     c.results.Left.angAtFoot_Off.LPelvis(3)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Off.Knee(3)
                '%1.2f'     c.results.Right.angAtFoot_Off.RKnee(3)
                '%1.2f'     c.results.Left.angAtFoot_Off.LKnee(3)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Off.Ankle(3)
                '%1.2f'     c.results.Right.angAtFoot_Off.RAnkle(3)
                '%1.2f'     c.results.Left.angAtFoot_Off.LAnkle(3)
                '%1.2f'     c.results.MeanLeg.angAtFoot_Off.FootProgress(3)
                '%1.2f'     c.results.Right.angAtFoot_Off.RFootProgress(3)
                '%1.2f'     c.results.Left.angAtFoot_Off.LFootProgress(3)
                
                % Angle min unipodal en sagittal
                '%1.2f'     c.results.MeanLeg.angMinAtUnipodal.Thorax(1) 
                '%1.2f'     c.results.Right.angMinAtUnipodal.RThorax(1)
                '%1.2f'     c.results.Left.angMinAtUnipodal.LThorax(1)
                '%1.2f'     c.results.MeanLeg.angMinAtUnipodal.Pelvis(1)
                '%1.2f'     c.results.Right.angMinAtUnipodal.RPelvis(1)
                '%1.2f'     c.results.Left.angMinAtUnipodal.LPelvis(1)
                '%1.2f'     c.results.MeanLeg.angMinAtUnipodal.Knee(1)
                '%1.2f'     c.results.Right.angMinAtUnipodal.RKnee(1)
                '%1.2f'     c.results.Left.angMinAtUnipodal.LKnee(1)
                '%1.2f'     c.results.MeanLeg.angMinAtUnipodal.Ankle(1)
                '%1.2f'     c.results.Right.angMinAtUnipodal.RAnkle(1)
                '%1.2f'     c.results.Left.angMinAtUnipodal.LAnkle(1)
                '%1.2f'     c.results.MeanLeg.angMinAtUnipodal.FootProgress(1)
                '%1.2f'     c.results.Right.angMinAtUnipodal.RFootProgress(1)
                '%1.2f'     c.results.Left.angMinAtUnipodal.LFootProgress(1)
                % Angle min unipodal en frontal
                '%1.2f'     c.results.MeanLeg.angMinAtUnipodal.Thorax(2) 
                '%1.2f'     c.results.Right.angMinAtUnipodal.RThorax(2)
                '%1.2f'     c.results.Left.angMinAtUnipodal.LThorax(2)
                '%1.2f'     c.results.MeanLeg.angMinAtUnipodal.Pelvis(2)
                '%1.2f'     c.results.Right.angMinAtUnipodal.RPelvis(2)
                '%1.2f'     c.results.Left.angMinAtUnipodal.LPelvis(2)
                '%1.2f'     c.results.MeanLeg.angMinAtUnipodal.Knee(2)
                '%1.2f'     c.results.Right.angMinAtUnipodal.RKnee(2)
                '%1.2f'     c.results.Left.angMinAtUnipodal.LKnee(2)
                '%1.2f'     c.results.MeanLeg.angMinAtUnipodal.Ankle(2)
                '%1.2f'     c.results.Right.angMinAtUnipodal.RAnkle(2)
                '%1.2f'     c.results.Left.angMinAtUnipodal.LAnkle(2)
                '%1.2f'     c.results.MeanLeg.angMinAtUnipodal.FootProgress(2)
                '%1.2f'     c.results.Right.angMinAtUnipodal.RFootProgress(2)
                '%1.2f'     c.results.Left.angMinAtUnipodal.LFootProgress(2)
                % Angle min unipodal en transverse
                '%1.2f'     c.results.MeanLeg.angMinAtUnipodal.Thorax(3) 
                '%1.2f'     c.results.Right.angMinAtUnipodal.RThorax(3)
                '%1.2f'     c.results.Left.angMinAtUnipodal.LThorax(3)
                '%1.2f'     c.results.MeanLeg.angMinAtUnipodal.Pelvis(3)
                '%1.2f'     c.results.Right.angMinAtUnipodal.RPelvis(3)
                '%1.2f'     c.results.Left.angMinAtUnipodal.LPelvis(3)
                '%1.2f'     c.results.MeanLeg.angMinAtUnipodal.Knee(3)
                '%1.2f'     c.results.Right.angMinAtUnipodal.RKnee(3)
                '%1.2f'     c.results.Left.angMinAtUnipodal.LKnee(3)
                '%1.2f'     c.results.MeanLeg.angMinAtUnipodal.Ankle(3)
                '%1.2f'     c.results.Right.angMinAtUnipodal.RAnkle(3)
                '%1.2f'     c.results.Left.angMinAtUnipodal.LAnkle(3)
                '%1.2f'     c.results.MeanLeg.angMinAtUnipodal.FootProgress(3)
                '%1.2f'     c.results.Right.angMinAtUnipodal.RFootProgress(3)
                '%1.2f'     c.results.Left.angMinAtUnipodal.LFootProgress(3)
                
                % Angle max unipodal en sagittal
                '%1.2f'     c.results.MeanLeg.angMaxAtUnipodal.Thorax(1) 
                '%1.2f'     c.results.Right.angMaxAtUnipodal.RThorax(1)
                '%1.2f'     c.results.Left.angMaxAtUnipodal.LThorax(1)
                '%1.2f'     c.results.MeanLeg.angMaxAtUnipodal.Pelvis(1)
                '%1.2f'     c.results.Right.angMaxAtUnipodal.RPelvis(1)
                '%1.2f'     c.results.Left.angMaxAtUnipodal.LPelvis(1)
                '%1.2f'     c.results.MeanLeg.angMaxAtUnipodal.Knee(1)
                '%1.2f'     c.results.Right.angMaxAtUnipodal.RKnee(1)
                '%1.2f'     c.results.Left.angMaxAtUnipodal.LKnee(1)
                '%1.2f'     c.results.MeanLeg.angMaxAtUnipodal.Ankle(1)
                '%1.2f'     c.results.Right.angMaxAtUnipodal.RAnkle(1)
                '%1.2f'     c.results.Left.angMaxAtUnipodal.LAnkle(1)
                '%1.2f'     c.results.MeanLeg.angMaxAtUnipodal.FootProgress(1)
                '%1.2f'     c.results.Right.angMaxAtUnipodal.RFootProgress(1)
                '%1.2f'     c.results.Left.angMaxAtUnipodal.LFootProgress(1)
                % Angle max unipodal en frontal
                '%1.2f'     c.results.MeanLeg.angMaxAtUnipodal.Thorax(2) 
                '%1.2f'     c.results.Right.angMaxAtUnipodal.RThorax(2)
                '%1.2f'     c.results.Left.angMaxAtUnipodal.LThorax(2)
                '%1.2f'     c.results.MeanLeg.angMaxAtUnipodal.Pelvis(2)
                '%1.2f'     c.results.Right.angMaxAtUnipodal.RPelvis(2)
                '%1.2f'     c.results.Left.angMaxAtUnipodal.LPelvis(2)
                '%1.2f'     c.results.MeanLeg.angMaxAtUnipodal.Knee(2)
                '%1.2f'     c.results.Right.angMaxAtUnipodal.RKnee(2)
                '%1.2f'     c.results.Left.angMaxAtUnipodal.LKnee(2)
                '%1.2f'     c.results.MeanLeg.angMaxAtUnipodal.Ankle(2)
                '%1.2f'     c.results.Right.angMaxAtUnipodal.RAnkle(2)
                '%1.2f'     c.results.Left.angMaxAtUnipodal.LAnkle(2)
                '%1.2f'     c.results.MeanLeg.angMaxAtUnipodal.FootProgress(2)
                '%1.2f'     c.results.Right.angMaxAtUnipodal.RFootProgress(2)
                '%1.2f'     c.results.Left.angMaxAtUnipodal.LFootProgress(2)
                % Angle max unipodal en transverse
                '%1.2f'     c.results.MeanLeg.angMaxAtUnipodal.Thorax(3) 
                '%1.2f'     c.results.Right.angMaxAtUnipodal.RThorax(3)
                '%1.2f'     c.results.Left.angMaxAtUnipodal.LThorax(3)
                '%1.2f'     c.results.MeanLeg.angMaxAtUnipodal.Pelvis(3)
                '%1.2f'     c.results.Right.angMaxAtUnipodal.RPelvis(3)
                '%1.2f'     c.results.Left.angMaxAtUnipodal.LPelvis(3)
                '%1.2f'     c.results.MeanLeg.angMaxAtUnipodal.Knee(3)
                '%1.2f'     c.results.Right.angMaxAtUnipodal.RKnee(3)
                '%1.2f'     c.results.Left.angMaxAtUnipodal.LKnee(3)
                '%1.2f'     c.results.MeanLeg.angMaxAtUnipodal.Ankle(3)
                '%1.2f'     c.results.Right.angMaxAtUnipodal.RAnkle(3)
                '%1.2f'     c.results.Left.angMaxAtUnipodal.LAnkle(3)
                '%1.2f'     c.results.MeanLeg.angMaxAtUnipodal.FootProgress(3)
                '%1.2f'     c.results.Right.angMaxAtUnipodal.RFootProgress(3)
                '%1.2f'     c.results.Left.angMaxAtUnipodal.LFootProgress(3)
                
                % Angle min appui en sagittal
                '%1.2f'     c.results.MeanLeg.angMinAtFullStance.Thorax(1) 
                '%1.2f'     c.results.Right.angMinAtFullStance.RThorax(1)
                '%1.2f'     c.results.Left.angMinAtFullStance.LThorax(1)
                '%1.2f'     c.results.MeanLeg.angMinAtFullStance.Pelvis(1)
                '%1.2f'     c.results.Right.angMinAtFullStance.RPelvis(1)
                '%1.2f'     c.results.Left.angMinAtFullStance.LPelvis(1)
                '%1.2f'     c.results.MeanLeg.angMinAtFullStance.Knee(1)
                '%1.2f'     c.results.Right.angMinAtFullStance.RKnee(1)
                '%1.2f'     c.results.Left.angMinAtFullStance.LKnee(1)
                '%1.2f'     c.results.MeanLeg.angMinAtFullStance.Ankle(1)
                '%1.2f'     c.results.Right.angMinAtFullStance.RAnkle(1)
                '%1.2f'     c.results.Left.angMinAtFullStance.LAnkle(1)
                '%1.2f'     c.results.MeanLeg.angMinAtFullStance.FootProgress(1)
                '%1.2f'     c.results.Right.angMinAtFullStance.RFootProgress(1)
                '%1.2f'     c.results.Left.angMinAtFullStance.LFootProgress(1)
                % Angle min appui en frontal
                '%1.2f'     c.results.MeanLeg.angMinAtFullStance.Thorax(2) 
                '%1.2f'     c.results.Right.angMinAtFullStance.RThorax(2)
                '%1.2f'     c.results.Left.angMinAtFullStance.LThorax(2)
                '%1.2f'     c.results.MeanLeg.angMinAtFullStance.Pelvis(2)
                '%1.2f'     c.results.Right.angMinAtFullStance.RPelvis(2)
                '%1.2f'     c.results.Left.angMinAtFullStance.LPelvis(2)
                '%1.2f'     c.results.MeanLeg.angMinAtFullStance.Knee(2)
                '%1.2f'     c.results.Right.angMinAtFullStance.RKnee(2)
                '%1.2f'     c.results.Left.angMinAtFullStance.LKnee(2)
                '%1.2f'     c.results.MeanLeg.angMinAtFullStance.Ankle(2)
                '%1.2f'     c.results.Right.angMinAtFullStance.RAnkle(2)
                '%1.2f'     c.results.Left.angMinAtFullStance.LAnkle(2)
                '%1.2f'     c.results.MeanLeg.angMinAtFullStance.FootProgress(2)
                '%1.2f'     c.results.Right.angMinAtFullStance.RFootProgress(2)
                '%1.2f'     c.results.Left.angMinAtFullStance.LFootProgress(2)
                % Angle min appui en transverse
                '%1.2f'     c.results.MeanLeg.angMinAtFullStance.Thorax(3) 
                '%1.2f'     c.results.Right.angMinAtFullStance.RThorax(3)
                '%1.2f'     c.results.Left.angMinAtFullStance.LThorax(3)
                '%1.2f'     c.results.MeanLeg.angMinAtFullStance.Pelvis(3)
                '%1.2f'     c.results.Right.angMinAtFullStance.RPelvis(3)
                '%1.2f'     c.results.Left.angMinAtFullStance.LPelvis(3)
                '%1.2f'     c.results.MeanLeg.angMinAtFullStance.Knee(3)
                '%1.2f'     c.results.Right.angMinAtFullStance.RKnee(3)
                '%1.2f'     c.results.Left.angMinAtFullStance.LKnee(3)
                '%1.2f'     c.results.MeanLeg.angMinAtFullStance.Ankle(3)
                '%1.2f'     c.results.Right.angMinAtFullStance.RAnkle(3)
                '%1.2f'     c.results.Left.angMinAtFullStance.LAnkle(3)
                '%1.2f'     c.results.MeanLeg.angMinAtFullStance.FootProgress(3)
                '%1.2f'     c.results.Right.angMinAtFullStance.RFootProgress(3)
                '%1.2f'     c.results.Left.angMinAtFullStance.LFootProgress(3)
                
                % Angle max appui en sagittal
                '%1.2f'     c.results.MeanLeg.angMaxAtFullStance.Thorax(1) 
                '%1.2f'     c.results.Right.angMaxAtFullStance.RThorax(1)
                '%1.2f'     c.results.Left.angMaxAtFullStance.LThorax(1)
                '%1.2f'     c.results.MeanLeg.angMaxAtFullStance.Pelvis(1)
                '%1.2f'     c.results.Right.angMaxAtFullStance.RPelvis(1)
                '%1.2f'     c.results.Left.angMaxAtFullStance.LPelvis(1)
                '%1.2f'     c.results.MeanLeg.angMaxAtFullStance.Knee(1)
                '%1.2f'     c.results.Right.angMaxAtFullStance.RKnee(1)
                '%1.2f'     c.results.Left.angMaxAtFullStance.LKnee(1)
                '%1.2f'     c.results.MeanLeg.angMaxAtFullStance.Ankle(1)
                '%1.2f'     c.results.Right.angMaxAtFullStance.RAnkle(1)
                '%1.2f'     c.results.Left.angMaxAtFullStance.LAnkle(1)
                '%1.2f'     c.results.MeanLeg.angMaxAtFullStance.FootProgress(1)
                '%1.2f'     c.results.Right.angMaxAtFullStance.RFootProgress(1)
                '%1.2f'     c.results.Left.angMaxAtFullStance.LFootProgress(1)
                % Angle max appui en frontal
                '%1.2f'     c.results.MeanLeg.angMaxAtFullStance.Thorax(2) 
                '%1.2f'     c.results.Right.angMaxAtFullStance.RThorax(2)
                '%1.2f'     c.results.Left.angMaxAtFullStance.LThorax(2)
                '%1.2f'     c.results.MeanLeg.angMaxAtFullStance.Pelvis(2)
                '%1.2f'     c.results.Right.angMaxAtFullStance.RPelvis(2)
                '%1.2f'     c.results.Left.angMaxAtFullStance.LPelvis(2)
                '%1.2f'     c.results.MeanLeg.angMaxAtFullStance.Knee(2)
                '%1.2f'     c.results.Right.angMaxAtFullStance.RKnee(2)
                '%1.2f'     c.results.Left.angMaxAtFullStance.LKnee(2)
                '%1.2f'     c.results.MeanLeg.angMaxAtFullStance.Ankle(2)
                '%1.2f'     c.results.Right.angMaxAtFullStance.RAnkle(2)
                '%1.2f'     c.results.Left.angMaxAtFullStance.LAnkle(2)
                '%1.2f'     c.results.MeanLeg.angMaxAtFullStance.FootProgress(2)
                '%1.2f'     c.results.Right.angMaxAtFullStance.RFootProgress(2)
                '%1.2f'     c.results.Left.angMaxAtFullStance.LFootProgress(2)
                % Angle max appui en transverse
                '%1.2f'     c.results.MeanLeg.angMaxAtFullStance.Thorax(3) 
                '%1.2f'     c.results.Right.angMaxAtFullStance.RThorax(3)
                '%1.2f'     c.results.Left.angMaxAtFullStance.LThorax(3)
                '%1.2f'     c.results.MeanLeg.angMaxAtFullStance.Pelvis(3)
                '%1.2f'     c.results.Right.angMaxAtFullStance.RPelvis(3)
                '%1.2f'     c.results.Left.angMaxAtFullStance.LPelvis(3)
                '%1.2f'     c.results.MeanLeg.angMaxAtFullStance.Knee(3)
                '%1.2f'     c.results.Right.angMaxAtFullStance.RKnee(3)
                '%1.2f'     c.results.Left.angMaxAtFullStance.LKnee(3)
                '%1.2f'     c.results.MeanLeg.angMaxAtFullStance.Ankle(3)
                '%1.2f'     c.results.Right.angMaxAtFullStance.RAnkle(3)
                '%1.2f'     c.results.Left.angMaxAtFullStance.LAnkle(3)
                '%1.2f'     c.results.MeanLeg.angMaxAtFullStance.FootProgress(3)
                '%1.2f'     c.results.Right.angMaxAtFullStance.RFootProgress(3)
                '%1.2f'     c.results.Left.angMaxAtFullStance.LFootProgress(3)
                
                % Angle RoM unipodal en sagittal
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtUnipodal.Thorax(1) 
                '%1.2f'     c.results.Right.angRangeMotionAtUnipodal.RThorax(1)
                '%1.2f'     c.results.Left.angRangeMotionAtUnipodal.LThorax(1)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtUnipodal.Pelvis(1)
                '%1.2f'     c.results.Right.angRangeMotionAtUnipodal.RPelvis(1)
                '%1.2f'     c.results.Left.angRangeMotionAtUnipodal.LPelvis(1)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtUnipodal.Knee(1)
                '%1.2f'     c.results.Right.angRangeMotionAtUnipodal.RKnee(1)
                '%1.2f'     c.results.Left.angRangeMotionAtUnipodal.LKnee(1)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtUnipodal.Ankle(1)
                '%1.2f'     c.results.Right.angRangeMotionAtUnipodal.RAnkle(1)
                '%1.2f'     c.results.Left.angRangeMotionAtUnipodal.LAnkle(1)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtUnipodal.FootProgress(1)
                '%1.2f'     c.results.Right.angRangeMotionAtUnipodal.RFootProgress(1)
                '%1.2f'     c.results.Left.angRangeMotionAtUnipodal.LFootProgress(1)
                % Angle RoM unipodal en frontal
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtUnipodal.Thorax(2) 
                '%1.2f'     c.results.Right.angRangeMotionAtUnipodal.RThorax(2)
                '%1.2f'     c.results.Left.angRangeMotionAtUnipodal.LThorax(2)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtUnipodal.Pelvis(2)
                '%1.2f'     c.results.Right.angRangeMotionAtUnipodal.RPelvis(2)
                '%1.2f'     c.results.Left.angRangeMotionAtUnipodal.LPelvis(2)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtUnipodal.Knee(2)
                '%1.2f'     c.results.Right.angRangeMotionAtUnipodal.RKnee(2)
                '%1.2f'     c.results.Left.angRangeMotionAtUnipodal.LKnee(2)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtUnipodal.Ankle(2)
                '%1.2f'     c.results.Right.angRangeMotionAtUnipodal.RAnkle(2)
                '%1.2f'     c.results.Left.angRangeMotionAtUnipodal.LAnkle(2)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtUnipodal.FootProgress(2)
                '%1.2f'     c.results.Right.angRangeMotionAtUnipodal.RFootProgress(2)
                '%1.2f'     c.results.Left.angRangeMotionAtUnipodal.LFootProgress(2)
                % Angle RoM unipodal en transverse
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtUnipodal.Thorax(3) 
                '%1.2f'     c.results.Right.angRangeMotionAtUnipodal.RThorax(3)
                '%1.2f'     c.results.Left.angRangeMotionAtUnipodal.LThorax(3)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtUnipodal.Pelvis(3)
                '%1.2f'     c.results.Right.angRangeMotionAtUnipodal.RPelvis(3)
                '%1.2f'     c.results.Left.angRangeMotionAtUnipodal.LPelvis(3)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtUnipodal.Knee(3)
                '%1.2f'     c.results.Right.angRangeMotionAtUnipodal.RKnee(3)
                '%1.2f'     c.results.Left.angRangeMotionAtUnipodal.LKnee(3)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtUnipodal.Ankle(3)
                '%1.2f'     c.results.Right.angRangeMotionAtUnipodal.RAnkle(3)
                '%1.2f'     c.results.Left.angRangeMotionAtUnipodal.LAnkle(3)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtUnipodal.FootProgress(3)
                '%1.2f'     c.results.Right.angRangeMotionAtUnipodal.RFootProgress(3)
                '%1.2f'     c.results.Left.angRangeMotionAtUnipodal.LFootProgress(3)
                
                % Angle RoM appui en sagittal
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtFullStance.Thorax(1) 
                '%1.2f'     c.results.Right.angRangeMotionAtFullStance.RThorax(1)
                '%1.2f'     c.results.Left.angRangeMotionAtFullStance.LThorax(1)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtFullStance.Pelvis(1)
                '%1.2f'     c.results.Right.angRangeMotionAtFullStance.RPelvis(1)
                '%1.2f'     c.results.Left.angRangeMotionAtFullStance.LPelvis(1)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtFullStance.Knee(1)
                '%1.2f'     c.results.Right.angRangeMotionAtFullStance.RKnee(1)
                '%1.2f'     c.results.Left.angRangeMotionAtFullStance.LKnee(1)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtFullStance.Ankle(1)
                '%1.2f'     c.results.Right.angRangeMotionAtFullStance.RAnkle(1)
                '%1.2f'     c.results.Left.angRangeMotionAtFullStance.LAnkle(1)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtFullStance.FootProgress(1)
                '%1.2f'     c.results.Right.angRangeMotionAtFullStance.RFootProgress(1)
                '%1.2f'     c.results.Left.angRangeMotionAtFullStance.LFootProgress(1)
                % Angle RoM appui en frontal
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtFullStance.Thorax(2) 
                '%1.2f'     c.results.Right.angRangeMotionAtFullStance.RThorax(2)
                '%1.2f'     c.results.Left.angRangeMotionAtFullStance.LThorax(2)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtFullStance.Pelvis(2)
                '%1.2f'     c.results.Right.angRangeMotionAtFullStance.RPelvis(2)
                '%1.2f'     c.results.Left.angRangeMotionAtFullStance.LPelvis(2)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtFullStance.Knee(2)
                '%1.2f'     c.results.Right.angRangeMotionAtFullStance.RKnee(2)
                '%1.2f'     c.results.Left.angRangeMotionAtFullStance.LKnee(2)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtFullStance.Ankle(2)
                '%1.2f'     c.results.Right.angRangeMotionAtFullStance.RAnkle(2)
                '%1.2f'     c.results.Left.angRangeMotionAtFullStance.LAnkle(2)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtFullStance.FootProgress(2)
                '%1.2f'     c.results.Right.angRangeMotionAtFullStance.RFootProgress(2)
                '%1.2f'     c.results.Left.angRangeMotionAtFullStance.LFootProgress(2)
                % Angle RoM appui en transverse
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtFullStance.Thorax(3) 
                '%1.2f'     c.results.Right.angRangeMotionAtFullStance.RThorax(3)
                '%1.2f'     c.results.Left.angRangeMotionAtFullStance.LThorax(3)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtFullStance.Pelvis(3)
                '%1.2f'     c.results.Right.angRangeMotionAtFullStance.RPelvis(3)
                '%1.2f'     c.results.Left.angRangeMotionAtFullStance.LPelvis(3)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtFullStance.Knee(3)
                '%1.2f'     c.results.Right.angRangeMotionAtFullStance.RKnee(3)
                '%1.2f'     c.results.Left.angRangeMotionAtFullStance.LKnee(3)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtFullStance.Ankle(3)
                '%1.2f'     c.results.Right.angRangeMotionAtFullStance.RAnkle(3)
                '%1.2f'     c.results.Left.angRangeMotionAtFullStance.LAnkle(3)
                '%1.2f'     c.results.MeanLeg.angRangeMotionAtFullStance.FootProgress(3)
                '%1.2f'     c.results.Right.angRangeMotionAtFullStance.RFootProgress(3)
                '%1.2f'     c.results.Left.angRangeMotionAtFullStance.LFootProgress(3)
                
                % Angle mean unipodal en sagittal
                '%1.2f'     c.results.MeanLeg.angMeanAtUnipodal.Thorax(1) 
                '%1.2f'     c.results.Right.angMeanAtUnipodal.RThorax(1)
                '%1.2f'     c.results.Left.angMeanAtUnipodal.LThorax(1)
                '%1.2f'     c.results.MeanLeg.angMeanAtUnipodal.Pelvis(1)
                '%1.2f'     c.results.Right.angMeanAtUnipodal.RPelvis(1)
                '%1.2f'     c.results.Left.angMeanAtUnipodal.LPelvis(1)
                '%1.2f'     c.results.MeanLeg.angMeanAtUnipodal.Knee(1)
                '%1.2f'     c.results.Right.angMeanAtUnipodal.RKnee(1)
                '%1.2f'     c.results.Left.angMeanAtUnipodal.LKnee(1)
                '%1.2f'     c.results.MeanLeg.angMeanAtUnipodal.Ankle(1)
                '%1.2f'     c.results.Right.angMeanAtUnipodal.RAnkle(1)
                '%1.2f'     c.results.Left.angMeanAtUnipodal.LAnkle(1)
                '%1.2f'     c.results.MeanLeg.angMeanAtUnipodal.FootProgress(1)
                '%1.2f'     c.results.Right.angMeanAtUnipodal.RFootProgress(1)
                '%1.2f'     c.results.Left.angMeanAtUnipodal.LFootProgress(1)
                % Angle mean unipodal en frontal
                '%1.2f'     c.results.MeanLeg.angMeanAtUnipodal.Thorax(2) 
                '%1.2f'     c.results.Right.angMeanAtUnipodal.RThorax(2)
                '%1.2f'     c.results.Left.angMeanAtUnipodal.LThorax(2)
                '%1.2f'     c.results.MeanLeg.angMeanAtUnipodal.Pelvis(2)
                '%1.2f'     c.results.Right.angMeanAtUnipodal.RPelvis(2)
                '%1.2f'     c.results.Left.angMeanAtUnipodal.LPelvis(2)
                '%1.2f'     c.results.MeanLeg.angMeanAtUnipodal.Knee(2)
                '%1.2f'     c.results.Right.angMeanAtUnipodal.RKnee(2)
                '%1.2f'     c.results.Left.angMeanAtUnipodal.LKnee(2)
                '%1.2f'     c.results.MeanLeg.angMeanAtUnipodal.Ankle(2)
                '%1.2f'     c.results.Right.angMeanAtUnipodal.RAnkle(2)
                '%1.2f'     c.results.Left.angMeanAtUnipodal.LAnkle(2)
                '%1.2f'     c.results.MeanLeg.angMeanAtUnipodal.FootProgress(2)
                '%1.2f'     c.results.Right.angMeanAtUnipodal.RFootProgress(2)
                '%1.2f'     c.results.Left.angMeanAtUnipodal.LFootProgress(2)
                % Angle mean unipodal en transverse
                '%1.2f'     c.results.MeanLeg.angMeanAtUnipodal.Thorax(3) 
                '%1.2f'     c.results.Right.angMeanAtUnipodal.RThorax(3)
                '%1.2f'     c.results.Left.angMeanAtUnipodal.LThorax(3)
                '%1.2f'     c.results.MeanLeg.angMeanAtUnipodal.Pelvis(3)
                '%1.2f'     c.results.Right.angMeanAtUnipodal.RPelvis(3)
                '%1.2f'     c.results.Left.angMeanAtUnipodal.LPelvis(3)
                '%1.2f'     c.results.MeanLeg.angMeanAtUnipodal.Knee(3)
                '%1.2f'     c.results.Right.angMeanAtUnipodal.RKnee(3)
                '%1.2f'     c.results.Left.angMeanAtUnipodal.LKnee(3)
                '%1.2f'     c.results.MeanLeg.angMeanAtUnipodal.Ankle(3)
                '%1.2f'     c.results.Right.angMeanAtUnipodal.RAnkle(3)
                '%1.2f'     c.results.Left.angMeanAtUnipodal.LAnkle(3)
                '%1.2f'     c.results.MeanLeg.angMeanAtUnipodal.FootProgress(3)
                '%1.2f'     c.results.Right.angMeanAtUnipodal.RFootProgress(3)
                '%1.2f'     c.results.Left.angMeanAtUnipodal.LFootProgress(3)
                
                % Angle mean appui en sagittal
                '%1.2f'     c.results.MeanLeg.angMeanAtFullStance.Thorax(1) 
                '%1.2f'     c.results.Right.angMeanAtFullStance.RThorax(1)
                '%1.2f'     c.results.Left.angMeanAtFullStance.LThorax(1)
                '%1.2f'     c.results.MeanLeg.angMeanAtFullStance.Pelvis(1)
                '%1.2f'     c.results.Right.angMeanAtFullStance.RPelvis(1)
                '%1.2f'     c.results.Left.angMeanAtFullStance.LPelvis(1)
                '%1.2f'     c.results.MeanLeg.angMeanAtFullStance.Knee(1)
                '%1.2f'     c.results.Right.angMeanAtFullStance.RKnee(1)
                '%1.2f'     c.results.Left.angMeanAtFullStance.LKnee(1)
                '%1.2f'     c.results.MeanLeg.angMeanAtFullStance.Ankle(1)
                '%1.2f'     c.results.Right.angMeanAtFullStance.RAnkle(1)
                '%1.2f'     c.results.Left.angMeanAtFullStance.LAnkle(1)
                '%1.2f'     c.results.MeanLeg.angMeanAtFullStance.FootProgress(1)
                '%1.2f'     c.results.Right.angMeanAtFullStance.RFootProgress(1)
                '%1.2f'     c.results.Left.angMeanAtFullStance.LFootProgress(1)
                % Angle mean appui en frontal
                '%1.2f'     c.results.MeanLeg.angMeanAtFullStance.Thorax(2) 
                '%1.2f'     c.results.Right.angMeanAtFullStance.RThorax(2)
                '%1.2f'     c.results.Left.angMeanAtFullStance.LThorax(2)
                '%1.2f'     c.results.MeanLeg.angMeanAtFullStance.Pelvis(2)
                '%1.2f'     c.results.Right.angMeanAtFullStance.RPelvis(2)
                '%1.2f'     c.results.Left.angMeanAtFullStance.LPelvis(2)
                '%1.2f'     c.results.MeanLeg.angMeanAtFullStance.Knee(2)
                '%1.2f'     c.results.Right.angMeanAtFullStance.RKnee(2)
                '%1.2f'     c.results.Left.angMeanAtFullStance.LKnee(2)
                '%1.2f'     c.results.MeanLeg.angMeanAtFullStance.Ankle(2)
                '%1.2f'     c.results.Right.angMeanAtFullStance.RAnkle(2)
                '%1.2f'     c.results.Left.angMeanAtFullStance.LAnkle(2)
                '%1.2f'     c.results.MeanLeg.angMeanAtFullStance.FootProgress(2)
                '%1.2f'     c.results.Right.angMeanAtFullStance.RFootProgress(2)
                '%1.2f'     c.results.Left.angMeanAtFullStance.LFootProgress(2)
                % Angle mean appui en transverse
                '%1.2f'     c.results.MeanLeg.angMeanAtFullStance.Thorax(3) 
                '%1.2f'     c.results.Right.angMeanAtFullStance.RThorax(3)
                '%1.2f'     c.results.Left.angMeanAtFullStance.LThorax(3)
                '%1.2f'     c.results.MeanLeg.angMeanAtFullStance.Pelvis(3)
                '%1.2f'     c.results.Right.angMeanAtFullStance.RPelvis(3)
                '%1.2f'     c.results.Left.angMeanAtFullStance.LPelvis(3)
                '%1.2f'     c.results.MeanLeg.angMeanAtFullStance.Knee(3)
                '%1.2f'     c.results.Right.angMeanAtFullStance.RKnee(3)
                '%1.2f'     c.results.Left.angMeanAtFullStance.LKnee(3)
                '%1.2f'     c.results.MeanLeg.angMeanAtFullStance.Ankle(3)
                '%1.2f'     c.results.Right.angMeanAtFullStance.RAnkle(3)
                '%1.2f'     c.results.Left.angMeanAtFullStance.LAnkle(3)
                '%1.2f'     c.results.MeanLeg.angMeanAtFullStance.FootProgress(3)
                '%1.2f'     c.results.Right.angMeanAtFullStance.RFootProgress(3)
                '%1.2f'     c.results.Left.angMeanAtFullStance.LFootProgress(3)
                
                % Vitesse de certaines articulations en sagittal
                '%1.2f'     c.results.MeanLeg.angVelMax_20_100.Hip(1)
                '%1.2f'     c.results.Right.angVelMax_20_100.RHip(1)
                '%1.2f'     c.results.Left.angVelMax_20_100.LHip(1)
                '%1.2f'     c.results.MeanLeg.angVelMin_20_100.Hip(1)
                '%1.2f'     c.results.Right.angVelMin_20_100.RHip(1)
                '%1.2f'     c.results.Left.angVelMin_20_100.LHip(1)
                '%1.2f'     c.results.MeanLeg.angVelMax_PushOff_100.Knee(1)
                '%1.2f'     c.results.Right.angVelMax_PushOff_100.RKnee(1)
                '%1.2f'     c.results.Left.angVelMax_PushOff_100.LKnee(1)
                '%1.2f'     c.results.MeanLeg.angVelMin_PushOff_100.Knee(1)
                '%1.2f'     c.results.Right.angVelMin_PushOff_100.RKnee(1)
                '%1.2f'     c.results.Left.angVelMin_PushOff_100.LKnee(1)
                '%1.2f'     c.results.MeanLeg.angVelMax_PushOff_100.Ankle(1)
                '%1.2f'     c.results.Right.angVelMax_PushOff_100.RAnkle(1)
                '%1.2f'     c.results.Left.angVelMax_PushOff_100.LAnkle(1)
                '%1.2f'     c.results.MeanLeg.angVelMin_PushOff_100.Ankle(1)
                '%1.2f'     c.results.Right.angVelMin_PushOff_100.RAnkle(1)
                '%1.2f'     c.results.Left.angVelMin_PushOff_100.LAnkle(1)
                % Vitesse de certaines articulations en frontal
                '%1.2f'     c.results.MeanLeg.angVelMax_20_100.Hip(2)
                '%1.2f'     c.results.Right.angVelMax_20_100.RHip(2)
                '%1.2f'     c.results.Left.angVelMax_20_100.LHip(2)
                '%1.2f'     c.results.MeanLeg.angVelMin_20_100.Hip(2)
                '%1.2f'     c.results.Right.angVelMin_20_100.RHip(2)
                '%1.2f'     c.results.Left.angVelMin_20_100.LHip(2)
                '%1.2f'     c.results.MeanLeg.angVelMax_PushOff_100.Knee(2)
                '%1.2f'     c.results.Right.angVelMax_PushOff_100.RKnee(2)
                '%1.2f'     c.results.Left.angVelMax_PushOff_100.LKnee(2)
                '%1.2f'     c.results.MeanLeg.angVelMin_PushOff_100.Knee(2)
                '%1.2f'     c.results.Right.angVelMin_PushOff_100.RKnee(2)
                '%1.2f'     c.results.Left.angVelMin_PushOff_100.LKnee(2)
                '%1.2f'     c.results.MeanLeg.angVelMax_PushOff_100.Ankle(2)
                '%1.2f'     c.results.Right.angVelMax_PushOff_100.RAnkle(2)
                '%1.2f'     c.results.Left.angVelMax_PushOff_100.LAnkle(2)
                '%1.2f'     c.results.MeanLeg.angVelMin_PushOff_100.Ankle(2)
                '%1.2f'     c.results.Right.angVelMin_PushOff_100.RAnkle(2)
                '%1.2f'     c.results.Left.angVelMin_PushOff_100.LAnkle(2)
                % Vitesse de certaines articulations en transverse
                '%1.2f'     c.results.MeanLeg.angVelMax_20_100.Hip(3)
                '%1.2f'     c.results.Right.angVelMax_20_100.RHip(3)
                '%1.2f'     c.results.Left.angVelMax_20_100.LHip(3)
                '%1.2f'     c.results.MeanLeg.angVelMin_20_100.Hip(3)
                '%1.2f'     c.results.Right.angVelMin_20_100.RHip(3)
                '%1.2f'     c.results.Left.angVelMin_20_100.LHip(3)
                '%1.2f'     c.results.MeanLeg.angVelMax_PushOff_100.Knee(3)
                '%1.2f'     c.results.Right.angVelMax_PushOff_100.RKnee(3)
                '%1.2f'     c.results.Left.angVelMax_PushOff_100.LKnee(3)
                '%1.2f'     c.results.MeanLeg.angVelMin_PushOff_100.Knee(3)
                '%1.2f'     c.results.Right.angVelMin_PushOff_100.RKnee(3)
                '%1.2f'     c.results.Left.angVelMin_PushOff_100.LKnee(3)
                '%1.2f'     c.results.MeanLeg.angVelMax_PushOff_100.Ankle(3)
                '%1.2f'     c.results.Right.angVelMax_PushOff_100.RAnkle(3)
                '%1.2f'     c.results.Left.angVelMax_PushOff_100.LAnkle(3)
                '%1.2f'     c.results.MeanLeg.angVelMin_PushOff_100.Ankle(3)
                '%1.2f'     c.results.Right.angVelMin_PushOff_100.RAnkle(3)
                '%1.2f'     c.results.Left.angVelMin_PushOff_100.LAnkle(3)
                
                % Cinématique du CoM
                '%1.1f'     c.results.MeanLeg.comRangeHeight
                '%1.1f'     c.results.Right.comRangeHeight
                '%1.1f'     c.results.Left.comRangeHeight
                '%1.1f'     c.results.MeanLeg.comMinHeight
                '%1.1f'     c.results.Right.comMinHeight
                '%1.1f'     c.results.Left.comMinHeight
                '%1.1f'     c.results.MeanLeg.comMaxHeight
                '%1.1f'     c.results.Right.comMaxHeight
                '%1.1f'     c.results.Left.comMaxHeight
                '%1.2f'     c.results.MeanLeg.comRangeML
                '%1.2f'     c.results.Right.comRangeML
                '%1.2f'     c.results.Left.comRangeML
                '%s'        ''
                '%s'        ''
                '%s'        ''
                '%s'        ''
                '%s'        ''
                '%s'        ''
                
                % Vitesse min du CoM en médiolatéral
                '%1.2f'     c.results.MeanLeg.comVitesseMin(1)
                '%1.2f'     c.results.Right.comVitesseMin(1)
                '%1.2f'     c.results.Left.comVitesseMin(1)
                % Vitesse min du CoM en frontal
                '%1.2f'     c.results.MeanLeg.comVitesseMin(2)
                '%1.2f'     c.results.Right.comVitesseMin(2)
                '%1.2f'     c.results.Left.comVitesseMin(2)
                % Vitesse min du CoM en transverse
                '%1.2f'     c.results.MeanLeg.comVitesseMin(3)
                '%1.2f'     c.results.Right.comVitesseMin(3)
                '%1.2f'     c.results.Left.comVitesseMin(3)
                % Vitesse max du CoM en médiolatéral
                '%1.2f'     c.results.MeanLeg.comVitesseMax(1)
                '%1.2f'     c.results.Right.comVitesseMax(1)
                '%1.2f'     c.results.Left.comVitesseMax(1)
                % Vitesse max du CoM en frontal
                '%1.2f'     c.results.MeanLeg.comVitesseMax(2)
                '%1.2f'     c.results.Right.comVitesseMax(2)
                '%1.2f'     c.results.Left.comVitesseMax(2)
                % Vitesse max du CoM en transverse
                '%1.2f'     c.results.MeanLeg.comVitesseMax(3)
                '%1.2f'     c.results.Right.comVitesseMax(3)
                '%1.2f'     c.results.Left.comVitesseMax(3)
                
                % Accélération min du CoM en médiolatéral
                '%1.2f'     c.results.MeanLeg.comAccelerationMin(1)
                '%1.2f'     c.results.Right.comAccelerationMin(1)
                '%1.2f'     c.results.Left.comAccelerationMin(1)
                % Accélération min du CoM en frontal
                '%1.2f'     c.results.MeanLeg.comAccelerationMin(2)
                '%1.2f'     c.results.Right.comAccelerationMin(2)
                '%1.2f'     c.results.Left.comAccelerationMin(2)
                % Accélération min du CoM en transverse
                '%1.2f'     c.results.MeanLeg.comAccelerationMin(3)
                '%1.2f'     c.results.Right.comAccelerationMin(3)
                '%1.2f'     c.results.Left.comAccelerationMin(3)
                % Accélération max du CoM en médiolatéral
                '%1.2f'     c.results.MeanLeg.comAccelerationMax(1)
                '%1.2f'     c.results.Right.comAccelerationMax(1)
                '%1.2f'     c.results.Left.comAccelerationMax(1)
                % Accélération max du CoM en frontal
                '%1.2f'     c.results.MeanLeg.comAccelerationMax(2)
                '%1.2f'     c.results.Right.comAccelerationMax(2)
                '%1.2f'     c.results.Left.comAccelerationMax(2)
                % Accélération max du CoM en transverse
                '%1.2f'     c.results.MeanLeg.comAccelerationMax(3)
                '%1.2f'     c.results.Right.comAccelerationMax(3)
                '%1.2f'     c.results.Left.comAccelerationMax(3)
                
                % Secousse min du CoM en médiolatéral
                '%1.2f'     c.results.MeanLeg.comSecousseMin(1)
                '%1.2f'     c.results.Right.comSecousseMin(1)
                '%1.2f'     c.results.Left.comSecousseMin(1)
                % Secousse min du CoM en frontal
                '%1.2f'     c.results.MeanLeg.comSecousseMin(2)
                '%1.2f'     c.results.Right.comSecousseMin(2)
                '%1.2f'     c.results.Left.comSecousseMin(2)
                % Secousse min du CoM en transverse
                '%1.2f'     c.results.MeanLeg.comSecousseMin(3)
                '%1.2f'     c.results.Right.comSecousseMin(3)
                '%1.2f'     c.results.Left.comSecousseMin(3)
                % Secousse max du CoM en médiolatéral
                '%1.2f'     c.results.MeanLeg.comSecousseMax(1)
                '%1.2f'     c.results.Right.comSecousseMax(1)
                '%1.2f'     c.results.Left.comSecousseMax(1)
                % Secousse max du CoM en frontal
                '%1.2f'     c.results.MeanLeg.comSecousseMax(2)
                '%1.2f'     c.results.Right.comSecousseMax(2)
                '%1.2f'     c.results.Left.comSecousseMax(2)
                % Secousse max du CoM en transverse
                '%1.2f'     c.results.MeanLeg.comSecousseMax(3)
                '%1.2f'     c.results.Right.comSecousseMax(3)
                '%1.2f'     c.results.Left.comSecousseMax(3)
                
                % Couples articulaires au contact talon en sagittal
                '%1.2f'     c.results.MeanLeg.momentMax_0_OppFootOff.Hip(1)
                '%1.2f'     c.results.Right.momentMax_0_OppFootOff.RHip(1)
                '%1.2f'     c.results.Left.momentMax_0_OppFootOff.LHip(1)
                '%1.2f'     c.results.MeanLeg.momentMin_0_OppFootOff.Hip(1)
                '%1.2f'     c.results.Right.momentMin_0_OppFootOff.RHip(1)
                '%1.2f'     c.results.Left.momentMin_0_OppFootOff.LHip(1)
                '%1.2f'     c.results.MeanLeg.momentMax_0_OppFootOff.Knee(1)
                '%1.2f'     c.results.Right.momentMax_0_OppFootOff.RKnee(1)
                '%1.2f'     c.results.Left.momentMax_0_OppFootOff.LKnee(1)
                '%1.2f'     c.results.MeanLeg.momentMin_0_OppFootOff.Knee(1)
                '%1.2f'     c.results.Right.momentMin_0_OppFootOff.RKnee(1)
                '%1.2f'     c.results.Left.momentMin_0_OppFootOff.LKnee(1)
                '%1.2f'     c.results.MeanLeg.momentMax_0_OppFootOff.Ankle(1)
                '%1.2f'     c.results.Right.momentMax_0_OppFootOff.RAnkle(1)
                '%1.2f'     c.results.Left.momentMax_0_OppFootOff.LAnkle(1)
                '%1.2f'     c.results.MeanLeg.momentMin_0_OppFootOff.Ankle(1)
                '%1.2f'     c.results.Right.momentMin_0_OppFootOff.RAnkle(1)
                '%1.2f'     c.results.Left.momentMin_0_OppFootOff.LAnkle(1)
                % Couples articulaires au contact talon en sagittal
                '%1.2f'     c.results.MeanLeg.momentMax_0_OppFootOff.Hip(2)
                '%1.2f'     c.results.Right.momentMax_0_OppFootOff.RHip(2)
                '%1.2f'     c.results.Left.momentMax_0_OppFootOff.LHip(2)
                '%1.2f'     c.results.MeanLeg.momentMin_0_OppFootOff.Hip(2)
                '%1.2f'     c.results.Right.momentMin_0_OppFootOff.RHip(2)
                '%1.2f'     c.results.Left.momentMin_0_OppFootOff.LHip(2)
                '%1.2f'     c.results.MeanLeg.momentMax_0_OppFootOff.Knee(2)
                '%1.2f'     c.results.Right.momentMax_0_OppFootOff.RKnee(2)
                '%1.2f'     c.results.Left.momentMax_0_OppFootOff.LKnee(2)
                '%1.2f'     c.results.MeanLeg.momentMin_0_OppFootOff.Knee(2)
                '%1.2f'     c.results.Right.momentMin_0_OppFootOff.RKnee(2)
                '%1.2f'     c.results.Left.momentMin_0_OppFootOff.LKnee(2)
                '%1.2f'     c.results.MeanLeg.momentMax_0_OppFootOff.Ankle(2)
                '%1.2f'     c.results.Right.momentMax_0_OppFootOff.RAnkle(2)
                '%1.2f'     c.results.Left.momentMax_0_OppFootOff.LAnkle(2)
                '%1.2f'     c.results.MeanLeg.momentMin_0_OppFootOff.Ankle(2)
                '%1.2f'     c.results.Right.momentMin_0_OppFootOff.RAnkle(2)
                '%1.2f'     c.results.Left.momentMin_0_OppFootOff.LAnkle(2)
                % Couples articulaires au contact talon en sagittal
                '%1.2f'     c.results.MeanLeg.momentMax_0_OppFootOff.Hip(3)
                '%1.2f'     c.results.Right.momentMax_0_OppFootOff.RHip(3)
                '%1.2f'     c.results.Left.momentMax_0_OppFootOff.LHip(3)
                '%1.2f'     c.results.MeanLeg.momentMin_0_OppFootOff.Hip(3)
                '%1.2f'     c.results.Right.momentMin_0_OppFootOff.RHip(3)
                '%1.2f'     c.results.Left.momentMin_0_OppFootOff.LHip(3)
                '%1.2f'     c.results.MeanLeg.momentMax_0_OppFootOff.Knee(3)
                '%1.2f'     c.results.Right.momentMax_0_OppFootOff.RKnee(3)
                '%1.2f'     c.results.Left.momentMax_0_OppFootOff.LKnee(3)
                '%1.2f'     c.results.MeanLeg.momentMin_0_OppFootOff.Knee(3)
                '%1.2f'     c.results.Right.momentMin_0_OppFootOff.RKnee(3)
                '%1.2f'     c.results.Left.momentMin_0_OppFootOff.LKnee(3)
                '%1.2f'     c.results.MeanLeg.momentMax_0_OppFootOff.Ankle(3)
                '%1.2f'     c.results.Right.momentMax_0_OppFootOff.RAnkle(3)
                '%1.2f'     c.results.Left.momentMax_0_OppFootOff.LAnkle(3)
                '%1.2f'     c.results.MeanLeg.momentMin_0_OppFootOff.Ankle(3)
                '%1.2f'     c.results.Right.momentMin_0_OppFootOff.RAnkle(3)
                '%1.2f'     c.results.Left.momentMin_0_OppFootOff.LAnkle(3)
                
                % Couples articulaires à la poussée en sagittal
                '%1.2f'     c.results.MeanLeg.momentMax_OppStrike_100.Hip(1)
                '%1.2f'     c.results.Right.momentMax_OppStrike_100.RHip(1)
                '%1.2f'     c.results.Left.momentMax_OppStrike_100.LHip(1)
                '%1.2f'     c.results.MeanLeg.momentMin_OppStrike_100.Hip(1)
                '%1.2f'     c.results.Right.momentMin_OppStrike_100.RHip(1)
                '%1.2f'     c.results.Left.momentMin_OppStrike_100.LHip(1)
                '%1.2f'     c.results.MeanLeg.momentMax_OppStrike_100.Knee(1)
                '%1.2f'     c.results.Right.momentMax_OppStrike_100.RKnee(1)
                '%1.2f'     c.results.Left.momentMax_OppStrike_100.LKnee(1)
                '%1.2f'     c.results.MeanLeg.momentMin_OppStrike_100.Knee(1)
                '%1.2f'     c.results.Right.momentMin_OppStrike_100.RKnee(1)
                '%1.2f'     c.results.Left.momentMin_OppStrike_100.LKnee(1)
                '%1.2f'     c.results.MeanLeg.momentMax_OppStrike_100.Ankle(1)
                '%1.2f'     c.results.Right.momentMax_OppStrike_100.RAnkle(1)
                '%1.2f'     c.results.Left.momentMax_OppStrike_100.LAnkle(1)
                '%1.2f'     c.results.MeanLeg.momentMin_OppStrike_100.Ankle(1)
                '%1.2f'     c.results.Right.momentMin_OppStrike_100.RAnkle(1)
                '%1.2f'     c.results.Left.momentMin_OppStrike_100.LAnkle(1)
                % Couples articulaires à la poussée talon en sagittal
                '%1.2f'     c.results.MeanLeg.momentMax_OppStrike_100.Hip(2)
                '%1.2f'     c.results.Right.momentMax_OppStrike_100.RHip(2)
                '%1.2f'     c.results.Left.momentMax_OppStrike_100.LHip(2)
                '%1.2f'     c.results.MeanLeg.momentMin_OppStrike_100.Hip(2)
                '%1.2f'     c.results.Right.momentMin_OppStrike_100.RHip(2)
                '%1.2f'     c.results.Left.momentMin_OppStrike_100.LHip(2)
                '%1.2f'     c.results.MeanLeg.momentMax_OppStrike_100.Knee(2)
                '%1.2f'     c.results.Right.momentMax_OppStrike_100.RKnee(2)
                '%1.2f'     c.results.Left.momentMax_OppStrike_100.LKnee(2)
                '%1.2f'     c.results.MeanLeg.momentMin_OppStrike_100.Knee(2)
                '%1.2f'     c.results.Right.momentMin_OppStrike_100.RKnee(2)
                '%1.2f'     c.results.Left.momentMin_OppStrike_100.LKnee(2)
                '%1.2f'     c.results.MeanLeg.momentMax_OppStrike_100.Ankle(2)
                '%1.2f'     c.results.Right.momentMax_OppStrike_100.RAnkle(2)
                '%1.2f'     c.results.Left.momentMax_OppStrike_100.LAnkle(2)
                '%1.2f'     c.results.MeanLeg.momentMin_OppStrike_100.Ankle(2)
                '%1.2f'     c.results.Right.momentMin_OppStrike_100.RAnkle(2)
                '%1.2f'     c.results.Left.momentMin_OppStrike_100.LAnkle(2)
                % Couples articulaires à la poussée talon en sagittal
                '%1.2f'     c.results.MeanLeg.momentMax_OppStrike_100.Hip(3)
                '%1.2f'     c.results.Right.momentMax_OppStrike_100.RHip(3)
                '%1.2f'     c.results.Left.momentMax_OppStrike_100.LHip(3)
                '%1.2f'     c.results.MeanLeg.momentMin_OppStrike_100.Hip(3)
                '%1.2f'     c.results.Right.momentMin_OppStrike_100.RHip(3)
                '%1.2f'     c.results.Left.momentMin_OppStrike_100.LHip(3)
                '%1.2f'     c.results.MeanLeg.momentMax_OppStrike_100.Knee(3)
                '%1.2f'     c.results.Right.momentMax_OppStrike_100.RKnee(3)
                '%1.2f'     c.results.Left.momentMax_OppStrike_100.LKnee(3)
                '%1.2f'     c.results.MeanLeg.momentMin_OppStrike_100.Knee(3)
                '%1.2f'     c.results.Right.momentMin_OppStrike_100.RKnee(3)
                '%1.2f'     c.results.Left.momentMin_OppStrike_100.LKnee(3)
                '%1.2f'     c.results.MeanLeg.momentMax_OppStrike_100.Ankle(3)
                '%1.2f'     c.results.Right.momentMax_OppStrike_100.RAnkle(3)
                '%1.2f'     c.results.Left.momentMax_OppStrike_100.LAnkle(3)
                '%1.2f'     c.results.MeanLeg.momentMin_OppStrike_100.Ankle(3)
                '%1.2f'     c.results.Right.momentMin_OppStrike_100.RAnkle(3)
                '%1.2f'     c.results.Left.momentMin_OppStrike_100.LAnkle(3)
                
                % Puissance articulaires à l'appui en sagittal
                '%1.2f'     c.results.MeanLeg.powerMax_FullStance.Hip(1)
                '%1.2f'     c.results.Right.powerMax_FullStance.RHip(1)
                '%1.2f'     c.results.Left.powerMax_FullStance.LHip(1)
                '%1.2f'     c.results.MeanLeg.powerMin_FullStance.Hip(1)
                '%1.2f'     c.results.Right.powerMin_FullStance.RHip(1)
                '%1.2f'     c.results.Left.powerMin_FullStance.LHip(1)
                '%1.2f'     c.results.MeanLeg.powerMax_FullStance.Knee(1)
                '%1.2f'     c.results.Right.powerMax_FullStance.RKnee(1)
                '%1.2f'     c.results.Left.powerMax_FullStance.LKnee(1)
                '%1.2f'     c.results.MeanLeg.powerMin_FullStance.Knee(1)
                '%1.2f'     c.results.Right.powerMin_FullStance.RKnee(1)
                '%1.2f'     c.results.Left.powerMin_FullStance.LKnee(1)
                % Puissance articulaires à l'appui en sagittal
                '%1.2f'     c.results.MeanLeg.powerMax_FullStance.Hip(2)
                '%1.2f'     c.results.Right.powerMax_FullStance.RHip(2)
                '%1.2f'     c.results.Left.powerMax_FullStance.LHip(2)
                '%1.2f'     c.results.MeanLeg.powerMin_FullStance.Hip(2)
                '%1.2f'     c.results.Right.powerMin_FullStance.RHip(2)
                '%1.2f'     c.results.Left.powerMin_FullStance.LHip(2)
                '%1.2f'     c.results.MeanLeg.powerMax_FullStance.Knee(2)
                '%1.2f'     c.results.Right.powerMax_FullStance.RKnee(2)
                '%1.2f'     c.results.Left.powerMax_FullStance.LKnee(2)
                '%1.2f'     c.results.MeanLeg.powerMin_FullStance.Knee(2)
                '%1.2f'     c.results.Right.powerMin_FullStance.RKnee(2)
                '%1.2f'     c.results.Left.powerMin_FullStance.LKnee(2)
                % Puissance articulaires à l'appui en sagittal
                '%1.2f'     c.results.MeanLeg.powerMax_FullStance.Hip(3)
                '%1.2f'     c.results.Right.powerMax_FullStance.RHip(3)
                '%1.2f'     c.results.Left.powerMax_FullStance.LHip(3)
                '%1.2f'     c.results.MeanLeg.powerMin_FullStance.Hip(3)
                '%1.2f'     c.results.Right.powerMin_FullStance.RHip(3)
                '%1.2f'     c.results.Left.powerMin_FullStance.LHip(3)
                '%1.2f'     c.results.MeanLeg.powerMax_FullStance.Knee(3)
                '%1.2f'     c.results.Right.powerMax_FullStance.RKnee(3)
                '%1.2f'     c.results.Left.powerMax_FullStance.LKnee(3)
                '%1.2f'     c.results.MeanLeg.powerMin_FullStance.Knee(3)
                '%1.2f'     c.results.Right.powerMin_FullStance.RKnee(3)
                '%1.2f'     c.results.Left.powerMin_FullStance.LKnee(3)
                
                % Puissance articulaires à la poussée en sagittal
                '%1.2f'     c.results.MeanLeg.powerMax_OppStrike_PushOff.Ankle(1)
                '%1.2f'     c.results.Right.powerMax_OppStrike_PushOff.RAnkle(1)
                '%1.2f'     c.results.Left.powerMax_OppStrike_PushOff.LAnkle(1)
                '%1.2f'     c.results.MeanLeg.powerMin_OppStrike_PushOff.Ankle(1)
                '%1.2f'     c.results.Right.powerMin_OppStrike_PushOff.RAnkle(1)
                '%1.2f'     c.results.Left.powerMin_OppStrike_PushOff.LAnkle(1)
                % Puissance articulaires à la poussée en sagittal
                '%1.2f'     c.results.MeanLeg.powerMax_OppStrike_PushOff.Ankle(2)
                '%1.2f'     c.results.Right.powerMax_OppStrike_PushOff.RAnkle(2)
                '%1.2f'     c.results.Left.powerMax_OppStrike_PushOff.LAnkle(2)
                '%1.2f'     c.results.MeanLeg.powerMin_OppStrike_PushOff.Ankle(2)
                '%1.2f'     c.results.Right.powerMin_OppStrike_PushOff.RAnkle(2)
                '%1.2f'     c.results.Left.powerMin_OppStrike_PushOff.LAnkle(2)
                % Puissance articulaires à la poussée en sagittal
                '%1.2f'     c.results.MeanLeg.powerMax_OppStrike_PushOff.Ankle(3)
                '%1.2f'     c.results.Right.powerMax_OppStrike_PushOff.RAnkle(3)
                '%1.2f'     c.results.Left.powerMax_OppStrike_PushOff.LAnkle(3)
                '%1.2f'     c.results.MeanLeg.powerMin_OppStrike_PushOff.Ankle(3)
                '%1.2f'     c.results.Right.powerMin_OppStrike_PushOff.RAnkle(3)
                '%1.2f'     c.results.Left.powerMin_OppStrike_PushOff.LAnkle(3)
            };
    % Créer la string qui sera utilisée dans fprintf
    str = sprintf(repmat(sprintf('%%s%s',sep), 1,size(outdata,1)), outdata{:,1});
    
    % Copier toutes les valeurs dans le excel
    fprintf(fid, [str '\n'], outdata{:,2});

    % Fermer le fichier
    fclose(fid);
end