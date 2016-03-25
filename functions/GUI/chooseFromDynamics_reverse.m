function idx = chooseFromDynamics(dataToShow, dataToShowName, trialWithPlateForme)
    % Figure pour afficher les essais en terme d'angle afin d'élaguer les essais non pertinents
    h = figure( 'name', 'Choix des essais', ...
                'units', 'normalize', ...
                'menubar', 'none', ...
                'Position', [0.05 0.03 0.90 0.89]);
    axes('parent', h, 'units', 'normalize', 'position', [0.04, 0.11, 0.68, 0.82]);
    
    % Faire afficher tous les plots
    hold on
    for i = 1:length(dataToShow)
        for j=1:6 % Fx, Fy, Fz, Mx, My, Mz
            hplot(i,j) = plot(nan);  %#ok<AGROW>
        end
    end
    
    % Demander si on affiche toutes les composantes
    xyzNames = {'FxData', 'FyData', 'FzData', 'MxData', 'MyData', 'MzData'};
    xyzPositions = [.10 .94 .1 .05
                    .20 .94 .1 .05
                    .30 .94 .1 .05
                    .40 .94 .1 .05
                    .50 .94 .1 .05
                    .60 .94 .1 .05];
    for i = 1:length(xyzNames)
        xyzCheck(i) = uicontrol('parent', h, ...
                'style', 'check', ...
                'value', false, ...
                'string',xyzNames{i}, ...
                'units', 'normalize', ...
                'position', xyzPositions(i,:)); %#ok<AGROW>
    end
    set(xyzCheck(3), 'value', true); % De base, ne mettre que Fz
    
    
    % Faire un pop menu pour le nombre de plateforme
    for i = 1:length(dataToShow(1).pf)
        namePF{i} = sprintf('PlateForme %d', i); %#ok<AGROW>
    end
    pop = uicontrol(  'parent', h, ...
                      'style', 'pop', ...
                      'units', 'normalize', ...
                      'string', namePF);
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
    end
    for i =1:length(xyzNames)
        set(xyzCheck(i), 'callback', {@addRemoveTrial, check, xyzCheck, dataToShow,hplot,pop});
    end
    for i = 1:length(dataToShowName)
        if isempty(intersect(trialWithPlateForme, i))
            set(check(i), 'value', false, 'enable', 'off') % S'il a été retiré dans la cinématique, on ne garde pas l'essai
        end
        set(check(i),  'callback', {@addRemoveTrial, check, xyzCheck, dataToShow,hplot,pop});
    end
    for i = 1:length(pop)
        set(pop, 'callback', {@changeAngles, hplot, dataToShow, check});
    end
    
    % Bouton OK
    uicontrol(  'parent', h, ...
                'style', 'pushbutton', ...
                'string', 'Continue', ...
                'units', 'normalize', ...
                'callback', @closeWindow, ...
                'position', [0.80 .06 .1 .05]);
    
    addRemoveTrial([],[],check,xyzCheck,dataToShow,hplot,pop);
    uiwait(h);
    
    % Une fois le choix fait 
    idx = trialToKeep(); % Recueillir ce qu'on a fait la dernière fois
end

function closeWindow(h,~)
    close(get(h,'parent'));
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


function addRemoveTrial(~,~,check,xyzCheck,dataToShow,hplot,pop)
    % Faire afficher ou ne plus faire afficher un hplot
    for i = 1:length(check)
        if get(check(i), 'value') 
            for j =1:length(xyzCheck)
                if get(xyzCheck(j), 'value')
                    set(hplot(i,j), 'visible', 'on')
                else
                    set(hplot(i,j), 'visible', 'off')
                end
            end
        else
            for j =1:length(xyzCheck)
                set(hplot(i,j), 'visible', 'off');
            end
        end
    end
    
    changeAngles(pop,[],hplot,dataToShow, check);
end

function changeAngles(h,~,hplot,dataToShow, check)
    % Changer les graphique selon ce qui est sélectionné
    n = get(h, 'value');
    for i = 1:size(hplot,1)
        names = fieldnames(dataToShow(i).pf(n).channels);
        for j=1:length(names)
            set(hplot(i,j), 'xdata', 1:length(dataToShow(i).pf(n).channels.(names{j})), 'ydata', dataToShow(i).pf(n).channels.(names{j}));
        end
    end
    
    trialToKeep(check);
end
