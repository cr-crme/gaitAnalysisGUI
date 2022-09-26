function EMG = extractmultipleEMG(c3d)
a=1;

for i = 1:size(c3d,2)
    
    %Pour l'EMG
    EMG = extractEMG(c3d(i));
    results = meanPercentageEMG(EMG,c3d(i));
    
    Right_Gluteuspct(i,:) = results.meanpct.Right_Gluteus;
    Left_Gluteuspct(i,:) = results.meanpct.Left_Gluteus;
   

    Right_Rectuspct(i,:) = results.meanpct.Right_Rectus; 
    Left_Rectuspct(i,:) = results.meanpct.Left_Rectus;
   
    Right_Semitendinpct(i,:) = results.meanpct.Right_Semitendin;
    Left_Semitendinpct(i,:) = results.meanpct.Left_Semitendin; 
   
    Right_Lateralpct(i,:) = results.meanpct.Right_Lateral; 
    Left_Lateralpct(i,:) = results.meanpct.Left_Lateral; 
   
    Right_Gastrocnempct(i,:) = results.meanpct.Right_Gastrocnem; 
    Left_Gastrocnempct(i,:) = results.meanpct.Left_Gastrocnem; 
  
    Right_Tibialispct(i,:) = results.meanpct.Right_Tibialis;  
    Left_Tibialispct(i,:) = results.meanpct.Left_Tibialis; 
    
%     %%Pour ACTIVATION
  

    Muscles(a:a+11,1:size(results.Right_Gluteus,1)) = [results.Right_Gluteus'; results.Left_Gluteus'; results.Right_Rectus';results.Left_Rectus';
    results.Right_Semitendin';results.Left_Semitendin';results.Right_Lateral'; results.Left_Lateral';
   results.Right_Gastrocnem'; results.Left_Gastrocnem'; results.Right_Tibialis'; results.Left_Tibialis'];

    Mean_raw_EMG(a:a+11,:)= [results.mean.Right_Gluteus;
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
    results.mean.Left_Tibialis];

a=a+12;


   
end

a=1;
EMG.results.meanpct.Right_Gluteus = mean(Right_Gluteuspct);
EMG.results.meanpct.Left_Gluteus = mean(Left_Gluteuspct);

EMG.results.meanpct.Right_Rectus = mean(Right_Rectuspct);
EMG.results.meanpct.Left_Rectus = mean(Left_Rectuspct);

EMG.results.meanpct.Right_Semitendin = mean(Right_Semitendinpct);
EMG.results.meanpct.Left_Semitendin= mean(Left_Semitendinpct);

EMG.results.meanpct.Right_Lateral = mean(Right_Lateralpct);
EMG.results.meanpct.Left_Lateral = mean(Left_Lateralpct);

EMG.results.meanpct.Right_Gastrocnem = mean(Right_Gastrocnempct);
EMG.results.meanpct.Left_Gastrocnem = mean(Left_Gastrocnempct);

EMG.results.meanpct.Right_Tibialis = mean(Right_Tibialispct);
EMG.results.meanpct.Left_Tibialis = mean(Left_Tibialispct);


 nb_cycles = size(Muscles,1)/12;
    for a = 1:12
        d=a;
        for b=1:nb_cycles
        Each_muscle(b,1:size(Muscles,2)) = Muscles(d,:);
        Each_mean_raw(b,1:100) = Mean_raw_EMG(d,:);
        d=d+12;
        end
        

       Muscles_total(a,1:size(Muscles,2)) = mean(Each_muscle);
       Mean_raw_EMG_total(a,1:100) = mean(Mean_raw_EMG);
      
    end

EMG.results.Activation = meanActivationEMG(Muscles_total,Mean_raw_EMG_total);
    





