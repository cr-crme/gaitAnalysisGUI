function writeExcelEachTrial(c)

    % Informations générique sur le fichier Ã  produire
    [folder, filename, extension] = fileparts(c.file.savepath);
    filepath = [folder filesep filename '_eachTrial' extension];
    sep = ',';
    
    header = {  
        % Param spatio-tempo
        '% de cycle Décollement (%) D'
        '% de cycle Décollement (%) G'
        '% de cycle Contact talon pied opposé (%) D'
        '% de cycle Contact talon pied opposé (%) G'
        '% de cycle Décollement pied opposé (%) D'
        '% de cycle Décollement pied opposé (%) G'
        '% de cycle Temps simple appuie (%) D'
        '% de cycle Temps simple appuie (%) G'
        'Param spatio-temporel Longueur pas (m) D'
        'Param spatio-temporel Longueur pas (m) G'
        'Param spatio-temporel Longueur cycle (m) D'
        'Param spatio-temporel Longueur cycle (m) G'
        'Param spatio-temporel Durée cycle (s) D'
        'Param spatio-temporel Durée cycle (s) G'
        'Param spatio-temporel Vitesse cycle (m/s) D'
        'Param spatio-temporel Vitesse cycle (m/s) G'
        'Param spatio-temporel Ratio marche (mm/pas/min) D'
        'Param spatio-temporel Ratio marche (mm/pas/min) G'
    };

    oldData = [];
    if isfile(filepath)
        data = readtable(filepath);
        oldData = data.Variables;
    end

    outdata = array2table([
        oldData;
        [
            [c.resultsAll.kin.Right.pctToeOff];
            [c.resultsAll.kin.Left.pctToeOff];
            [c.resultsAll.kin.Right.pctContactTalOppose];
            [c.resultsAll.kin.Left.pctContactTalOppose];
            [c.resultsAll.kin.Right.pctToeOffOppose];
            [c.resultsAll.kin.Left.pctToeOffOppose];
            [c.resultsAll.kin.Right.pctSimpleAppuie];
            [c.resultsAll.kin.Left.pctSimpleAppuie];
            [c.resultsAll.kin.Right.distPas];
            [c.resultsAll.kin.Left.distPas];
            [c.resultsAll.kin.Right.distFoulee];
            [c.resultsAll.kin.Left.distFoulee];
            [c.resultsAll.kin.Right.tempsFoulee];
            [c.resultsAll.kin.Left.tempsFoulee];
            [c.resultsAll.kin.Right.vitFoulee];
            [c.resultsAll.kin.Left.vitFoulee];
            [c.resultsAll.kin.Right.distPas]./[c.resultsAll.kin.Right.vitCadencePasParMinute];
            [c.resultsAll.kin.Left.distPas]./[c.resultsAll.kin.Left.vitCadencePasParMinute];
        ]';
    ]);
    
    outdata.Properties.VariableNames = header;
    writetable(outdata, filepath, 'Delimiter', sep);

end