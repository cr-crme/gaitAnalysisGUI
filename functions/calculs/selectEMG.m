function out = selectEMG(EMG, name, possibleLabels)

for label = possibleLabels
    if isfield(EMG.Analogs, label)
        out = EMG.Analogs.(labels);
        return;
    end
end

errordlg([name ' non trouvé']);
