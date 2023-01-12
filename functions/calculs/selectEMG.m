function out = selectEMG(EMG, possibleLabels)

for i = 1:length(possibleLabels)
    if isfield(EMG.Analogs, possibleLabels{i})
        out = EMG.Analogs.(possibleLabels{i});
        return;
    end
end

% Fall back to default
allAnalogLabels = fieldnames(EMG.Analogs);
out = zeros(size(EMG.Analogs.(allAnalogLabels{1})));
