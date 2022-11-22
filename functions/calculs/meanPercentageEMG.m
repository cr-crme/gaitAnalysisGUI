function results = meanPercentageEMG(EMG,c3d)


    
%Extract data du c3d
    data = extractDataFromC3D(c3d, false);

% Extraire les �v�nements
    data = extractEvents(c3d, data);
    
 % Normaliser les donn�es
    data.norm = normalizeData(data, false); 

% Aller chercher les stamps pour savoir ou couper
    stamps = extractStamps(data.stamps, data.angleInfos.frequency);
    
% Trouver les deux cycles de cet essai (ou on met le pied sur la plateforme +1)
[idxPiedGauche,idxPiedDroit,onPlateFormeLeft,idxPlateFormePiedDroit, numPFGauche, numPFDroit] = findFootIdx(data, stamps);


%TRAITEMENT DES DONN�ES EMG 


%Filtre passe-bande d'ordre 4 qui laisse passer entre 20 et 450Hz (ripple
%1)
d = fdesign.bandpass('N,Fp1,Fp2,Ap',4,0.02,0.45,1);
Hd = design(d);

%Application du passe-bande sur les donn�es brutes
%MOYEN FESSIER
Right_Gluteus = filter(Hd,EMG.Analogs.Right_Gluteus_me);
Left_Gluteus = filter(Hd,EMG.Analogs.Left_Gluteus_med);

%DROIT FEMORAL
Right_Rectus = filter(Hd,EMG.Analogs.Right_Rectus_fem);
Left_Rectus = filter(Hd,EMG.Analogs.Left_Rectus_femo);
%SEMITENDINEUX
Right_Semitendin = filter(Hd,EMG.Analogs.Right_Semitendin);
Left_Semitendin = filter(Hd,EMG.Analogs.Left_Semitendino);

%VASTE LATERAL
Right_Lateral = filter(Hd,EMG.Analogs.Right_Vastus_lat);
Left_Lateral = filter(Hd,EMG.Analogs.Left_Vastus_late);

%GASTROCNEMIEN
Right_Gastrocnem = filter(Hd,EMG.Analogs.Right_Gastrocnem);
Left_Gastrocnem = filter(Hd,EMG.Analogs.Left_Gastrocnemi);

%TIBIAL ANTERIEUR
Right_Tibialis = filter(Hd,EMG.Analogs.Right_Tibialis_a);
Left_Tibialis = filter(Hd,EMG.Analogs.Left_Tibialis_an);



%RECTIFICATION
Right_Gluteus = abs(Right_Gluteus - mean(Right_Gluteus));
Left_Gluteus = abs(Left_Gluteus - mean(Left_Gluteus));

Right_Rectus = abs(Right_Rectus - mean(Right_Rectus));
Left_Rectus = abs(Left_Rectus - mean(Left_Rectus));

Right_Semitendin = abs(Right_Semitendin - mean(Right_Semitendin));
Left_Semitendin = abs(Left_Semitendin - mean(Left_Semitendin));

Right_Lateral = abs(Right_Lateral - mean(Right_Lateral));
Left_Lateral = abs(Left_Lateral - mean(Left_Lateral));

Right_Gastrocnem = abs(Right_Gastrocnem-mean(Right_Gastrocnem));
Left_Gastrocnem = abs(Left_Gastrocnem-mean(Left_Gastrocnem));

Right_Tibialis = abs(Right_Tibialis - mean(Right_Tibialis));
Left_Tibialis = abs(Left_Tibialis - mean(Left_Tibialis));

%%%%POUR L'ACTIVATION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%(meanActivationEMG)%%%%%%%%%%%%%%%%%%%%%%%%%
%Application de Nyquist
Fs=1000; %Hz  %Fr�quence d'�chantillonage 
fnyq = Fs/2;

%Butterworth pour enveloppe
fco = 30;
[b,a]=butter(2,fco*1.25/fnyq);
results.Right_Gluteus = filtfilt(b,a,Right_Gluteus);
results.Left_Gluteus = filtfilt(b,a,Left_Gluteus);

results.Right_Rectus = filtfilt(b,a,Right_Rectus);
results.Left_Rectus = filtfilt(b,a,Left_Rectus);

results.Right_Semitendin = filtfilt(b,a,Right_Semitendin);
results.Left_Semitendin = filtfilt(b,a,Left_Semitendin);

results.Right_Lateral = filtfilt(b,a,Right_Lateral);
results.Left_Lateral = filtfilt(b,a,Left_Lateral);

