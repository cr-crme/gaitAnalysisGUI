function r = createEmptyIfNecessary(r)

    % S'il manque des données d'un côté (et pas de l'autre)
    if ~isfield(r, 'Right') && isfield(r, 'Left')
        r.Right = navigateStructure(r.Left);
        
    elseif ~isfield(r, 'Left') && isfield(r, 'Right')
        r.Left = navigateStructure(r.Right);
        
    elseif ~isfield(r, 'Left') && ~isfield(r, 'Right')
        errordlg('There is no data on left neither on right side')
        error('There is no data on left neither on right side')
    end
end

function s2 = navigateStructure(s)
     % Aller chercher les fields qu'il faut moyenner
    fields = fieldnames(s);
    
    for iF = 1:length(fields)
        if isnumeric(s.(fields{iF}))
            s2.(fields{iF}) = nan(size(s.(fields{iF}))); % Le mettre sur la 4e car rien n'est sur 4
        elseif iscell(s.(fields{iF}))
            for i = 1:length(s.(fields{iF}))
                s2.(fields{iF}){i} = nan(size(s.(fields{iF}){i}));
            end
        elseif isstruct(s.(fields{iF}))
            % Si c'est une structure, appeler la fonction de faÃ§on rÃ©cursive
            s2.(fields{iF}) = navigateStructure(s.(fields{iF})); 
        end
        
    end

end