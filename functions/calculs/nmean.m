function out = nmean(data, dim)

    persistent vers
    if isempty(vers)
        % Déterminer la version pour savoir s'il faut utiliser nanmean ou 'omitnan'
        a = version;
        idx1 = strfind(a, '(');
        idx2 = strfind(a, ')');
        vers_tp = str2double(a(idx1+2:idx2-2));
        if vers_tp < 2015
            vers = false;
        else
            vers = true;
        end
        clear a idx 1 idx2 vers_tp
    end
    
    if vers
        out = mean(data, dim, 'omitnan');
    else
        % Attention, ceci nécessite la toolbox statistique
        out = nanmean(data, dim);
    end
end