results.Right_Gastrocnem=filtfilt(b,a,Right_Gastrocnem);
results.Left_Gastrocnem = filtfilt(b,a,Left_Gastrocnem);

results.Right_Tibialis = filtfilt(b,a,Right_Tibialis);
results.Left_Tibialis = filtfilt(b,a,Left_Tibialis);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Cr�ation matrices des num�ros de frames
Frames_Numbers.Right = floor((((EMG.Events.Right_Foot_Strike)*100 -(EMG.Events.Right_Foot_Strike(1)*100-1))+(EMG.Events.Right_Foot_Strike(1)*100-EMG.First_frame))*10);
Frames_Numbers.Left = floor((( (EMG.Events.Left_Foot_Strike)*100 - (EMG.Events.Left_Foot_Strike(1)*100-1) )+(EMG.Events.Left_Foot_Strike(1)*100-EMG.First_frame))*10);

index = Frames_Numbers.Right>0;
Frames_Numbers.Right = Frames_Numbers.Right(index);

index = Frames_Numbers.Left>0;
Frames_Numbers.Left = Frames_Numbers.Left(index);


%Mettre sur 100 points chaque cycle
%pour ne pas exc�der la matrice des donn�es analog
long_Right = 0;
for a = 1:length(Frames_Numbers.Right)
    if Frames_Numbers.Right(a) <= size(Right_Gluteus,1)
        long_Right = long_Right +1;
    end
end


for j = 1:(long_Right-1)
New_Frames.Right(j,:)=linspace(Frames_Numbers.Right(j),(Frames_Numbers.Right(j+1)-1),100);

vq.Right_Gluteus(j,:)= interp1([Frames_Numbers.Right(j):1:(Frames_Numbers.Right(j+1)-1)],Right_Gluteus(Frames_Numbers.Right(j):(Frames_Numbers.Right(j+1)-1)),New_Frames.Right(j,:));

vq.Right_Rectus(j,:)= interp1([Frames_Numbers.Right(j):1:(Frames_Numbers.Right(j+1)-1)],Right_Rectus(Frames_Numbers.Right(j):(Frames_Numbers.Right(j+1)-1)),New_Frames.Right(j,:));

vq.Right_Semitendin(j,:)= interp1([Frames_Numbers.Right(j):1:(Frames_Numbers.Right(j+1)-1)],Right_Semitendin(Frames_Numbers.Right(j):(Frames_Numbers.Right(j+1)-1)),New_Frames.Right(j,:));

vq.Right_Lateral(j,:)= interp1([Frames_Numbers.Right(j):1:(Frames_Numbers.Right(j+1)-1)],Right_Lateral(Frames_Numbers.Right(j):(Frames_Numbers.Right(j+1)-1)),New_Frames.Right(j,:));

vq.Right_Gastrocnem(j,:)= interp1([Frames_Numbers.Right(j):1:(Frames_Numbers.Right(j+1)-1)],Right_Gastrocnem(Frames_Numbers.Right(j):(Frames_Numbers.Right(j+1)-1)),New_Frames.Right(j,:));

vq.Right_Tibialis(j,:)= interp1([Frames_Numbers.Right(j):1:(Frames_Numbers.Right(j+1)-1)],Right_Tibialis(Frames_Numbers.Right(j):(Frames_Numbers.Right(j+1)-1)),New_Frames.Right(j,:));

end
long_Left = 0;
for a = 1:length(Frames_Numbers.Left)
    if Frames_Numbers.Left(a) <= size(Left_Gluteus,1)
        long_Left = long_Left +1;
    end
end

for j = 1:(long_Left-1)
New_Frames.Left(j,:) = linspace(Frames_Numbers.Left(j),(Frames_Numbers.Left(j+1)-1),100);
vq.Left_Gluteus(j,:)= interp1([Frames_Numbers.Left(j):1:(Frames_Numbers.Left(j+1)-1)],Left_Gluteus(Frames_Numbers.Left(j):(Frames_Numbers.Left(j+1)-1)),New_Frames.Left(j,:));
vq.Left_Rectus(j,:)= interp1([Frames_Numbers.Left(j):1:(Frames_Numbers.Left(j+1)-1)],Left_Rectus(Frames_Numbers.Left(j):(Frames_Numbers.Left(j+1)-1)),New_Frames.Left(j,:));
vq.Left_Semitendin(j,:)= interp1([Frames_Numbers.Left(j):1:(Frames_Numbers.Left(j+1)-1)],Left_Semitendin(Frames_Numbers.Left(j):(Frames_Numbers.Left(j+1)-1)),New_Frames.Left(j,:));
vq.Left_Lateral(j,:)= interp1([Frames_Numbers.Left(j):1:(Frames_Numbers.Left(j+1)-1)],Left_Lateral(Frames_Numbers.Left(j):(Frames_Numbers.Left(j+1)-1)),New_Frames.Left(j,:));
vq.Left_Gastrocnem(j,:)= interp1([Frames_Numbers.Left(j):1:(Frames_Numbers.Left(j+1)-1)],Left_Gastrocnem(Frames_Numbers.Left(j):(Frames_Numbers.Left(j+1)-1)),New_Frames.Left(j,:));
vq.Left_Tibialis(j,:)= interp1([Frames_Numbers.Left(j):1:(Frames_Numbers.Left(j+1)-1)],Left_Tibialis(Frames_Numbers.Left(j):(Frames_Numbers.Left(j+1)-1)),New_Frames.Left(j,:));

