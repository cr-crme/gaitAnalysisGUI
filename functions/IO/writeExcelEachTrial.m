function writeExcelEachTrial(c)

    % Informations générique sur le fichier Ã  produire
    [folder, filename, extension] = fileparts(c.file.savepath);
    filepath = [folder filesep filename '_eachTrial' extension];
    sep = ',';
    
    header = {  
        % Param spatio-tempo
        '% de cycle Décollement (%)'
        '% de cycle Contact talon pied opposé (%)'
        '% de cycle Décollement pied opposé (%)'
        '% de cycle Temps simple appuie (%)'
        'Param spatio-temporel Longueur pas (m)'
        'Param spatio-temporel Longueur cycle (m)'
        'Param spatio-temporel Durée cycle (s)'
        'Param spatio-temporel Vitesse cycle (m/s)'
        'Param spatio-temporel Ratio marche (mm/pas/min)'
    };

    oldData = [];
    if isfile(filepath)
        data = readtable(filepath);
        oldData = data.Variables;
    end

    if ~isfield(c.resultsAll.kin, 'Left') && ~isfield(c.resultsAll.kin, 'Right')
        error('No data in the trial')
    end

    fieldsToCopy = {'pctToeOff', 'pctContactTalOppose', 'pctToeOffOppose', 'pctSimpleAppuie', 'distPas', 'distFoulee', 'tempsFoulee', 'vitFoulee', 'distPas', 'vitCadencePasParMinute'};
    if isfield(c.resultsAll.kin, 'Left')
        left = c.resultsAll.kin.Left;
    else
        for name = fieldsToCopy
            left.(name{1}) = nan(size(c.resultsAll.kin.Right.(name{1})));
        end
    end
    if isfield(c.resultsAll.kin, 'Right')
        right = c.resultsAll.kin.Right;
    else
        for name = fieldsToCopy
            right.(name{1}) = nan(size(c.resultsAll.kin.Left.(name{1})));
        end
    end

    outdata = array2table([
        oldData;
        [
            [[left.pctToeOff]'; [right.pctToeOff]'], ...
            [[left.pctContactTalOppose]'; [right.pctContactTalOppose]'], ...
            [[left.pctToeOffOppose]'; [right.pctToeOffOppose]'], ...
            [[left.pctSimpleAppuie]'; [right.pctSimpleAppuie]'], ...
            [[left.distPas]'; [right.distPas]'], ...
            [[left.distFoulee]'; [right.distFoulee]'], ...
            [[left.tempsFoulee]'; [right.tempsFoulee]'], ...
            [[left.vitFoulee]'; [right.vitFoulee]'], ...
            [[left.distPas]'./[left.vitCadencePasParMinute]'; [right.distPas]'./[right.vitCadencePasParMinute]'], ...
        ];
    ]);
    fprintf('Definition of each line: %dL - %dR\n', size([left.pctToeOff], 2), size([right.pctToeOff], 2));
    
    outdata.Properties.VariableNames = header;
    writetable(outdata, filepath, 'Delimiter', sep);

end
