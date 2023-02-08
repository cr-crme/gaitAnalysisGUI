function newStruct = createEmptyStructFromStruct(originStruct)
     fields = fieldnames(originStruct);
     for i = 1:length(fields)
         field = fields{i};
         if isstruct(originStruct(1).(field))
            newStruct.(field) = createEmptyStructFromStruct(originStruct(1).(field));
         else
             newStruct.(field) = [];
         end
     end
end
 