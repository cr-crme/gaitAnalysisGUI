function results = kinParamOfCOM(results, data)
    % dt
    dt = 1/data.angleInfos.frequency;

    % Dérivation jusqu'à secousse
    results.comPosition = data.markers.CentreOfMass;
    results.comVitesse = derive(results.comPosition,dt);
    results.comAcceleration = derive(results.comVitesse,dt);
    results.comSecousse = derive(results.comAcceleration,dt);
    
  end