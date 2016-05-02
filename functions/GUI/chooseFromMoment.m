function idx = chooseFromMoment(dataToShow, dataToShowName, nameAngToKeep, trialWithPlateForme)
    % Figure pour afficher les essais en terme d'angle afin d'élaguer les essais non pertinents
    h = figure( 'name', 'Choix des essais', ...
                'units', 'normalize', ...
                'menubar', 'none', ...
                'Position', [0.05 0.03 0.90 0.89]);
    axes('parent', h, 'units', 'normalize', 'position', [0.04, 0.11, 0.68, 0.82]);
    
    % Faire afficher tous les plots
    hold on
%     hplotmean{1} = confplot(nan, nan, nan, nan, 'LineWidth',2, 'color', 'r'); % Moyenne x
%     hplotmean{2} = confplot(nan, nan, nan, nan, 'LineWidth',2, 'color', 'g'); % Moyenne y
%     hplotmean{3} = confplot(nan, nan, nan, nan, 'LineWidth',2, 'color', 'b'); % Moyenne z
    hplotmean{1} = plot(nan, 'LineWidth',2, 'color', 'k'); % Moyenne x
    hplotmean{2} = plot(nan, 'LineWidth',2, 'color', 'k'); % Moyenne y
    hplotmean{3} = plot(nan, 'LineWidth',2, 'color', 'k'); % Moyenne z
    for i = 1:length(dataToShowName)
        if strfind(dataToShowName{i}, '_CôtéGauche_')
            hplot(i,1) = plot(nan, 'r--');  %#ok<AGROW> X 
            hplot(i,2) = plot(nan, 'r--');  %#ok<AGROW> Y
            hplot(i,3) = plot(nan, 'r--');  %#ok<AGROW> Z
        elseif strfind(dataToShowName{i}, '_CôtéDroit_')
            hplot(i,1) = plot(nan, 'g--');  %#ok<AGROW> X 
            hplot(i,2) = plot(nan, 'g--');  %#ok<AGROW> Y
            hplot(i,3) = plot(nan, 'g--');  %#ok<AGROW> Z
        end
   end
    
    % Demander si on affiche X,Y,Z
    xyzNames = {'Sagittal','Frontal', 'Transverse'};
    xyzPositions = [.21 .94 .1 .05
                    .31 .94 .1 .05
                    .41 .94 .1 .05];
    for i = 1:length(xyzNames)
        xyzCheck(i) = uicontrol('parent', h, ...
                'style', 'check', ...
                'value', true, ...
                'string',xyzNames{i}, ...
                'units', 'normalize', ...
                'position', xyzPositions(i,:)); %#ok<AGROW>
    end
    Echelle = uicontrol('parent', h, ...
                'style', 'check', ...
                'value', true, ...
                'string', 'Échelle fixe', ...
                'units', 'normalize', ...
                'position', [.65 .94 .1 .05]); 
    
    % Faire un pop menu pour le nameAngToKeep afin de permettre de les choisir
    pop = uicontrol(  'parent', h, ...
                      'style', 'pop', ...
                      'units', 'normalize', ...
                      'string', nameAngToKeep);
    position = get(pop,  'position'); % Garder la dimension par défaut
    set(pop, 'position', [0.75, 0.90, 0.22, position(4)]);

    % Faire afficher les dataToShow (dispatch les checkbox sur la droite)
    position = linspace(0.80, 0.15, length(dataToShowName));
    for i = 1:length(dataToShowName)
        check(i) = uicontrol(  'parent', h, ...
                            'style', 'check', ...
                            'value', true, ...
                            'string', dataToShowName{i}, ...
                            'units', 'normalize'); %#ok<AGROW>
        pos = get(check(i), 'position');
        set(check(i), 'position', [0.75 position(i) .5 pos(4)]);
        if isempty(intersect(trialWithPlateForme, i))
            set(check(i), 'value', false, 'enable', 'off') % S'il a été retiré dans la cinématique, on ne garde pas l'essai
        end
    end
    for i =1:length(xyzNames)
        set(xyzCheck(i), 'callback', {@addRemoveTrial, check, xyzCheck, dataToShow,hplot, hplotmean,pop, Echelle});
    end
    for i = 1:length(dataToShowName)
        set(check(i),  'callback', {@addRemoveTrial, check, xyzCheck, dataToShow,hplot, hplotmean,pop, Echelle});
    end
    for i = 1:length(pop)
        set(pop, 'callback', {@changeAngles, hplot, hplotmean, dataToShow, check, true, Echelle});
    end
    % Regarder où est la souris
    set(h, 'windowbuttonmotionfcn', {@boldPlot, check, hplot});
    set(Echelle, 'callback', {@setEchelleFixe, Echelle, hplot});
    
    % Bouton OK
    uicontrol(  'parent', h, ...
                'style', 'pushbutton', ...
                'string', 'Continue', ...
                'units', 'normalize', ...
                'callback', @closeWindow, ...
                'position', [0.80 .06 .1 .05]);
    
    set(Echelle, 'value', false);
    addRemoveTrial([],[],check,xyzCheck,dataToShow,hplot,hplotmean,pop,Echelle);
    set(Echelle, 'value', true);
    uiwait(h);
    
    % Une fois le choix fait 
    idx = trialToKeep(); % Recueillir ce qu'on a fait la dernière fois
end

function closeWindow(h,~)
    close(get(h,'parent'));
end


function boldPlot(h,~, check, hplot)
%     if verLessThan('matlab', '9')
        groot = 0;
