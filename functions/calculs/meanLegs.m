function rMean = meanLegs(rLeft, rRight)

    % Aller chercher les fields qu'il faut moyenner
    fields = fieldnames(rLeft);
    
    for iF = 1:length(fields)
        if strcmp( fields{iF}(1), 'R')  
            % Si la première lettre est R, c'est que c'est quelque chose du
            % type 'Rarticulation' or, ceci est moyenné, donc ne pas la
            % réutiliser
            continue 
        end
        if isnumeric(rLeft.(fields{iF})) || islogical(rLeft.(fields{iF})) 
            val = [];
            if strcmp( fields{iF}(1), 'L')  
                 % Si la première lettre est L, c'est que c'est quelque chose du
                % type 'Larticulation'
                val(:,:,:,1) = rLeft.(fields{iF}); % Le mettre sur la 4e car rien n'est sur 4
                val(:,:,:,2) = rRight.(['R' fields{iF}(2:end)]); % Le mettre sur la 4e car rien n'est sur 4
                rMean.(fields{iF}(2:end)) = nmean(val, 4);
            else
                val(:,:,:,1) = rLeft.(fields{iF}); % Le mettre sur la 4e car rien n'est sur 4
                val(:,:,:,2) = rRight.(fields{iF}); % Le mettre sur la 4e car rien n'est sur 4
                rMean.(fields{iF}) = nmean(val, 4);
            end
        elseif iscell(rLeft.(fields{iF}))
            if isempty(rLeft.(fields{iF}))
                rMean.(fields{iF}) = rLeft.(fields{iF});
            else
                for i = 1:length(rLeft.(fields{iF}))
                    if size(rLeft.(fields{iF}){i},1) == 1 || size(rLeft.(fields{iF}){i},1) == 100
                        val = [];
                        if strcmp( fields{iF}(1), 'L')  
                            val(:,:,:,1) = rLeft.(fields{iF}){i}; % Le mettre sur la 4e car rien n'est sur 4
                            val(:,:,:,2) = rRight.(['R' fields{iF}(2:end)]){i}; % Le mettre sur la 4e car rien n'est sur 4
                            % Ne pas moyenner si c'est un truc au cours du temps,
                            % ça n'est pas une valeur de sortie de toute façon
                            rMean.(fields{iF}(2:end)){i} = nmean(val,4);
                        else
                            val(:,:,:,1) = rLeft.(fields{iF}){i}; % Le mettre sur la 4e car rien n'est sur 4
                            val(:,:,:,2) = rRight.(fields{iF}){i}; % Le mettre sur la 4e car rien n'est sur 4
                            % Ne pas moyenner si c'est un truc au cours du temps,
                            % ça n'est pas une valeur de sortie de toute façon
                            rMean.(fields{iF}){i} = nmean(val,4);
                        end
                        
                        
                    else
                        rMean.(fields{iF}){i} = [];
                    end
                end
            end
        elseif isstruct(rLeft.(fields{iF}))
            % Si c'est une structure, appeler la fonction de façon récursive
            rMean.(fields{iF}) = meanLegs(rLeft.(fields{iF}), rRight.(fields{iF})); 
        end
        
    end
end
    