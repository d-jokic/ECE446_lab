clear;
clc;

%Plot controlling variables 
plot_tiles = 0;
plot_stats = 0;

metadata = metadata_init( "./clean_audio");

for i = 1:length(metadata.F_NAME)
    if metadata.LANGUAGE(i) == "english"
        participants(i, 1) = metadata.F_NAME(i);
        participants(i, 2) = metadata.L_NAME(i);
    end
end

all_avg_pitches = NaN(length(participants(:,1)), 4);

% loop through every participant
for i = 1:length(participants)
    disp(" ");
    file_list = find_match_files(["","",participants(i, 1),participants(i,2)], metadata);
    
    %loop though all languages
    for j = 1:length(file_list)
        
        if contains(file_list(j),"full")
            proficiency(i,j) = "full";
        elseif contains(file_list(j), "professional")
            proficiency(i,j) = "professional";
        elseif contains(file_list(j), "working")
            proficiency(i,j) = "working";
        elseif contains(file_list(j), "basic")
            proficiency(i,j) = "basic";
        end

        path = strcat('./clean_audio/', file_list(j));
        [x, fs] = audioread(path);        
        
        %create time array
        t = (0:size(x,1)-1)/fs;
        
        %run pitch funtion on whole signal
        winLength = round(0.05*fs);
        overlapLength = round(0.045*fs);
        [f0,idx] = pitch(x,fs,'Method','SRH','WindowLength',winLength,'OverlapLength',overlapLength);
        tf0 = idx/fs;
        
        %create new signal with silence removed
        newAudio = x(1:0.2*fs);
        thres = 5*max(newAudio);
        indexOfSound = abs(x) > thres;
        onlySound = x(indexOfSound);
        t_OnlySound = (0:size(onlySound,1)-1)/fs;
        
        %run pitch funtion on new signal
        [f0_OnlySound,idx_OnlySound] = pitch(onlySound,fs,'Method','SRH','WindowLength',winLength,'OverlapLength',overlapLength);
        tf0_OnlySound = idx_OnlySound/fs;
        
        f0_OnlySound_2 = f0_OnlySound;
        tf0_OnlySound_2 = tf0_OnlySound;
        
        %run harmonic ratio on new signal
        hr = harmonicRatio(onlySound,fs,"Window",hamming(winLength,'periodic'),"OverlapLength",overlapLength);
        threshold = 0.7*max(hr);
        f0_OnlySound_2(hr < threshold) = nan;
        tf0_OnlySound_2(hr < threshold) = nan;
        
        %remove NaN 
        f0_final = f0_OnlySound_2(~isnan(f0_OnlySound_2));
        tf0_final = tf0_OnlySound_2(~isnan(tf0_OnlySound_2));
        
        avg_pitch = mean(f0_final);
        avg_mean_array = avg_pitch .* ones(length(f0_final), 1);

        if contains(path,'english') == 1
            all_avg_pitches(i,1) = avg_pitch;
        elseif contains(path,'french') == 1
            all_avg_pitches(i,2) = avg_pitch;
        elseif contains(path,'german') == 1
            all_avg_pitches(i,3) = avg_pitch;
        else
            all_avg_pitches(i,4) = avg_pitch;
        end

        name = regexprep(file_list(j),'_', ' ');
        name = regexprep(name,'.m4a', '');
        name = regexprep(name,'.wav', '');
            
        fprintf("Average pitch for %s = %d Hz \n", name, round(avg_pitch));

        if plot_tiles == 1
            figure('Name' , upper(name))
            tiledlayout(3,2)
            
            nexttile
            plot(t,x)
            ylabel('Amplitude')
            title('Audio Signal, Full')
            axis tight
            
            nexttile
            plot(tf0,f0)
            ylabel('Pitch (Hz)')
            title('Audio Signal Silence Removed, Harmonics Only - Pitch Estimation')
            axis tight
            
            nexttile
            plot(t_OnlySound,onlySound)
            ylabel('Amplitude')
            title('Audio Signal, Silence Removed')
            axis tight
            
            nexttile
            plot(tf0_OnlySound,f0_OnlySound)
            ylabel('Pitch (Hz)')
            title('Audio Signal Silence Removed, Harmonics Only - Pitch Estimation')
            axis tight
            
            nexttile
            plot(tf0_OnlySound,hr)
            ylabel('Ratio')
            title('Audio Signal, Silence Removed - Harmonic Ratio')
            axis tight
            
            nexttile
            plot(tf0_final,f0_final)
            ylabel('Pitch (Hz)')
            title('Audio Signal Silence Removed, Harmonics Only - Pitch Estimation')
            axis tight
            hold on
            plot(tf0_final,avg_mean_array)
            hold off
            saveas(gcf, name)

        end

    end
end

par = [1:length(participants(:,1))];

if plot_stats == 1

    figure(i*j + 2)
    scatter(par, all_avg_pitches(:,1), 'filled')
    hold on
    scatter(par, all_avg_pitches(:,2), 'filled')
    hold on
    scatter(par, all_avg_pitches(:,3), 'filled')
    hold on
    scatter(par, all_avg_pitches(:,4), 'filled')
    
    xlabel("Participant")
    ylabel("Average Pitch (Hz)")

    legend("English","French","German","Serbo-Croatian")

    hold off
end

avg_eng_pitch = mean(all_avg_pitches(:,1));
avg_fre_pitch = mean(all_avg_pitches(:,2));
avg_ger_pitch = mean(all_avg_pitches(:,3));
avg_sc_pitch = mean(all_avg_pitches(:,4));