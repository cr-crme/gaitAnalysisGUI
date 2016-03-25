function results = spatiotempComputations(data, results)
    
    % Moment (en %) du toe off
    results.Left.pctToeOff = data.Left.stamps.CycleMarcheLeft(data.Left.stamps.Left_Foot_Off.frameStamp);
    results.Right.pctToeOff = data.Right.stamps.CycleMarcheRight(data.Right.stamps.Right_Foot_Off.frameStamp);

    % Moment (en %) du toe off opposé
    results.Left.pctToeOffOppose = data.Left.stamps.CycleMarcheLeft(data.Left.stamps.Right_Foot_Off.frameStamp);
    results.Right.pctToeOffOppose = data.Right.stamps.CycleMarcheRight(data.Right.stamps.Left_Foot_Off.frameStamp);

    % Moment (en %) du contact talon opposé
    results.Left.pctContactTalOppose = data.Left.stamps.CycleMarcheLeft(data.Left.stamps.Right_Foot_Strike.frameStamp);
    results.Right.pctContactTalOppose = data.Right.stamps.CycleMarcheRight(data.Right.stamps.Left_Foot_Strike.frameStamp);

    % Temps (en %) du simple appuie
    results.Left.pctSimpleAppuie = results.Left.pctContactTalOppose - results.Left.pctToeOffOppose;
    results.Right.pctSimpleAppuie = results.Right.pctContactTalOppose - results.Right.pctToeOffOppose;

    % Grandeur (en m) d'un pas et d'une foulée
    results.Left.distPas = abs(data.Left.markers.LHEE(data.Left.stamps.Left_Foot_Strike.frameStamp(1),2) -  ... 
                     data.Left.markers.RHEE(data.Left.stamps.Right_Foot_Strike.frameStamp,2))/1000;
    results.Right.distPas = abs(data.Right.markers.RHEE(data.Right.stamps.Right_Foot_Strike.frameStamp(1),2) -  ... 
                     data.Right.markers.LHEE(data.Right.stamps.Left_Foot_Strike.frameStamp,2))/1000;
    results.Left.distFoulee = abs(diff(data.Left.markers.LHEE(data.Left.stamps.Left_Foot_Strike.frameStamp,2)))/1000;
    results.Right.distFoulee = abs(diff(data.Right.markers.RHEE(data.Right.stamps.Right_Foot_Strike.frameStamp,2)))/1000;
    
    % Temps (en s) d'une foulée
    results.Left.tempsFoulee = data.Left.tempsCycle;
    results.Right.tempsFoulee = data.Right.tempsCycle;

    % Vitesse (en m/s) d'une foulée
    results.Left.vitFoulee = results.Left.distFoulee' ./ results.Left.tempsFoulee;
    results.Right.vitFoulee = results.Right.distFoulee' ./ results.Right.tempsFoulee;
    
    % Calcul de la cadence (pas/minute) de marche
    results.Left.vitCadencePasParMinute = 1./results.Left.tempsFoulee * 60; % Convertir en "pas/minutes"
    results.Right.vitCadencePasParMinute = 1./results.Right.tempsFoulee * 60; % Convertir en "pas/minutes"
    

end