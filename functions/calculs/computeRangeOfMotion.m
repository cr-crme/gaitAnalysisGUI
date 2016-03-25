function data2 = computeRangeOfMotion(dataMax, dataMin)

    fields = fieldnames(dataMax);

    for i = 1:length(fields)
        data2.(fields{i}) = dataMax.(fields{i}) - dataMin.(fields{i});
    end
    
end