end
%Chercher seulement les 2 cycles
u=1;
for i = 1:size(idxPiedDroit,2)
    index_Droite(i) = idxPiedDroit(i);
end

for a = index_Droite
vq.Right_Gluteus_cycles(u,:) = vq.Right_Gluteus(a,:);
vq.Right_Rectus_cycles(u,:) = vq.Right_Rectus(a,:);
vq.Right_Semitendin_cycles(u,:) = vq.Right_Semitendin(a,:);
vq.Right_Lateral_cycles(u,:) = vq.Right_Lateral(a,:);
vq.Right_Gastrocnem_cycles(u,:) = vq.Right_Gastrocnem(a,:);
vq.Right_Tibialis_cycles(u,:) = vq.Right_Tibialis(a,:);
u=u+1;
end

for i = 1:size(idxPiedGauche,2)
    index_Gauche(i) = idxPiedGauche(i);
end
for a =index_Gauche
vq.Left_Gluteus_cycles(u,:) = vq.Left_Gluteus(a,:);
vq.Left_Rectus_cycles(u,:) = vq.Left_Rectus(a,:);
vq.Left_Semitendin_cycles(u,:) = vq.Left_Semitendin(a,:);
vq.Left_Lateral_cycles(u,:) = vq.Left_Lateral(a,:);
vq.Left_Gastrocnem_cycles(u,:) = vq.Left_Gastrocnem(a,:);
vq.Left_Tibialis_cycles(u,:) = vq.Left_Tibialis(a,:);
u=u+1;
end

%Calcul de la moyenne des 2 cycles
if size(vq.Right_Gluteus_cycles,1) > 1
mean_Gluteus_Right = mean(vq.Right_Gluteus_cycles);
mean_Rectus_Right = mean(vq.Right_Rectus_cycles);
mean_Semitendin_Right = mean(vq.Right_Semitendin_cycles);
mean_Lateral_Right = mean(vq.Right_Lateral_cycles);
mean_Gastrocnem_Right = mean(vq.Right_Gastrocnem_cycles);
mean_Tibialis_Right = mean(vq.Right_Tibialis_cycles);

else
    mean_Gluteus_Right =vq.Right_Gluteus_cycles;
    mean_Rectus_Right = vq.Right_Rectus_cycles;
    mean_Semitendin_Right = vq.Right_Semitendin_cycles;
    mean_Lateral_Right = vq.Right_Lateral_cycles;
    mean_Gastrocnem_Right = vq.Right_Gastrocnem_cycles;
    mean_Tibialis_Right = vq.Right_Tibialis_cycles;
end

if size(vq.Left_Gluteus_cycles,1) > 1
mean_Gluteus_Left= mean(vq.Left_Gluteus_cycles);
mean_Rectus_Left = mean(vq.Left_Rectus_cycles);
mean_Semitendin_Left = mean(vq.Left_Semitendin_cycles);
mean_Lateral_Left = mean(vq.Left_Lateral_cycles);
mean_Gastrocnem_Left = mean(vq.Left_Gastrocnem_cycles);
mean_Tibialis_Left = mean(vq.Left_Tibialis_cycles);

else
    mean_Gluteus_Left= vq.Left_Gluteus_cycles;
mean_Rectus_Left = vq.Left_Rectus_cycles;
mean_Semitendin_Left = vq.Left_Semitendin_cycles;
mean_Lateral_Left = vq.Left_Lateral_cycles;
mean_Gastrocnem_Left = vq.Left_Gastrocnem_cycles;
mean_Tibialis_Left = vq.Left_Tibialis_cycles;
    
end

