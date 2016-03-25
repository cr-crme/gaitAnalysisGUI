function idx = chooseFromDynamics(dataToShow, dataToShowName, trialWithPlateForme)
    % Figure pour afficher les essais en terme d'angle afin d'élaguer les essais non pertinents
    h = figure( 'name', 'Choix des essais', ...
                'units', 'normalize', ...
                'menubar', 'none', ...
                'Position', [0.05 0.03 0.90 0.89]);
    axes('parent', h, 'units', 'normalize', 'position', [0.04, 0.11, 0.68, 0.82]);
    
    
    % Demander si on affiche toutes les composantes% Combien de plateforme + leur nom
    for i = 1:length(dataToShow(1).pf)
        namePF{i} = sprintf('PlateForme %d', i); %#ok<AGROW>
        pfPositions(i,:) = [.10+.1*i .94 .1 .05]; %#ok<AGROW>
    end
    
    % Faire afficher tous les plots
    hold on
    for i = 1:length(dataToShow)
        for j=1:length(namePF) % pour chaque PF
            hplot(i,j) = plot(nan);  %#ok<AGROW>
        end
    end
    
   % Checkbox pour savoir quelle plate forme afficher (inutile si les essais sont triés) 
    for i = 1:length(namePF)
        pfCheck(i) = uicontrol('parent', h, ...
                'style', 'check', ...
                'value', true, ...
                'string',namePF{i}, ...
                'units', 'normalize', ...
                'visible', 'off', ...
                'position', pfPositions(i,:)); %#ok<AGROW>
    end
    Echelle = uicontrol('parent', h, ...
                'style', 'check', ...
                'value', true, ...
                'string', 'Échelle fixe', ...
                'units', 'normalize', ...
                'position', [.65 .94 .1 .05]); 
    
    % Faire un pop menu pour le nombre de plateforme
    composantesNames = {'FxData', 'FyData', 'FzData', 'MxData', 'MyData', 'MzData'};
    pop = uicontrol(  'parent', h, ...
                      'style', 'pop', ...
                      'units', 'normalize', ...
                      'string', composantesNames);
    position = get(pop,  'position'); % Garder la dimension par défaut
    set(pop, 'position', [0.75, 0.90, 0.22, position(4)]);
    set(pop, 'value', 3); % De base, ne mettre que Fz
    
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
    for i =1:length(namePF)
        set(pfCheck(i), 'callback', {@addRemoveTrial, check, pfCheck, dataToShow,hplot,pop,Echelle});
    end
    for i = 1:length(dataToShowName)
        if isempty(intersect(trialWithPlateForme, i))
            set(check(i), 'value', false, 'enable', 'off') % S'il a été retiré dans la cinématique, on ne garde pas l'essai
        end
        set(check(i),  'callback', {@addRemoveTrial, check, pfCheck, dataToShow,hplot,pop,Echelle});
    end
    for i = 1:length(pop)
        set(pop, 'callback', {@changeAngles, hplot, dataToShow, check, true, Echelle});
    end
    set(Echelle, 'callback', {@setEchelleFixe, Echelle, hplot});
    
    % Bouton OK
    uicontrol(  'parent', h, ...
                'style', 'pushbutton', ...
                'string', 'Continue', ...
                'units', 'normalize', ...
                'callback', @closeWindow, ...
                'position', [0.80 .06 .1 .05]);
    
    addRemoveTrial([],[],check,pfCheck,dataToShow,hplot,pop, Echelle);
    changeAngles(pop,[],hplot,dataToShow, check,true, Echelle);
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

function setEchelleFixe(~,~,h,hplot)
    ax = get(hplot(1,1), 'parent');
    if get(h, 'value')
        set(ax, 'ylimmode', 'manual');
    else
        set(ax, 'ylimmode', 'auto');
    end
end

function addRemoveTrial(~,~,check,pfCheck,dataToShow,hplot,pop,EchelleFixe)
    setEchelleFixe([],[],EchelleFixe,hplot);

    % Faire afficher ou ne plus faire afficher un hplot
    for i = 1:length(check)
        if get(check(i), 'value') 
            for j =1:length(pfCheck)
                if get(pfCheck(j), 'value')
                    set(hplot(i,j), 'visible', 'on')
                else
                    set(hplot(i,j), 'visible', 'off')
                end
            end
        else
            for j =1:length(pfCheck)
                set(hplot(i,j), 'visible', 'off');
            end
        end
    end
    
    changeAngles(pop,[],hplot,dataToShow, check, false);
end

function changeAngles(h,~,hplot,dataToShow, check,calledViaGUI, Echelle)
    if calledViaGUI
        % Si on a appelé par le GUI, c'est qu'on change l'angle, il faut
        % donc forcer le rescaling
        old = get(Echelle, 'value');
        set(Echelle, 'value', 0);
        setEchelleFixe([],[],Echelle,hplot);
        set(Echelle, 'value', old);
    end
    
    % Changer les graphique selon ce qui est sélectionné
    n =get(h, 'value');
    for i = 1:size(hplot,1)
        for j=1:length(dataToShow(i).pf)
            names = fieldnames(dataToShow(i).pf(j).channels);
            set(hplot(i,j), 'xdata', (1:length(dataToShow(i).pf(j).channels.(names{n})))/10, 'ydata', dataToShow(i).pf(j).channels.(names{n}));
        end
    end
    
    trialToKeep(check);
end
