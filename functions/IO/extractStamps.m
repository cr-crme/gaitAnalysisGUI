function stamps = extractStamps(stamps, freq)

    % Phase unipodale
    [stamps.Left_Foot_Unipodal.frameStamps, stamps.Left_Foot_Unipodal.timeStamps] ...
        = PerFoot(stamps.Right_Foot_Off.frameStamp, stamps.Right_Foot_Strike.frameStamp, freq);
    [stamps.Right_Foot_Unipodal.frameStamps, stamps.Right_Foot_Unipodal.timeStamps] ...
        = PerFoot(stamps.Left_Foot_Off.frameStamp, stamps.Left_Foot_Strike.frameStamp, freq);

    % Toute la phase où un pied touche le sol
    [stamps.Left_Foot_FullStance.frameStamps, stamps.Left_Foot_FullStance.timeStamps] ...
        = PerFoot(stamps.Left_Foot_Strike.frameStamp, stamps.Left_Foot_Off.frameStamp, freq);
    [stamps.Right_Foot_FullStance.frameStamps, stamps.Right_Foot_FullStance.timeStamps] ...
        = PerFoot(stamps.Right_Foot_Strike.frameStamp, stamps.Right_Foot_Off.frameStamp, freq);
    
    % Une foulée
    [stamps.Left_Foot_FullCycle.frameStamps, stamps.Left_Foot_FullCycle.timeStamps] ...
        = PerFoot(stamps.Left_Foot_Strike.frameStamp, stamps.Left_Foot_Strike.frameStamp, freq);
    [stamps.Right_Foot_FullCycle.frameStamps, stamps.Right_Foot_FullCycle.timeStamps] ...
        = PerFoot(stamps.Right_Foot_Strike.frameStamp, stamps.Right_Foot_Strike.frameStamp, freq);
     
    % From opposite push-off foot to 100%
    [stamps.Left_Foot_PushOffOpposite_100.frameStamps, stamps.Left_Foot_PushOffOpposite_100.timeStamps] ...
        = PerFoot(stamps.Right_Foot_Off.frameStamp, stamps.Left_Foot_Strike.frameStamp, freq);
    [stamps.Right_Foot_PushOffOpposite_100.frameStamps, stamps.Right_Foot_PushOffOpposite_100.timeStamps] ...
        = PerFoot(stamps.Left_Foot_Off.frameStamp, stamps.Right_Foot_Strike.frameStamp, freq);
     
    % From push-off to 100%
    [stamps.Left_Foot_PushOff_100.frameStamps, stamps.Left_Foot_PushOff_100.timeStamps] ...
        = PerFoot(stamps.Left_Foot_Off.frameStamp, stamps.Left_Foot_Strike.frameStamp, freq);
    [stamps.Right_Foot_PushOff_100.frameStamps, stamps.Right_Foot_PushOff_100.timeStamps] ...
        = PerFoot(stamps.Right_Foot_Off.frameStamp, stamps.Right_Foot_Strike.frameStamp, freq);
    
    % From strike (0%) to opposite foot push off
    [stamps.Left_Foot_0_OppPushOff.frameStamps, stamps.Left_Foot_0_OppPushOff.timeStamps] ...
        = PerFoot(stamps.Left_Foot_Strike.frameStamp, stamps.Right_Foot_Off.frameStamp, freq);
    [stamps.Right_Foot_0_OppPushOff.frameStamps, stamps.Right_Foot_0_OppPushOff.timeStamps] ...
        = PerFoot(stamps.Right_Foot_Strike.frameStamp, stamps.Left_Foot_Off.frameStamp, freq);
    
    % From opposite strike to strike (100%)
    [stamps.Left_Foot_OppStrike_100.frameStamps, stamps.Left_Foot_OppStrike_100.timeStamps] ...
        = PerFoot(stamps.Right_Foot_Strike.frameStamp, stamps.Left_Foot_Strike.frameStamp, freq);
    [stamps.Right_Foot_OppStrike_100.frameStamps, stamps.Right_Foot_OppStrike_100.timeStamps] ...
        = PerFoot(stamps.Left_Foot_Strike.frameStamp, stamps.Right_Foot_Strike.frameStamp, freq);
    
    % From opposite strike to push off
    [stamps.Left_Foot_OppStrike_PushOff.frameStamps, stamps.Left_Foot_OppStrike_PushOff.timeStamps] ...
        = PerFoot(stamps.Right_Foot_Strike.frameStamp, stamps.Left_Foot_Off.frameStamp, freq);
    [stamps.Right_Foot_OppStrike_PushOff.frameStamps, stamps.Right_Foot_OppStrike_PushOff.timeStamps] ...
        = PerFoot(stamps.Left_Foot_Strike.frameStamp, stamps.Right_Foot_Off.frameStamp, freq);
    
    % From 20% to 100%
    if isempty(stamps.Left_Foot_FullCycle.frameStamps) 
        stamps.Left_Foot_20_100.frameStamps{1} = [];
        stamps.Left_Foot_20_100.timeStamps{1} = [];
    else 
        for i = 1:length(stamps.Left_Foot_FullCycle.frameStamps)
            n = length(stamps.Left_Foot_FullCycle.frameStamps{i});
            stamps.Left_Foot_20_100.frameStamps{i} = stamps.Left_Foot_FullCycle.frameStamps{i}(round(n/5):round(n/5*4));
            stamps.Left_Foot_20_100.timeStamps{i} = stamps.Left_Foot_FullCycle.timeStamps{i}(round(n/5):round(n/5*4));
        end
    end
    if isempty(stamps.Right_Foot_FullCycle.frameStamps) 
        stamps.Right_Foot_20_100.frameStamps{1} = [];
        stamps.Right_Foot_20_100.timeStamps{1} = [];
    else 
        for i = 1:length(stamps.Right_Foot_FullCycle.frameStamps)
            n = length(stamps.Right_Foot_FullCycle.frameStamps{i});
            stamps.Right_Foot_20_100.frameStamps{i} = stamps.Right_Foot_FullCycle.frameStamps{i}(round(n/5):round(n/5*4));
            stamps.Right_Foot_20_100.timeStamps{i} = stamps.Right_Foot_FullCycle.timeStamps{i}(round(n/5):round(n/5*4));
        end
    end
end

function [frameStamp, timeStamp] = PerFoot(beginEvent, endEvent, freq)
    % Si on a un post événement qu'on enregistre avant, 
    % c'est qu'on a mesuré entre les deux. Il faut retirer la première
    % occurence
    if endEvent(1) <= beginEvent(1)
        endEvent = endEvent(2:end);  
        if length(beginEvent) ~= 1 % Si les données sont normalisé, ne par retirer la seule valeur
            beginEvent = beginEvent(1:end-1);
        end
    end

    % Préparer les cellules
    frameStamp = cell(min([length(beginEvent) length(endEvent)]),1);
    timeStamp = cell(min([length(beginEvent) length(endEvent)]),1);
    
    % Dispatch
    for i = 1:min([length(beginEvent) length(endEvent)])
        frameStamp{i} = beginEvent(i):endEvent(i);
        timeStamp{i} = frameStamp{i}*freq;
    end
end