mean_Gluteus = (mean_Gluteus_Right + mean_Gluteus_Left)/2;
mean_Rectus= (mean_Rectus_Right + mean_Rectus_Left)/2;
mean_Semitendin = (mean_Semitendin_Right + mean_Semitendin_Left)/2;
mean_Lateral = (mean_Lateral_Right + mean_Lateral_Left)/2;
mean_Gastrocnem = (mean_Gastrocnem_Right + mean_Gastrocnem_Left)/2;
mean_Tibialis =(mean_Tibialis_Right + mean_Tibialis_Left)/2;




%Application de Nyquist
Fs=1000; %Hz  %Fr�quence d'�chantillonage 
fnyq = Fs/2;

%Butterworth pour enveloppe
fco = 30;
[b,a]=butter(2,fco*1.25/fnyq);
Right_Gluteus = filtfilt(b,a,mean_Gluteus_Right);
Left_Gluteus = filtfilt(b,a,mean_Gluteus_Left);

Right_Rectus = filtfilt(b,a,mean_Rectus_Right);
Left_Rectus = filtfilt(b,a,mean_Rectus_Left);

Right_Semitendin = filtfilt(b,a,mean_Semitendin_Right);
Left_Semitendin = filtfilt(b,a,mean_Semitendin_Left);

Right_Lateral = filtfilt(b,a,mean_Lateral_Right);
Left_Lateral = filtfilt(b,a,mean_Lateral_Left);

Right_Gastrocnem=filtfilt(b,a,mean_Gastrocnem_Right);
Left_Gastrocnem = filtfilt(b,a,mean_Gastrocnem_Left);

Right_Tibialis = filtfilt(b,a,mean_Tibialis_Right);
Left_Tibialis = filtfilt(b,a,mean_Tibialis_Left);

%Mettre dans le ''c''
results.mean.Right_Gluteus = Right_Gluteus;
results.mean.Left_Gluteus = Left_Gluteus;

results.mean.Right_Rectus = Right_Rectus;
results.mean.Left_Rectus = Left_Rectus;

results.mean.Right_Semitendin = Right_Semitendin;
results.mean.Left_Semitendin = Left_Semitendin;

results.mean.Right_Lateral= Right_Lateral;
results.mean.Left_Lateral = Left_Lateral;

results.mean.Right_Gastrocnem = Right_Gastrocnem;
results.mean.Left_Gastrocnem = Left_Gastrocnem;

results.mean.Right_Tibialis = Right_Tibialis;
results.mean.Left_Tibialis = Left_Tibialis;




%Mettre en % et les mettre dans le c


results.meanpct.Right_Gluteus = (Right_Gluteus *100)/(max(Right_Gluteus));
results.meanpct.Left_Gluteus = (Left_Gluteus*100)/max(Left_Gluteus);
results.meanpct.Gluteus = (results.meanpct.Right_Gluteus + results.meanpct.Left_Gluteus)/2;

results.meanpct.Right_Rectus = (Right_Rectus*100)/max(Right_Rectus);
results.meanpct.Left_Rectus = (Left_Rectus*100)/(max(Left_Rectus));
results.meanpct.Rectus = (results.meanpct.Right_Rectus + results.meanpct.Left_Rectus)/2;

results.meanpct.Right_Semitendin= (Right_Semitendin*100)/(max(Right_Semitendin));
results.meanpct.Left_Semitendin = (Left_Semitendin*100)/(max(Left_Semitendin));
results.meanpct.Semitendin = (results.meanpct.Right_Semitendin + results.meanpct.Left_Semitendin)/2;

results.meanpct.Right_Lateral = (Right_Lateral*100)/(max(Right_Lateral));
results.meanpct.Left_Lateral = (Left_Lateral*100)/max(Left_Lateral);
results.meanpct.Lateral = (results.meanpct.Right_Lateral + results.meanpct.Left_Lateral)/2;

results.meanpct.Right_Gastrocnem = (Right_Gastrocnem*100)/max(Right_Gastrocnem);
results.meanpct.Left_Gastrocnem = (Left_Gastrocnem*100)/max(Left_Gastrocnem);
results.meanpct.Gastrocnem = (results.meanpct.Right_Gastrocnem + results.meanpct.Left_Gastrocnem)/2;

results.meanpct.Right_Tibialis = (Right_Tibialis*100)/max(Right_Tibialis);
results.meanpct.Left_Tibialis = (Left_Tibialis*100)/max(Left_Tibialis);
results.meanpct.Tibialis =(results.meanpct.Right_Tibialis + results.meanpct.Left_Tibialis)/2;














