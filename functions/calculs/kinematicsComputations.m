function results = kinematicsComputations(data, results)

    % Si lorsqu'aucune donnée est envoyée (notamment pour le statique), il
    % manque des fields dans writeExcel, il est possible de les ajouter ici
    if (~isfield(data, 'Left') || isempty(data.Left.stamps)) && (~isfield(data, 'Right') || isempty(data.Right.stamps))
        results.Left.kin = false;
        results.Right.kin = false;
        return;
    end
    
    if isfield(data, 'Left') && ~isempty(data.Left.stamps)
        % Orientation (Â°) de la hanche/genou/cheville/pied au contact talon (0% du cycle)
        results.Left.angAtFoot_Strike = extractData(data.Left, 'Left_Foot_Strike', 'angle', 'Angles');
        
        % Orientation (Â°) de la hanche/genou/cheville/pied au push off
        results.Left.angAtFoot_Off = extractData(data.Left, 'Left_Foot_Off', 'angle', 'Angles');
        
        % Orientations (Â°) de la hanche/genou/cheville/pied lors de simple appui et sur tout le support
        results.Left.angAtUnipodal = extractData(data.Left, data.Left.stamps.Left_Foot_Unipodal.frameStamps, 'angle', 'Angles');
        results.Left.angAtFullStance = extractData(data.Left, data.Left.stamps.Left_Foot_FullStance.frameStamps, 'angle', 'Angles');
        results.Left.angAtFullCycle = extractData(data.Left, data.Left.stamps.Left_Foot_FullCycle.frameStamps, 'angle', 'Angles');
        results.Left.angAtFullTrial = extractData(data.Left, data.Left.stamps.Left_Foot_FullCycle.frameStamps, 'angle', 'Angles');
        
        % Angle moyen durant unipodal et tout le support
        results.Left.angMeanAtUnipodal = computeCustomCalculation(results.Left.angAtUnipodal, @mean);
        results.Left.angMeanAtFullStance = computeCustomCalculation(results.Left.angAtFullStance, @mean);
       
        % Angle minimum durant unipodal et tout le support
        results.Left.angMinAtUnipodal = computeCustomCalculation(results.Left.angAtUnipodal, @min);
        results.Left.angMinAtFullStance = computeCustomCalculation(results.Left.angAtFullStance, @min);
       
        % Angle maximal durant unipodal et tout le support
        results.Left.angMaxAtUnipodal = computeCustomCalculation(results.Left.angAtUnipodal, @max);
        results.Left.angMaxAtFullStance = computeCustomCalculation(results.Left.angAtFullStance, @max);
       
        % Range of motion durant unipodal et tout le support
        results.Left.angRangeMotionAtUnipodal = computeRangeOfMotion(results.Left.angMaxAtUnipodal, results.Left.angMinAtUnipodal);
        results.Left.angRangeMotionAtFullStance = computeRangeOfMotion(results.Left.angMaxAtFullStance, results.Left.angMinAtFullStance);
       
        % Hauteur COM normalisÃ© sur la taille
        results.Left.comHeight = data.Left.markers.CentreOfMass(:,3) / data.Left.info.height *100;
        % Amplitude (en %) de la hauteur du COM 
        results.Left.comRangeHeight = max(results.Left.comHeight) - min(results.Left.comHeight);
        % Moyenne (en %) de la hauteur du COM 
        results.Left.comMeanHeight = mean(results.Left.comHeight);
        % Amplitude (en mm) de mÃ©diolatÃ©ral
        results.Left.comRangeML = data.Left.CentreOfMass.ml;
  
        % Hauteur COM min et max normalisÃ© sur la taille
        results.Left.comMinHeight = min(results.Left.comHeight);
        results.Left.comMaxHeight = max(results.Left.comHeight);
 

        % ParamÃ¨tres cinÃ©matiques
        results.Left = kinParamOfCOM(results.Left, data.Left);
        results.Left.comVitesseMin = min(results.Left.comVitesse);
        results.Left.comVitesseMax = max(results.Left.comVitesse);
        results.Left.comAccelerationMin = min(results.Left.comAcceleration);
        results.Left.comAccelerationMax = max(results.Left.comAcceleration);
        results.Left.comSecousseMin = min(results.Left.comSecousse);
        results.Left.comSecousseMax = max(results.Left.comSecousse);
          
        % Calcul des vitesse articulaires
        data.Left = computeAngularVelocityAndAcceleration(results.Left, data.Left);
     
        % Angular velocity (Â°/s) de la hanche/genou/cheville/pied lors de phases particuilÃ¨res
        results.Left.angVel_20_100 = extractData(data.Left, data.Left.stamps.Left_Foot_20_100.frameStamps, 'angle', 'Velocities');
        results.Left.angVel_PushOff_100 = extractData(data.Left, data.Left.stamps.Left_Foot_PushOff_100.frameStamps, 'angle', 'Velocities');
        results.Left.angVel_OppFoot_100 = extractData(data.Left, data.Left.stamps.Left_Foot_PushOffOpposite_100.frameStamps, 'angle', 'Velocities');
     
        % Max angular velocity (Â°/s) de la hanche/genou/cheville/pied lors de phases particuilÃ¨res
            % reprÃ©sente flexion ou extesion selon l'articulation
        results.Left.angVelMax_20_100 = computeCustomCalculation(results.Left.angVel_20_100, @max);
        results.Left.angVelMax_PushOff_100 = computeCustomCalculation(results.Left.angVel_PushOff_100, @max);
        results.Left.angVelMax_OppFoot_100 = computeCustomCalculation(results.Left.angVel_OppFoot_100, @max);
    
        % Min angular velocity (Â°/s) de la hanche/genou/cheville/pied lors de phases particuilÃ¨res
        results.Left.angVelMin_20_100 = computeCustomCalculation(results.Left.angVel_20_100, @min);
        results.Left.angVelMin_PushOff_100 = computeCustomCalculation(results.Left.angVel_PushOff_100, @min);
        results.Left.angVelMin_OppFoot_100 = computeCustomCalculation(results.Left.angVel_OppFoot_100, @min);
        
        % Base de sustentation 
        BS_Left_Foot_0_OppPushOff = abs(data.Left.markers.LTOEInRef(data.Left.stamps.Left_Foot_0_OppPushOff.frameStamps{:},1) - data.Left.markers.RTOEInRef(data.Left.stamps.Left_Foot_0_OppPushOff.frameStamps{:},1));
        results.Left.baseSustentation.maxPostMoyenne = max(BS_Left_Foot_0_OppPushOff);
        results.Left.baseSustentation.minPostMoyenne = min(BS_Left_Foot_0_OppPushOff);
        results.Left.baseSustentation.maxPreMoyenne = data.Left.baseSustentation.maxPreMoyenne;
        results.Left.baseSustentation.minPreMoyenne = data.Left.baseSustentation.minPreMoyenne;
        
        % Centre de masse
        results.Left.CentreOfMass.mlPostMoyenne = abs(max(data.Left.markers.CentreOfMassInRef(:,1)) - min(data.Left.markers.CentreOfMassInRef(:,1)));
        results.Left.CentreOfMass.mlPreMoyenne = data.Left.CentreOfMass.ml;
        
    end
    
    if isfield(data, 'Right') && ~isempty(data.Right.stamps)
        % Orientation (Â°) de la hanche/genou/cheville/pied au contact talon (0% du cycle)
        results.Right.angAtFoot_Strike = extractData(data.Right, 'Right_Foot_Strike', 'angle', 'Angles');

        % Orientation (Â°) de la hanche/genou/cheville/pied au push off
        results.Right.angAtFoot_Off = extractData(data.Right, 'Right_Foot_Off', 'angle', 'Angles');

        % Orientations (Â°) de la hanche/genou/cheville/pied lors de simple appui et sur tout le support
        results.Right.angAtUnipodal = extractData(data.Right, data.Right.stamps.Right_Foot_Unipodal.frameStamps, 'angle', 'Angles');
        results.Right.angAtFullStance = extractData(data.Right, data.Right.stamps.Right_Foot_FullStance.frameStamps, 'angle', 'Angles');
        results.Right.angAtFullCycle = extractData(data.Right, data.Right.stamps.Right_Foot_FullCycle.frameStamps, 'angle', 'Angles');
        results.Right.angAtFullTrial = extractData(data.Right, data.Right.stamps.Right_Foot_FullCycle.frameStamps, 'angle', 'Angles');

        % Angle moyen durant unipodal et tout le support
        results.Right.angMeanAtUnipodal = computeCustomCalculation(results.Right.angAtUnipodal, @mean);
        results.Right.angMeanAtFullStance = computeCustomCalculation(results.Right.angAtFullStance, @mean);

        % Angle minimum durant unipodal et tout le support
        results.Right.angMinAtUnipodal = computeCustomCalculation(results.Right.angAtUnipodal, @min);
        results.Right.angMinAtFullStance = computeCustomCalculation(results.Right.angAtFullStance, @min);

        % Angle maximal durant unipodal et tout le support
        results.Right.angMaxAtUnipodal = computeCustomCalculation(results.Right.angAtUnipodal, @max);
        results.Right.angMaxAtFullStance = computeCustomCalculation(results.Right.angAtFullStance, @max);

        % Range of motion durant unipodal et tout le support
        results.Right.angRangeMotionAtUnipodal = computeRangeOfMotion(results.Right.angMaxAtUnipodal, results.Right.angMinAtUnipodal);
        results.Right.angRangeMotionAtFullStance = computeRangeOfMotion(results.Right.angMaxAtFullStance, results.Right.angMinAtFullStance);

        % Hauteur COM normalisÃ© sur la taille
        results.Right.comHeight = data.Right.markers.CentreOfMass(:,3) / data.Right.info.height *100;
        % Amplitude (en %) de la hauteur du COM 
        results.Right.comRangeHeight = max(results.Right.comHeight) - min(results.Right.comHeight);
        % Moyenne (en %) de la hauteur du COM 
        results.Right.comMeanHeight = mean(results.Right.comHeight);
        % Amplitude (en mm) de mÃ©diolatÃ©ral
        results.Right.comRangeML = data.Right.CentreOfMass.ml;

        % Hauteur COM min et max normalisÃ© sur la taille
        results.Right.comMinHeight = min(results.Right.comHeight);
        results.Right.comMaxHeight = max(results.Right.comHeight);


        % ParamÃ¨tres cinÃ©matiques
        results.Right = kinParamOfCOM(results.Right, data.Right);
        results.Right.comVitesseMin = min(results.Right.comVitesse);
        results.Right.comVitesseMax = max(results.Right.comVitesse);
        results.Right.comAccelerationMin = min(results.Right.comAcceleration);
        results.Right.comAccelerationMax = max(results.Right.comAcceleration);
        results.Right.comSecousseMin = min(results.Right.comSecousse);
        results.Right.comSecousseMax = max(results.Right.comSecousse);

        % Calcul des vitesse articulaires
        data.Right = computeAngularVelocityAndAcceleration(results.Right, data.Right);

        % Angular velocity (Â°/s) de la hanche/genou/cheville/pied lors de phases particuilÃ¨res
        results.Right.angVel_20_100 = extractData(data.Right, data.Right.stamps.Right_Foot_20_100.frameStamps, 'angle', 'Velocities');
        results.Right.angVel_PushOff_100 = extractData(data.Right, data.Right.stamps.Right_Foot_PushOff_100.frameStamps, 'angle', 'Velocities');
        results.Right.angVel_OppFoot_100 = extractData(data.Right, data.Right.stamps.Right_Foot_PushOffOpposite_100.frameStamps, 'angle', 'Velocities');

        % Max angular velocity (Â°/s) de la hanche/genou/cheville/pied lors de phases particuilÃ¨res
            % reprÃ©sente flexion ou extesion selon l'articulation
        results.Right.angVelMax_20_100 = computeCustomCalculation(results.Right.angVel_20_100, @max);
        results.Right.angVelMax_PushOff_100 = computeCustomCalculation(results.Right.angVel_PushOff_100, @max);
        results.Right.angVelMax_OppFoot_100 = computeCustomCalculation(results.Right.angVel_OppFoot_100, @max);

        % Min angular velocity (Â°/s) de la hanche/genou/cheville/pied lors de phases particuilÃ¨res
        results.Right.angVelMin_20_100 = computeCustomCalculation(results.Right.angVel_20_100, @min);
        results.Right.angVelMin_PushOff_100 = computeCustomCalculation(results.Right.angVel_PushOff_100, @min);
        results.Right.angVelMin_OppFoot_100 = computeCustomCalculation(results.Right.angVel_OppFoot_100, @min);
        
        % Base de sustentation
        BS_Right_Foot_0_OppPushOff = abs(data.Right.markers.RTOEInRef(data.Right.stamps.Right_Foot_0_OppPushOff.frameStamps{:},1) - data.Right.markers.LTOEInRef(data.Right.stamps.Right_Foot_0_OppPushOff.frameStamps{:},1));
        results.Right.baseSustentation.maxPostMoyenne = max(BS_Right_Foot_0_OppPushOff);
        results.Right.baseSustentation.minPostMoyenne = min(BS_Right_Foot_0_OppPushOff);
        results.Right.baseSustentation.maxPreMoyenne = data.Right.baseSustentation.maxPreMoyenne;
        results.Right.baseSustentation.minPreMoyenne = data.Right.baseSustentation.minPreMoyenne;
        
        % Centre de masse
        results.Right.CentreOfMass.mlPostMoyenne = abs(max(data.Right.markers.CentreOfMassInRef(:,1)) - min(data.Right.markers.CentreOfMassInRef(:,1)));
        results.Right.CentreOfMass.mlPreMoyenne = data.Right.CentreOfMass.ml;
        
    end
end