%     end
    %Grandeur de l'écran
    screensize = get( groot, 'Screensize' );
    % Position de la fenêtre
    figPosition = get( h, 'Position' );
    % Position de la souris
    mousePosition = get(groot,'PointerLocation');
    mousePosition = mousePosition ./ screensize(3:4); % Mettre en relatif par rapport a l'écran
    mousePosition = mousePosition - figPosition(1:2); % Selon la figure
    mousePosition = mousePosition ./ figPosition(3:4); % Selon la figure
    
    % Tester une collision avec un check
    % Ils sont tous allignés à gauche 
    checkPos = get(check(1), 'position');
    % Si la souris est consignée en x
    hitCheckIdx = 0;
    if mousePosition(1) > checkPos(1) && mousePosition(1) < checkPos(1)+checkPos(3)
        for i = 1:length(check)
            checkPos = get(check(i), 'position');
            % Si la souris est consignée en y
            if mousePosition(2) > checkPos(2) && mousePosition(2) < checkPos(2)+checkPos(4)
                hitCheckIdx = i;
                break;
            end
        end
    end
    
    % Si hitCheckIdx == 0, alors on n'est pas sur un check
    if hitCheckIdx == 0
        for i = 1:size(hplot,1)
            set( hplot(i,1), 'linewidth', .5 )
            set( hplot(i,2), 'linewidth', .5 )
            set( hplot(i,3), 'linewidth', .5 )
        end
    else
        for i = 1:size(hplot,1)
            if i == hitCheckIdx
                set( hplot(i,1), 'linewidth', 3 )
                set( hplot(i,2), 'linewidth', 3 )
                set( hplot(i,3), 'linewidth', 3 )
            else
                set( hplot(i,1), 'linewidth', .5 )
                set( hplot(i,2), 'linewidth', .5 )
                set( hplot(i,3), 'linewidth', .5 )
            end
        end
    end
end

function idxout = trialToKeep(check)
    persistent idx
        
    if nargin < 1
        idxout = idx;
        clear idx; % vider la variable persistante
        return;
    end
    
    idx = [];
    for i=1:length(check)
       if get(check(i), 'value') == true
           idx = [idx i]; %#ok<AGROW>
       end
    end
    idxout = idx;
end

function [m, s] = meanStdTrials(d,check)
    idxToKeep =  trialToKeep(check);

    names = fieldnames(d);
    for i = 1:length(names)
       m.(names{i}) = mean(d.(names{i})(:,:,idxToKeep), 3); 
       s.(names{i}) = std(d.(names{i})(:,:,idxToKeep), [], 3);
    end
end

function setEchelleFixe(~,~,h,hplot)
    ax = get(hplot(1,1), 'parent');
    if get(h, 'value')
        set(ax, 'ylimmode', 'manual');
    else
        set(ax, 'ylimmode', 'auto');
    end
end

function addRemoveTrial(~,~,check,xyzCheck,dataToShow,hplot,hplotmean,pop,EchelleFixe)
    setEchelleFixe([],[],EchelleFixe,hplot);

    % Faire afficher ou ne plus faire afficher un hplot
    for i = 1:length(check)
        if get(check(i), 'value') 
            for j =1:3
                if get(xyzCheck(j), 'value')
                    set(hplot(i,j), 'visible', 'on')
                else
                    set(hplot(i,j), 'visible', 'off')
                end
            end
        else
            set(hplot(i,1), 'visible', 'off')
            set(hplot(i,2), 'visible', 'off')
            set(hplot(i,3), 'visible', 'off')
        end
    end
    
    % Si on a retiré x, y, ou z
    for iC = 1:length(xyzCheck)
        if get(xyzCheck(iC), 'value')
            set(hplotmean{iC}, 'visible', 'on');
        else
            set(hplotmean{iC}, 'visible', 'off');
        end
    end
    changeAngles(pop,[],hplot,hplotmean,dataToShow,check,false);
end

function changeAngles(h,~,hplot,hplotmean,dataToShow,checkTrial,calledViaGUI, Echelle)
    if calledViaGUI
        % Si on a appelé par le GUI, c'est qu'on change l'angle, il faut
        % donc forcer le rescaling
        old = get(Echelle, 'value');
        set(Echelle, 'value', 0);
        setEchelleFixe([],[],Echelle,hplot);
        set(Echelle, 'value', old);
    end

    % Changer les graphique selon ce qui est sélectionné
    n = get(h, 'string');
    n = n{get(h, 'value')};
    for i = 1:size(hplot,1)
        set(hplot(i,1), 'xdata', 1:100, 'ydata', dataToShow.(n)(:,1,i));
        set(hplot(i,2), 'xdata', 1:100, 'ydata', dataToShow.(n)(:,2,i));
        set(hplot(i,3), 'xdata', 1:100, 'ydata', dataToShow.(n)(:,3,i));
    end
    
    % Calculer et afficher la moyenne
    [m, s] = meanStdTrials(dataToShow, checkTrial); %#ok<ASGLU>
    set(hplotmean{1}, 'xdata', 1:100, 'ydata', m.(n)(:,1));
    set(hplotmean{2}, 'xdata', 1:100, 'ydata', m.(n)(:,2));
    set(hplotmean{3}, 'xdata', 1:100, 'ydata', m.(n)(:,3));
%     set(hplotmean{1}, 'xdata', 1:100, 'ydata', m.(n)(:,1)+s.(n)(:,1));
%     set(hplotmean{1}, 'xdata', 1:100, 'ydata', m.(n)(:,1)-s.(n)(:,1));
end
