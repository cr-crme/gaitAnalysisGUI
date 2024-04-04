function results = kineticsComputations(data, results)

    % Si lorsqu'aucune donnée est envoyée (notamment pour le statique), il
    % manque des fields dans writeExcel, il est possible de les ajouter ici
    if (~isfield(data, 'Left') || isempty(data.Left.stamps)) && (~isfield(data, 'Right') || isempty(data.Right.stamps))
        results.Left.kinetics = false;
        results.Right.kinetics = false;
        return;
    end

    if isfield(data, 'Left') && ~isempty(data.Left.stamps)
        % Extraction des moments
        results.Left.moment_FullCycle = extractData(data.Left, data.Left.stamps.Left_Foot_FullCycle.frameStamps, 'moment', 'Moment');
        results.Left.moment_0_OppFootOff = extractData(data.Left, data.Left.stamps.Left_Foot_0_OppPushOff.frameStamps, 'moment', 'Moment');
        results.Left.moment_OppStrike_100 = extractData(data.Left, data.Left.stamps.Left_Foot_OppStrike_100.frameStamps, 'moment', 'Moment');
        results.Left.moment_Unipodal = extractData(data.Left, data.Left.stamps.Left_Foot_Unipodal.frameStamps, 'moment', 'Moment');

        % Calcul du peak de couple sur tout le cycle
        results.Left.momentMax_FullCycle = computeCustomCalculation(results.Left.moment_FullCycle, @max);
        results.Left.momentMin_FullCycle = computeCustomCalculation(results.Left.moment_FullCycle, @min);
        
        % Calcul du peak de couple au contact talon
        results.Left.momentMax_0_OppFootOff = computeCustomCalculation(results.Left.moment_0_OppFootOff, @max);
        results.Left.momentMin_0_OppFootOff = computeCustomCalculation(results.Left.moment_0_OppFootOff, @min);
        
        % Calcul du peak de couple du contact talon opposÃ©
        results.Left.momentMax_OppStrike_100 = computeCustomCalculation(results.Left.moment_OppStrike_100, @max);
        results.Left.momentMin_OppStrike_100 = computeCustomCalculation(results.Left.moment_OppStrike_100, @min);
        
        % Calcul du peak max et min du couple à opp foot strike
        results.Left.momentMax_Unipodal = computeCustomCalculation(results.Left.moment_Unipodal, @max);
        results.Left.momentMin_Unipodal = computeCustomCalculation(results.Left.moment_Unipodal, @min);
        
        
        
        % Extraction des puissances
        results.Left.power_FullCycle = extractData(data.Left, data.Left.stamps.Left_Foot_FullCycle.frameStamps, 'power', 'Power');
        results.Left.power_FullStance = extractData(data.Left, data.Left.stamps.Left_Foot_FullStance.frameStamps, 'power', 'Power');
        results.Left.power_OppStrike_PushOff = extractData(data.Left, data.Left.stamps.Left_Foot_OppStrike_PushOff.frameStamps, 'power', 'Power');
        
        % Calcul du peak max et min de la puissance lors de support
        results.Left.powerMax_FullCycle = computeCustomCalculation(results.Left.power_FullCycle, @max);
        results.Left.powerMin_FullCycle = computeCustomCalculation(results.Left.power_FullCycle, @min);
        
        % Calcul du peak max et min de la puissance lors de support
        results.Left.powerMax_FullStance = computeCustomCalculation(results.Left.power_FullStance, @max);
        results.Left.powerMin_FullStance = computeCustomCalculation(results.Left.power_FullStance, @min);
        
        % Calcul du peak max et min de la puissance lors de double appuie
        results.Left.powerMax_OppStrike_PushOff = computeCustomCalculation(results.Left.power_OppStrike_PushOff, @max);
        results.Left.powerMin_OppStrike_PushOff = computeCustomCalculation(results.Left.power_OppStrike_PushOff, @min);
        
        
    end
    
    if isfield(data, 'Right') && ~isempty(data.Right.stamps)
        % Extraction des moments
        results.Right.moment_FullCycle = extractData(data.Right, data.Right.stamps.Right_Foot_FullCycle.frameStamps, 'moment', 'Moment');
        results.Right.moment_0_OppFootOff = extractData(data.Right, data.Right.stamps.Right_Foot_0_OppPushOff.frameStamps, 'moment', 'Moment');
        results.Right.moment_OppStrike_100 = extractData(data.Right, data.Right.stamps.Right_Foot_OppStrike_100.frameStamps, 'moment', 'Moment');
        results.Right.moment_Unipodal = extractData(data.Right, data.Right.stamps.Right_Foot_Unipodal.frameStamps, 'moment', 'Moment');

        % Calcul du peak de couple sur tout le cycle
        results.Right.momentMax_FullCycle = computeCustomCalculation(results.Right.moment_FullCycle, @max);
        results.Right.momentMin_FullCycle = computeCustomCalculation(results.Right.moment_FullCycle, @min);

        % Calcul du peak de couple au contact talon
        results.Right.momentMax_0_OppFootOff = computeCustomCalculation(results.Right.moment_0_OppFootOff, @max);
        results.Right.momentMin_0_OppFootOff = computeCustomCalculation(results.Right.moment_0_OppFootOff, @min);

        % Calcul du peak de couple du contact talon opposÃ©
        results.Right.momentMax_OppStrike_100 = computeCustomCalculation(results.Right.moment_OppStrike_100, @max);
        results.Right.momentMin_OppStrike_100 = computeCustomCalculation(results.Right.moment_OppStrike_100, @min);
        
        % Calcul du peak max et min du couple à opp foot strike
        results.Right.momentMax_Unipodal = computeCustomCalculation(results.Right.moment_Unipodal, @max);
        results.Right.momentMin_Unipodal = computeCustomCalculation(results.Right.moment_Unipodal, @min);
        
        
        % Extraction des puissances
        results.Right.power_FullCycle = extractData(data.Right, data.Right.stamps.Right_Foot_FullCycle.frameStamps, 'power', 'Power');
        results.Right.power_FullStance = extractData(data.Right, data.Right.stamps.Right_Foot_FullStance.frameStamps, 'power', 'Power');
        results.Right.power_OppStrike_PushOff = extractData(data.Right, data.Right.stamps.Right_Foot_OppStrike_PushOff.frameStamps, 'power', 'Power');

        % Calcul du peak max et min de la puissance lors de support
        results.Right.powerMax_FullCycle = computeCustomCalculation(results.Right.power_FullCycle, @max);
        results.Right.powerMin_FullCycle = computeCustomCalculation(results.Right.power_FullCycle, @min);
        
        % Calcul du peak max et min de la puissance lors de support
        results.Right.powerMax_FullStance = computeCustomCalculation(results.Right.power_FullStance, @max);
        results.Right.powerMin_FullStance = computeCustomCalculation(results.Right.power_FullStance, @min);

        % Calcul du peak max et min de la puissance lors de double appuie
        results.Right.powerMax_OppStrike_PushOff = computeCustomCalculation(results.Right.power_OppStrike_PushOff, @max);
        results.Right.powerMin_OppStrike_PushOff = computeCustomCalculation(results.Right.power_OppStrike_PushOff, @min);
    end
end
