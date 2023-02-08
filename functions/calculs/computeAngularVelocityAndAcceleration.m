function data = computeAngularVelocityAndAcceleration(results, data)

    dt = 1/data.angleInfos.frequency;
    fields = fieldnames(results.angAtFullCycle); % Prendre les noms ailleurs pour savoir quels articulation traite

   % This is a dirty patch that should be dealt elsewhere to account
    % for non-existent Thorax when using half body model
    if ~isfield('LThoraxAngles', data.angle)
       data.angle.('LThoraxAngles') = data.angle.('LHipAngles') * nan;
       data.angle.('RThoraxAngles') = data.angle.('RHipAngles') * nan;
    end

    for i = 1:length(fields)
        data.angle.([fields{i} 'Velocities']) = derive(data.angle.([fields{i} 'Angles']), dt);
        data.angle.([fields{i} 'Accelerations']) = derive(data.angle.([fields{i} 'Velocities']), dt);
    end

end
