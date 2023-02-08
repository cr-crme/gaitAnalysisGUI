function EMG = extractmultipleEMG(c3d)

nMuscles = 14;
emgLabels.RightGluteus = {'Right_Gluteus_me', 'Right_Gluteus_me', 'Voltage_Right_Gluteus_me'};
emgLabels.LeftGluteus = {'Left_Gluteus_med', 'Left_Gluteus_me_', 'Voltage_Left_Gluteus_med'};
emgLabels.RightRectus = {'Right_Rectus_fem', 'Voltage_Right_Rectus_fem'};
emgLabels.LeftRectus = {'Left_Rectus_femo', 'Voltage_Left_Rectus_femo'};
emgLabels.RightSemitendin = {'Right_Rectus_fem', 'Voltage_Right_Semitendin'};
emgLabels.LeftSemitendin = {'Left_Rectus_femo', 'Voltage_Left_Semitendino'};
emgLabels.RightVastusLat = {'Right_Vastus_lat', 'Voltage_Right_Vastus_lat'};
emgLabels.LeftVastusLat = {'Left_Vastus_late', 'Voltage_Left_Vastus_late'};
emgLabels.RightGastroc = {'Right_Gastrocnem', 'Voltage_Right_Gastrocnem'};
emgLabels.LeftGastroc = {'Left_Gastrocnemi', 'Voltage_Left_Gastrocnemi'};
emgLabels.RightTibialis = {'Right_Tibialis_a', 'Voltage_Right_Tibialis_a'};
emgLabels.LeftTibialis = {'Left_Tibialis_an', 'Voltage_Left_Tibialis_an'};
emgLabels.RightPeroneal = {'Voltage_Right_Peroneus_l'};
emgLabels.LeftPeroneal = {'Voltage_Left_Peroneus_lo'};

a = 1;
for i = 1:size(c3d,2)
    
    %Pour l'EMG
    EMG = extractEMG(c3d(i));
    results = meanPercentageEMG(EMG,c3d(i), emgLabels);
    
    Right_Gluteuspct(i,:) = results.meanpct.Right_Gluteus; %#ok<AGROW> 
    Left_Gluteuspct(i,:) = results.meanpct.Left_Gluteus; %#ok<AGROW> 
   

    Right_Rectuspct(i,:) = results.meanpct.Right_Rectus; %#ok<AGROW> 
    Left_Rectuspct(i,:) = results.meanpct.Left_Rectus; %#ok<AGROW> 
   
    Right_Semitendinpct(i,:) = results.meanpct.Right_Semitendin; %#ok<AGROW> 
    Left_Semitendinpct(i,:) = results.meanpct.Left_Semitendin; %#ok<AGROW> 
   
    Right_Lateralpct(i,:) = results.meanpct.Right_Lateral; %#ok<AGROW> 
    Left_Lateralpct(i,:) = results.meanpct.Left_Lateral; %#ok<AGROW> 
   
    Right_Gastrocnempct(i,:) = results.meanpct.Right_Gastrocnem; %#ok<AGROW> 
    Left_Gastrocnempct(i,:) = results.meanpct.Left_Gastrocnem; %#ok<AGROW> 
  
    Right_Tibialispct(i,:) = results.meanpct.Right_Tibialis;  %#ok<AGROW> 
    Left_Tibialispct(i,:) = results.meanpct.Left_Tibialis; %#ok<AGROW> 
    
    Right_Peronealpct(i,:) = results.meanpct.Right_Peroneal;  %#ok<AGROW> 
    Left_Peronealpct(i,:) = results.meanpct.Left_Peroneal; %#ok<AGROW> 
    

%     %%Pour ACTIVATION
  

    Muscles(a:a+(nMuscles-1),1:size(results.Right_Gluteus,1)) = [
        results.Right_Gluteus'; 
        results.Left_Gluteus';
        results.Right_Rectus';
        results.Left_Rectus';
        results.Right_Semitendin';
        results.Left_Semitendin';
        results.Right_Lateral'; 
        results.Left_Lateral';
        results.Right_Gastrocnem';
        results.Left_Gastrocnem';
        results.Right_Tibialis';
        results.Left_Tibialis'
        results.Right_Peroneal';
        results.Left_Peroneal'
    ];

    Mean_raw_EMG(a:a+(nMuscles-1),:)= [
        results.mean.Right_Gluteus;
        results.mean.Left_Gluteus;
        results.mean.Right_Rectus;
        results.mean.Left_Rectus;
        results.mean.Right_Semitendin;
        results.mean.Left_Semitendin;
        results.mean.Right_Lateral;
        results.mean.Left_Lateral;
        results.mean.Right_Gastrocnem;
        results.mean.Left_Gastrocnem;
        results.mean.Right_Tibialis;
        results.mean.Left_Tibialis
        results.mean.Right_Peroneal;
        results.mean.Left_Peroneal
    ];

    a=a+nMuscles;   
end

EMG.results.meanpct.Right_Gluteus = mean(Right_Gluteuspct,1);
EMG.results.meanpct.Left_Gluteus = mean(Left_Gluteuspct,1);

EMG.results.meanpct.Right_Rectus = mean(Right_Rectuspct,1);
EMG.results.meanpct.Left_Rectus = mean(Left_Rectuspct,1);

EMG.results.meanpct.Right_Semitendin = mean(Right_Semitendinpct,1);
EMG.results.meanpct.Left_Semitendin= mean(Left_Semitendinpct,1);

EMG.results.meanpct.Right_Lateral = mean(Right_Lateralpct,1);
EMG.results.meanpct.Left_Lateral = mean(Left_Lateralpct,1);

EMG.results.meanpct.Right_Gastrocnem = mean(Right_Gastrocnempct,1);
EMG.results.meanpct.Left_Gastrocnem = mean(Left_Gastrocnempct,1);

EMG.results.meanpct.Right_Tibialis = mean(Right_Tibialispct,1);
EMG.results.meanpct.Left_Tibialis = mean(Left_Tibialispct,1);

EMG.results.meanpct.Right_Peroneal = mean(Right_Peronealpct,1);
EMG.results.meanpct.Left_Peroneal = mean(Left_Peronealpct,1);

 nb_cycles = size(Muscles,1)/nMuscles;
    for a = 1:nMuscles
        d=a;
        for b=1:nb_cycles
        Each_muscle(b,1:size(Muscles,2)) = Muscles(d,:); %#ok<AGROW> 
        d=d+nMuscles;
        end
        

       Muscles_total(a,1:size(Muscles,2)) = mean(Each_muscle); %#ok<AGROW> 
       Mean_raw_EMG_total(a,1:1000) = mean(Mean_raw_EMG); %#ok<AGROW>
      
    end

EMG.results.Activation = meanActivationEMG(Muscles_total,Mean_raw_EMG_total);
    





