function Activation = meanActivationEMG(Muscles,Mean_raw_EMG)

%Pour chaque muscle, trouver le Tm avec le raw data
for k= 1:size(Muscles,1)
    %Set variables
    b=1;
    Ecart_type = 10000000000000000000;
    a = Muscles(k,:);
    
    %Evaluate each 300ms segment
    while (b+299) < size(a,2)
        Segment = a(b:b+299);
        Ecart_type_b = std(Segment);
        %Chercher l'écart type le plus petit
        if Ecart_type_b < Ecart_type
            Ecart_type = Ecart_type_b;
            Moyenne = mean(Segment);
        end
        b = b+300;
    end
    %Calculer le seuil Tm
    h=2; %%%variable set by the operator (Peut être modifiée)%%
    Tm(k,1) = h*Ecart_type + Moyenne; %#ok<AGROW> 
end

for k = 1:12
    Activation(k,1:1000) = 0; %#ok<AGROW> 
    %Temps d'activation
    for b =1:760
        if Mean_raw_EMG(k,b:b+240) >= Tm(k)
            Activation(k,b:b+240) = 1;
        end
    end
end
