 
function [dataAll, file, c3d] = openAndParseC3Ds(file, selectAllCycle)
    if isempty(file.names)
        dataAll.Left = [];
        dataAll.Right = [];
        file = []; 
        c3d = [];
        return;
    end
     
 
    % Parse and open
    cmpLeft = 1;
    cmpRight = 1;
    for i=1:length(file.names)
        [~,file.names{i},file.ext{i}] = fileparts(file.names{i});
        file.fullpath{i} = [file.path file.names{i} file.ext{i}];
        
        % Ouvrir un fichier C3D
        c3d(i) = c3dRead(file.fullpath{i}); %#ok<AGROW>
        
        try
            data = extractDataFromC3D(c3d(i), selectAllCycle);
        catch me
            uiwait(errordlg(sprintf('Le fichier %s a retourné l''erreur suivante : \n %s', file.names{i}, me.message)));
            rethrow(me);    
        end
        
        
        % Reclasser les données (faire qu'un essai soit un "fichier")
        if isfield(data.norm, 'Left')
            for j = 1:length(data.norm.Left)
                data.norm.Left(j).filename = sprintf('%s_CôtéGauche_%d', file.names{i}, j);
                % Calcul spécial pour le centre de masse, calculer tout de suite le médiolatéral 
                data.norm.Left(j).CentreOfMass.ml = abs(max(data.norm.Left(j).markers.CentreOfMassInRef(:,1)) - min(data.norm.Left(j).markers.CentreOfMassInRef(:,1)));
                
                BS_Left_Foot_0_OppPushOff = abs(data.norm.Left(j).markers.LTOEInRef(data.norm.Left(j).stamps.Left_Foot_0_OppPushOff.frameStamps{:},1) - data.norm.Left(j).markers.RTOEInRef(data.norm.Left(j).stamps.Left_Foot_0_OppPushOff.frameStamps{:},1));
                data.norm.Left(j).baseSustentation.maxPreMoyenne = max(BS_Left_Foot_0_OppPushOff);
                data.norm.Left(j).baseSustentation.minPreMoyenne = min(BS_Left_Foot_0_OppPushOff);
                
                dataAll.Left(cmpLeft) = data.norm.Left(j); 
                cmpLeft = cmpLeft+1;
            end
        end
        if isfield(data.norm, 'Right')
            for j = 1:length(data.norm.Right)
                data.norm.Right(j).filename = sprintf('%s_CôtéDroit_%d', file.names{i}, j);
                % Calcul spécial pour le centre de masse, calculer tout de suite le médiolatéral 
                data.norm.Right(j).CentreOfMass.ml = abs(max(data.norm.Right(j).markers.CentreOfMassInRef(:,1)) - min(data.norm.Right(j).markers.CentreOfMassInRef(:,1)));
                
                BS_Right_Foot_0_OppPushOff = abs(data.norm.Right(j).markers.RTOEInRef(data.norm.Right(j).stamps.Right_Foot_0_OppPushOff.frameStamps{:},1) - data.norm.Right(j).markers.LTOEInRef(data.norm.Right(j).stamps.Right_Foot_0_OppPushOff.frameStamps{:},1));
                data.norm.Right(j).baseSustentation.maxPreMoyenne = max(BS_Right_Foot_0_OppPushOff);
                data.norm.Right(j).baseSustentation.minPreMoyenne = min(BS_Right_Foot_0_OppPushOff);
                
                dataAll.Right(cmpRight) = data.norm.Right(j);
                cmpRight = cmpRight+1;
            end
        end
    end
    % Prendre les infos du derniers (ils sont sensés être tous les mêmes)
    if isfield(data.norm, 'Left')
        dataAll.Left(1).angleInfos = data.angleInfos;
        dataAll.Left(1).angleInfos.frequency = 1/(dataAll.Left(1).tempsCycle/100);
    end
    
    if isfield(data.norm, 'Right')
        dataAll.Right(1).angleInfos = data.angleInfos;
        dataAll.Right(1).angleInfos.frequency = 1/(dataAll.Right(1).tempsCycle/100);
    end
end