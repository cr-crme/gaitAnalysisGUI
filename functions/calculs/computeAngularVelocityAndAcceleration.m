function data = computeAngularVelocityAndAcceleration(results, data)

    dt = 1/data.angleInfos.frequency;
    fields = fieldnames(results.angAtFullCycle); % Prendre les noms ailleurs pour savoir quels articulation traite

    for i = 1:length(fields)
        data.angle.([fields{i} 'Velocities']) = derive(data.angle.([fields{i} 'Angles']), dt);
        data.angle.([fields{i} 'Accelerations']) = derive(data.angle.([fields{i} 'Velocities']), dt);
    end

end
