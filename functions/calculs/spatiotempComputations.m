function results = spatiotempComputations(data, results)
    
    % Si lorsqu'aucune donnée est envoyée (notamment pour le statique), il
    % manque des fields dans writeExcel, il est possible de les ajouter ici
    if isempty(data.Left.stamps) && isempty(data.Right.stamps)
        results.Left.spatio = false;
        results.Right.spatio = false;
        return;
    end

    if ~isempty(data.Left.stamps)
        % Moment (en %) du toe off
        results.Left.pctToeOff = data.Left.stamps.CycleMarcheLeft(data.Left.stamps.Left_Foot_Off.frameStamp);
        
        % Moment (en %) du toe off opposÃ©
        results.Left.pctToeOffOppose = data.Left.stamps.CycleMarcheLeft(data.Left.stamps.Right_Foot_Off.frameStamp);
        
        % Moment (en %) du contact talon opposÃ©
        results.Left.pctContactTalOppose = data.Left.stamps.CycleMarcheLeft(data.Left.stamps.Right_Foot_Strike.frameStamp);
        
        % Temps (en %) du simple appuie
        results.Left.pctSimpleAppuie = results.Left.pctContactTalOppose - results.Left.pctToeOffOppose;
        
        % Grandeur (en m) d'un pas et d'une foulÃ©e
        results.Left.distPas = abs(data.Left.markers.LHEE(data.Left.stamps.Left_Foot_Strike.frameStamp(1),2) -  ... 
                         data.Left.markers.RHEE(data.Left.stamps.Right_Foot_Strike.frameStamp,2))/1000;
        results.Left.distFoulee = abs(diff(data.Left.markers.LHEE(data.Left.stamps.Left_Foot_Strike.frameStamp,2)))/1000;
        
        % Temps (en s) d'une foulÃ©e
        results.Left.tempsFoulee = data.Left.tempsCycle;
        
        % Vitesse (en m/s) d'une foulÃ©e
        results.Left.vitFoulee = results.Left.distFoulee' ./ results.Left.tempsFoulee;
        
        % Calcul de la cadence (pas/minute) de marche
        results.Left.vitCadencePasParMinute = 1./results.Left.tempsFoulee * 60; % Convertir en "pas/minutes"
        
    end
    
    if isfield(data.Right, 'stamps') && ~isempty(data.Right.stamps)
        % Moment (en %) du toe off
        results.Right.pctToeOff = data.Right.stamps.CycleMarcheRight(data.Right.stamps.Right_Foot_Off.frameStamp);

        % Moment (en %) du toe off opposÃ©
        results.Right.pctToeOffOppose = data.Right.stamps.CycleMarcheRight(data.Right.stamps.Left_Foot_Off.frameStamp);

        % Moment (en %) du contact talon opposÃ©
        results.Right.pctContactTalOppose = data.Right.stamps.CycleMarcheRight(data.Right.stamps.Left_Foot_Strike.frameStamp);

        % Temps (en %) du simple appuie
        results.Right.pctSimpleAppuie = results.Right.pctContactTalOppose - results.Right.pctToeOffOppose;

        % Grandeur (en m) d'un pas et d'une foulÃ©e
        results.Right.distPas = abs(data.Right.markers.RHEE(data.Right.stamps.Right_Foot_Strike.frameStamp(1),2) -  ... 
                         data.Right.markers.LHEE(data.Right.stamps.Left_Foot_Strike.frameStamp,2))/1000;
        results.Right.distFoulee = abs(diff(data.Right.markers.RHEE(data.Right.stamps.Right_Foot_Strike.frameStamp,2)))/1000;

        % Temps (en s) d'une foulÃ©e
        results.Right.tempsFoulee = data.Right.tempsCycle;

        % Vitesse (en m/s) d'une foulÃ©e
        results.Right.vitFoulee = results.Right.distFoulee' ./ results.Right.tempsFoulee;

        % Calcul de la cadence (pas/minute) de marche
        results.Right.vitCadencePasParMinute = 1./results.Right.tempsFoulee * 60; % Convertir en "pas/minutes"
    end
end