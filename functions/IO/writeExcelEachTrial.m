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
            get(c.resultsAll.kin, 'Right', 'pctToeOff');
            get(c.resultsAll.kin, 'Left', 'pctToeOff');
            get(c.resultsAll.kin, 'Right', 'pctContactTalOppose');
            get(c.resultsAll.kin, 'Left', 'pctContactTalOppose');
            get(c.resultsAll.kin, 'Right', 'pctToeOffOppose');
            get(c.resultsAll.kin, 'Left', 'pctToeOffOppose');
            get(c.resultsAll.kin, 'Right', 'pctSimpleAppuie');
            get(c.resultsAll.kin, 'Left', 'pctSimpleAppuie');
            get(c.resultsAll.kin, 'Right', 'distPas');
            get(c.resultsAll.kin, 'Left', 'distPas');
            get(c.resultsAll.kin, 'Right', 'distFoulee');
            get(c.resultsAll.kin, 'Left', 'distFoulee');
            get(c.resultsAll.kin, 'Right', 'tempsFoulee');
            get(c.resultsAll.kin, 'Left', 'tempsFoulee');
            get(c.resultsAll.kin, 'Right', 'vitFoulee');
            get(c.resultsAll.kin, 'Left', 'vitFoulee');
            get(c.resultsAll.kin, 'Right', 'distPas')./get(c.resultsAll.kin, 'Right', 'vitCadencePasParMinute');
            get(c.resultsAll.kin, 'Left', 'distPas')./get(c.resultsAll.kin, 'Left', 'vitCadencePasParMinute');
        ]';
    ]);
    
    outdata.Properties.VariableNames = header;
    writetable(outdata, filepath, 'Delimiter', sep);

end

function n = getNbData(kin)
    n = [-inf, -inf];
    if isfield(kin, 'Right')
        n(1) = length([kin.Right.pctToeOff]);
    end
    if isfield(kin, 'Left')
        n(2) = length([kin.Left.pctToeOff]);
    end
    n = max(n);
end

function data = get(kin, side, field)
    if ~isfield(kin, side) || ~isfield(kin.(side), field)
        n = getNbData(kin);
        data = nan(1, n);
        return
    end
    data = [kin.(side).(field)];
end