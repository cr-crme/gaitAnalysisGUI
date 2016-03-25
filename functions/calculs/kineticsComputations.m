function results = kineticsComputations(data, results)

% Extraction des moments
    results.Left.moment_0_OppFootOff = extractData(data.Left, data.Left.stamps.Left_Foot_0_OppPushOff.frameStamps, 'moment', 'Moment');
    results.Right.moment_0_OppFootOff = extractData(data.Right, data.Right.stamps.Right_Foot_0_OppPushOff.frameStamps, 'moment', 'Moment');
    results.Left.moment_OppStrike_100 = extractData(data.Left, data.Left.stamps.Left_Foot_OppStrike_100.frameStamps, 'moment', 'Moment');
    results.Right.moment_OppStrike_100 = extractData(data.Right, data.Right.stamps.Right_Foot_OppStrike_100.frameStamps, 'moment', 'Moment');
    
    % Calcul du peak de couple au contact talon
    results.Left.momentMax_0_OppFootOff = computeCustomCalculation(results.Left.moment_0_OppFootOff, @max);
    results.Right.momentMax_0_OppFootOff = computeCustomCalculation(results.Right.moment_0_OppFootOff, @max);
    results.Left.momentMin_0_OppFootOff = computeCustomCalculation(results.Left.moment_0_OppFootOff, @min);
    results.Right.momentMin_0_OppFootOff = computeCustomCalculation(results.Right.moment_0_OppFootOff, @min);
    
    % Calcul du peak de couple du contact talon opposé
    results.Left.momentMax_OppStrike_100 = computeCustomCalculation(results.Left.moment_OppStrike_100, @max);
    results.Right.momentMax_OppStrike_100 = computeCustomCalculation(results.Right.moment_OppStrike_100, @max);
    results.Left.momentMin_OppStrike_100 = computeCustomCalculation(results.Left.moment_OppStrike_100, @min);
    results.Right.momentMin_OppStrike_100 = computeCustomCalculation(results.Right.moment_OppStrike_100, @min);
    
    % Extraction des puissances
    results.Left.power_FullStance = extractData(data.Left, data.Left.stamps.Left_Foot_FullStance.frameStamps, 'power', 'Power');
    results.Right.power_FullStance = extractData(data.Right, data.Right.stamps.Right_Foot_FullStance.frameStamps, 'power', 'Power');
    results.Left.power_OppStrike_PushOff = extractData(data.Left, data.Left.stamps.Left_Foot_OppStrike_PushOff.frameStamps, 'power', 'Power');
    results.Right.power_OppStrike_PushOff = extractData(data.Right, data.Right.stamps.Right_Foot_OppStrike_PushOff.frameStamps, 'power', 'Power');
    
    % Calcul du peak max et min de la puissance lors de support
    results.Left.powerMax_FullStance = computeCustomCalculation(results.Left.power_FullStance, @max);
    results.Right.powerMax_FullStance = computeCustomCalculation(results.Right.power_FullStance, @max);
    results.Left.powerMin_FullStance = computeCustomCalculation(results.Left.power_FullStance, @min);
    results.Right.powerMin_FullStance = computeCustomCalculation(results.Right.power_FullStance, @min);
    
    % Calcul du peak max et min de la puissance lors de double appuie
    results.Left.powerMax_OppStrike_PushOff = computeCustomCalculation(results.Left.power_OppStrike_PushOff, @max);
    results.Right.powerMax_OppStrike_PushOff = computeCustomCalculation(results.Right.power_OppStrike_PushOff, @max);
    results.Left.powerMin_OppStrike_PushOff = computeCustomCalculation(results.Left.power_OppStrike_PushOff, @min);
    results.Right.powerMin_OppStrike_PushOff = computeCustomCalculation(results.Right.power_OppStrike_PushOff, @min);
    

end