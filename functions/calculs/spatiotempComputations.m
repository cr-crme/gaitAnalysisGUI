function results = spatiotempComputations(data, results)
    
    % Si lorsqu'aucune donnée est envoyée (notamment pour le statique), il
    % manque des fields dans writeExcel, il est possible de les ajouter ici
    if (~isfield(data, 'Left') || isempty(data.Left.stamps)) && (~isfield(data, 'Right') || isempty(data.Right.stamps))
        results.Left.spatio = false;
        results.Right.spatio = false;
        return;
    end

    sides = fieldnames(data);
    for iS = 1:length(sides)
        side = sides{iS};
        if strcmp(side, 'Left')
            oppositeSide = 'Right';
        else
            oppositeSide = 'Left';
        end
        s = side(1);
        os = oppositeSide(1);

        if ~isfield(data.(side), 'stamps') || isempty(data.(side).stamps)
            continue
        end

        % Moment (en %) du toe off
        results.(side).pctToeOff = data.(side).stamps.(['CycleMarche' side])(data.(side).stamps.([side '_Foot_Off']).frameStamp);
        
        % Moment (en %) du toe off opposÃ©
        results.(side).pctToeOffOppose = data.(side).stamps.(['CycleMarche' side])(data.(side).stamps.([oppositeSide '_Foot_Off']).frameStamp);
        
        % Moment (en %) du contact talon opposÃ©
        results.(side).pctContactTalOppose = data.(side).stamps.(['CycleMarche' side])(data.(side).stamps.([oppositeSide '_Foot_Strike']).frameStamp);
        
        % Temps (en %) du simple appuie
        results.(side).pctSimpleAppuie = results.(side).pctContactTalOppose - results.(side).pctToeOffOppose;
        
        % Grandeur (en m) d'un pas et d'une foulÃ©e
        results.(side).distPas = abs(data.(side).markers.([s 'HEE'])(data.(side).stamps.([side '_Foot_Strike']).frameStamp(1),2) -  ... 
                         data.(side).markers.([os 'HEE'])(data.(side).stamps.([oppositeSide '_Foot_Strike']).frameStamp,2))/1000;
        results.(side).distFoulee = abs(diff(data.(side).markers.([s 'HEE'])(data.(side).stamps.([side '_Foot_Strike']).frameStamp,2)))/1000;
        
        % Temps (en s) d'une foulÃ©e
        results.(side).tempsFoulee = data.(side).tempsCycle;
        
        % Vitesse (en m/s) d'une foulÃ©e
        results.(side).vitFoulee = results.(side).distFoulee' ./ results.(side).tempsFoulee;
        
        % Calcul de la cadence (pas/minute) de marche
        results.(side).vitCadencePasParMinute = 1./results.(side).tempsFoulee * 60; % Convertir en "pas/minutes" 
    end
end