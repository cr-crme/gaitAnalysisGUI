function results = kinematicsComputations(data, results)

    % Orientation (°) de la hanche/genou/cheville/pied au contact talon (0% du cycle)
    results.Left.angAtFoot_Strike = extractData(data.Left, 'Left_Foot_Strike', 'angle', 'Angles');
    results.Right.angAtFoot_Strike = extractData(data.Right, 'Right_Foot_Strike', 'angle', 'Angles');
    
    % Orientation (°) de la hanche/genou/cheville/pied au push off
    results.Left.angAtFoot_Off = extractData(data.Left, 'Left_Foot_Off', 'angle', 'Angles');
    results.Right.angAtFoot_Off = extractData(data.Right, 'Right_Foot_Off', 'angle', 'Angles');
    
    % Orientations (°) de la hanche/genou/cheville/pied lors de simple appui et sur tout le support
    results.Left.angAtUnipodal = extractData(data.Left, data.Left.stamps.Left_Foot_Unipodal.frameStamps, 'angle', 'Angles');
    results.Right.angAtUnipodal = extractData(data.Right, data.Right.stamps.Right_Foot_Unipodal.frameStamps, 'angle', 'Angles');
    results.Left.angAtFullStance = extractData(data.Left, data.Left.stamps.Left_Foot_FullStance.frameStamps, 'angle', 'Angles');
    results.Right.angAtFullStance = extractData(data.Right, data.Right.stamps.Right_Foot_FullStance.frameStamps, 'angle', 'Angles');
    results.Left.angAtFullCycle = extractData(data.Left, data.Left.stamps.Left_Foot_FullCycle.frameStamps, 'angle', 'Angles');
    results.Right.angAtFullCycle = extractData(data.Right, data.Right.stamps.Right_Foot_FullCycle.frameStamps, 'angle', 'Angles');
    results.Left.angAtFullTrial = extractData(data.Left, data.Left.stamps.Left_Foot_FullCycle.frameStamps, 'angle', 'Angles');
    results.Right.angAtFullTrial = extractData(data.Right, data.Right.stamps.Right_Foot_FullCycle.frameStamps, 'angle', 'Angles');
    
    % Angle moyen durant unipodal et tout le support
    results.Left.angMeanAtUnipodal = computeCustomCalculation(results.Left.angAtUnipodal, @mean);
    results.Right.angMeanAtUnipodal = computeCustomCalculation(results.Right.angAtUnipodal, @mean);
    results.Left.angMeanAtFullStance = computeCustomCalculation(results.Left.angAtFullStance, @mean);
    results.Right.angMeanAtFullStance = computeCustomCalculation(results.Right.angAtFullStance, @mean);

    % Angle minimum durant unipodal et tout le support
    results.Left.angMinAtUnipodal = computeCustomCalculation(results.Left.angAtUnipodal, @min);
    results.Right.angMinAtUnipodal = computeCustomCalculation(results.Right.angAtUnipodal, @min);
    results.Left.angMinAtFullStance = computeCustomCalculation(results.Left.angAtFullStance, @min);
    results.Right.angMinAtFullStance = computeCustomCalculation(results.Right.angAtFullStance, @min);

    % Angle maximal durant unipodal et tout le support
    results.Left.angMaxAtUnipodal = computeCustomCalculation(results.Left.angAtUnipodal, @max);
    results.Right.angMaxAtUnipodal = computeCustomCalculation(results.Right.angAtUnipodal, @max);
    results.Left.angMaxAtFullStance = computeCustomCalculation(results.Left.angAtFullStance, @max);
    results.Right.angMaxAtFullStance = computeCustomCalculation(results.Right.angAtFullStance, @max);

    % Range of motion durant unipodal et tout le support
    results.Left.angRangeMotionAtUnipodal = computeRangeOfMotion(results.Left.angMaxAtUnipodal, results.Left.angMinAtUnipodal);
    results.Right.angRangeMotionAtUnipodal = computeRangeOfMotion(results.Right.angMaxAtUnipodal, results.Right.angMinAtUnipodal);
    results.Left.angRangeMotionAtFullStance = computeRangeOfMotion(results.Left.angMaxAtFullStance, results.Left.angMinAtFullStance);
    results.Right.angRangeMotionAtFullStance = computeRangeOfMotion(results.Right.angMaxAtFullStance, results.Right.angMinAtFullStance);
    
    % Hauteur COM normalisé sur la taille
    results.Left.comHeight = data.Left.markers.CentreOfMass(:,3) / data.Left.info.height *100;
    results.Right.comHeight = data.Right.markers.CentreOfMass(:,3) / data.Right.info.height *100;
    % Amplitude (en %) de la hauteur du COM 
    results.Left.comRangeHeight = max(results.Left.comHeight) - min(results.Left.comHeight);
    results.Right.comRangeHeight = max(results.Right.comHeight) - min(results.Right.comHeight);
    % Amplitude (en mm) de médiolatéral
    results.Left.comRangeML = data.Left.CentreOfMass.ml;
    results.Right.comRangeML = data.Right.CentreOfMass.ml;
    
    % Hauteur COM min et max normalisé sur la taille
    results.Left.comMinHeight = min(results.Left.comHeight);
    results.Right.comMinHeight = min(results.Right.comHeight);
    results.Left.comMaxHeight = min(results.Left.comHeight);
    results.Right.comMaxHeight = min(results.Right.comHeight);
    
    
    % Paramètres cinématiques
    results.Left = kinParamOfCOM(results.Left, data.Left);
    results.Left.comVitesseMin = min(results.Left.comVitesse);
    results.Left.comVitesseMax = max(results.Left.comVitesse);
    results.Left.comAccelerationMin = min(results.Left.comAcceleration);
    results.Left.comAccelerationMax = max(results.Left.comAcceleration);
    results.Left.comSecousseMin = min(results.Left.comSecousse);
    results.Left.comSecousseMax = max(results.Left.comSecousse);
    results.Right = kinParamOfCOM(results.Right, data.Right);
    results.Right.comVitesseMin = min(results.Right.comVitesse);
    results.Right.comVitesseMax = max(results.Right.comVitesse);
    results.Right.comAccelerationMin = min(results.Right.comAcceleration);
    results.Right.comAccelerationMax = max(results.Right.comAcceleration);
    results.Right.comSecousseMin = min(results.Right.comSecousse);
    results.Right.comSecousseMax = max(results.Right.comSecousse);
    
    % Calcul des vitesse articulaires
    data.Left = computeAngularVelocityAndAcceleration(results.Left, data.Left);
    data.Right = computeAngularVelocityAndAcceleration(results.Right, data.Right);

    % Angular velocity (°/s) de la hanche/genou/cheville/pied lors de phases particuilères
    results.Left.angVel_20_100 = extractData(data.Left, data.Left.stamps.Left_Foot_20_100.frameStamps, 'angle', 'Velocities');
    results.Right.angVel_20_100 = extractData(data.Right, data.Right.stamps.Right_Foot_20_100.frameStamps, 'angle', 'Velocities');
    results.Left.angVel_PushOff_100 = extractData(data.Left, data.Left.stamps.Left_Foot_PushOff_100.frameStamps, 'angle', 'Velocities');
    results.Right.angVel_PushOff_100 = extractData(data.Right, data.Right.stamps.Right_Foot_PushOff_100.frameStamps, 'angle', 'Velocities');
    results.Left.angVel_OppFoot_100 = extractData(data.Left, data.Left.stamps.Left_Foot_PushOffOpposite_100.frameStamps, 'angle', 'Velocities');
    results.Right.angVel_OppFoot_100 = extractData(data.Right, data.Right.stamps.Right_Foot_PushOffOpposite_100.frameStamps, 'angle', 'Velocities');
 
    % Max angular velocity (°/s) de la hanche/genou/cheville/pied lors de phases particuilères
        % représente flexion ou extesion selon l'articulation
    results.Left.angVelMax_20_100 = computeCustomCalculation(results.Left.angVel_20_100, @max);
    results.Right.angVelMax_20_100 = computeCustomCalculation(results.Right.angVel_20_100, @max);
    results.Left.angVelMax_PushOff_100 = computeCustomCalculation(results.Left.angVel_PushOff_100, @max);
    results.Right.angVelMax_PushOff_100 = computeCustomCalculation(results.Right.angVel_PushOff_100, @max);
    results.Left.angVelMax_OppFoot_100 = computeCustomCalculation(results.Left.angVel_OppFoot_100, @max);
    results.Right.angVelMax_OppFoot_100 = computeCustomCalculation(results.Right.angVel_OppFoot_100, @max);
    
    % Min angular velocity (°/s) de la hanche/genou/cheville/pied lors de phases particuilères
    results.Left.angVelMin_20_100 = computeCustomCalculation(results.Left.angVel_20_100, @min);
    results.Right.angVelMin_20_100 = computeCustomCalculation(results.Right.angVel_20_100, @min);
    results.Left.angVelMin_PushOff_100 = computeCustomCalculation(results.Left.angVel_PushOff_100, @min);
    results.Right.angVelMin_PushOff_100 = computeCustomCalculation(results.Right.angVel_PushOff_100, @min);
    results.Left.angVelMin_OppFoot_100 = computeCustomCalculation(results.Left.angVel_OppFoot_100, @min);
    results.Right.angVelMin_OppFoot_100 = computeCustomCalculation(results.Right.angVel_OppFoot_100, @min);
    

end