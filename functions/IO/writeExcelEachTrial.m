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

    outdata = array2table([
        oldData;
        [
            [[c.resultsAll.kin.Left.pctToeOff]'; [c.resultsAll.kin.Right.pctToeOff]'], ...
            [[c.resultsAll.kin.Left.pctContactTalOppose]'; [c.resultsAll.kin.Right.pctContactTalOppose]'], ...
            [[c.resultsAll.kin.Left.pctToeOffOppose]'; [c.resultsAll.kin.Right.pctToeOffOppose]'], ...
            [[c.resultsAll.kin.Left.pctSimpleAppuie]'; [c.resultsAll.kin.Right.pctSimpleAppuie]'], ...
            [[c.resultsAll.kin.Left.distPas]'; [c.resultsAll.kin.Right.distPas]'], ...
            [[c.resultsAll.kin.Left.distFoulee]'; [c.resultsAll.kin.Right.distFoulee]'], ...
            [[c.resultsAll.kin.Left.tempsFoulee]'; [c.resultsAll.kin.Right.tempsFoulee]'], ...
            [[c.resultsAll.kin.Left.vitFoulee]'; [c.resultsAll.kin.Right.vitFoulee]'], ...
            [[c.resultsAll.kin.Left.distPas]'./[c.resultsAll.kin.Left.vitCadencePasParMinute]'; [c.resultsAll.kin.Right.distPas]'./[c.resultsAll.kin.Right.vitCadencePasParMinute]'], ...
        ];
    ]);
    fprintf('Left most column %s\n', ...
        [repmat('L', size([c.resultsAll.kin.Left.pctToeOff], 2), 1); repmat('R', size([c.resultsAll.kin.Right.pctToeOff], 2), 1)] ...
    )
    
    outdata.Properties.VariableNames = header;
    writetable(outdata, filepath, 'Delimiter', sep);

end