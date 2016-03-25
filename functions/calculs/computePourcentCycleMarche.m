function data = computePourcentCycleMarche(data)
    tp_field = fieldnames(data.angle);
    NFrameTotal = size(data.angle.(tp_field{1}),1);

    % Faire le mapping
    data.stamps.CycleMarcheLeft = PerFoot(data.stamps.Left_Foot_Strike.frameStamp, NFrameTotal);
    data.stamps.CycleMarcheRight = PerFoot(data.stamps.Right_Foot_Strike.frameStamp, NFrameTotal);

end

function out = PerFoot(f, NFrameTotal)
    out = nan(1,NFrameTotal);
    out(1:f(1)-1) = -1; % Le début et la fin de l'essai n'est pas mappé
    out(f(end):end) = -1;
    for i = 1:length(f)-1
        out(f(i):f(i+1)-1) = linspace(0,100,f(i+1) - f(i));
    end
    
end