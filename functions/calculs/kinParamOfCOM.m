function results = kinParamOfCOM(results, data)
    % dt
    dt = 1/data.angleInfos.frequency;

    % Dérivation jusqu'à secousse
    if isfield('CentreOfMass', data.markers)
        results.comPosition = data.markers.CentreOfMass;
    else 
        results.comPosition = data.markers.LTOE * nan;
    end
    results.comVitesse = derive(results.comPosition,dt);
    results.comAcceleration = derive(results.comVitesse,dt);
    results.comSecousse = derive(results.comAcceleration,dt);
    
  end