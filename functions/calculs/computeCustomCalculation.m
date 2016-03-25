function data2 = computeCustomCalculation(data, func, varargin)
    

    fields = fieldnames(data);
    
    for i = 1:length(fields)
        nRep = length(data.(fields{i}));
        if ~isempty(data.(fields{i})) && ~isempty(data.(fields{i}){1})
            nValues = size(data.(fields{i}){1},2);
            data2.(fields{i}) = nan(nRep, nValues);
            for j = 1:nRep
                data2.(fields{i})(j,:) = func(data.(fields{i}){j},varargin{:});
            end
        else
            data2.(fields{i}) = nan;
        end
    end
    
end

