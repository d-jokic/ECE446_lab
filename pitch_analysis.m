clear;
clc;

%Plot controlling variables 
plot_tiles = 0;
plot_stats = 1;
plot_fft = 0;

metadata = metadata_init( "./clean_audio_small");

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
        silence = x(1:0.2*fs); %find value of silence at start
        thres = 5*max(silence); %create threshold based on silence
        indexOfSound = abs(x) > thres; %create new signal by removing silence using created threshold
        onlySound = x(indexOfSound);
        t_OnlySound = (0:size(onlySound,1)-1)/fs;
        
        %run pitch funtion on new signal
        [f0_OnlySound,idx_OnlySound] = pitch(onlySound,fs,'Method','SRH','WindowLength',winLength,'OverlapLength',overlapLength);
        tf0_OnlySound = idx_OnlySound/fs;
        
        f0_OnlySound_2 = f0_OnlySound;
        tf0_OnlySound_2 = tf0_OnlySound;

%         %---------FFT-----------%
%         F = fft(onlySound);
%         f = fs*(0:(length(onlySound)/2))/length(onlySound); %frequency axis for graph depends on Fs
%         
%         fft_double = abs(F/length(onlySound));                %2-sided spectrum, has twice the number of points needed
%         
%         %create 1-sided spectrum; it is mirrored at freq = 0
%         %move all to one side, therefore need to double the magnitude
%         fft_single = fft_double(1:(length(onlySound)/2)+1);  
%         fft_single(2:end-1) = 2*fft_single(2:end-1); 
%         
%         %-----------------------%
        
        %run harmonic ratio on new signal to find harmonic sections
        hr = harmonicRatio(onlySound,fs,"Window",hamming(winLength,'periodic'),"OverlapLength",overlapLength);
        threshold = 0.9*max(hr); %create threshold
        f0_OnlySound_2(hr < threshold) = nan;
        tf0_OnlySound_2(hr < threshold) = nan;
        
        %remove NaN 
        f0_final = f0_OnlySound_2(~isnan(f0_OnlySound_2));
        tf0_final = tf0_OnlySound_2(~isnan(tf0_OnlySound_2));
        
        avg_pitch = mean(f0_final);
        avg_mean_array = avg_pitch .* ones(length(f0_final), 1);

        if contains(path,'english') == 1
            all_avg_pitches(i,1) = avg_pitch;
            if contains(path, "full")
                proficiency(i,1) = "full";
            elseif contains(path, "professional")
                proficiency(i,1) = "professional";
            elseif contains(path,"working")
                proficiency(i,1) = "working";
            elseif contains(path, "basic")
                proficiency(i,1) = "basic";
            end
        elseif contains(path,'french') == 1
            all_avg_pitches(i,2) = avg_pitch;
            if contains(path, "full")
                proficiency(i,2) = "full";
            elseif contains(path, "professional")
                proficiency(i,2) = "professional";
            elseif contains(path,"working")
                proficiency(i,2) = "working";
            elseif contains(path, "basic")
                proficiency(i,2) = "basic";
            end
        elseif contains(path,'german') == 1
            all_avg_pitches(i,3) = avg_pitch;
            if contains(path, "full")
                proficiency(i,3) = "full";
            elseif contains(path, "professional")
                proficiency(i,3) = "professional";
            elseif contains(path,"working")
                proficiency(i,3) = "working";
            elseif contains(path, "basic")
                proficiency(i,3) = "basic";
            end
        else
            all_avg_pitches(i,4) = avg_pitch;
            if contains(path, "full")
                proficiency(i,4) = "full";
            elseif contains(path, "professional")
                proficiency(i,4) = "professional";
            elseif contains(path,"working")
                proficiency(i,4) = "working";
            elseif contains(path, "basic")
                proficiency(i,4) = "basic";
            end
        end

        name = regexprep(file_list(j),'_', ' ');
        name = regexprep(name,'.m4a', '');
        name = regexprep(name,'.wav', '');
            
        fprintf("Average pitch for %s = %d Hz \n", name, round(avg_pitch));

        if plot_fft == 1
            figure('Name' , strcat("FFT Analysis - ", upper(name)))
            plot(f, fft_single)
            title('Frequency vs Amplitude')
            xlabel('Frequency (Hz)')
            ylabel('|Amplitude|')
        end


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
            title('Audio Signal Full - Pitch Estimation')
            axis tight
            
            nexttile
            plot(t_OnlySound,onlySound)
            ylabel('Amplitude')
            title('Audio Signal, Silence Removed')
            axis tight
            
            nexttile
            plot(tf0_OnlySound,f0_OnlySound)
            ylabel('Pitch (Hz)')
            title('Audio Signal Silence Removed - Pitch Estimation')
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
            saveas(gcf, strcat("./figures/",name,".png"))

        end
    end
end

c = NaN(length(participants(:,1)),3, 4);
if plot_stats == 1

    par = [1:length(participants(:,1))];    

% colour_matrix_rgb(:,:,1) = [11 31 148; 61 81 198; 111 131 220; 159 182 232]; %english
% colour_matrix_rgb(:,:,2) = [0.6350 0.0780 0.1840; 1 0 0; 0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250]; %french
% colour_matrix_rgb(:,:,3) = [29 118 37; 106 168 79; 147 196 125; 182 215 168]; %german
% colour_matrix_rgb(:,:,4) = [191 144 0; 241 194 50; 255 217 102; 255 229 153]; %serbo-croatian

size_matrix = [300, 150, 60, 20]; 
size = NaN(length(participants),4);

    for i = 1:length(all_avg_pitches(:,1)) %number of participants
        for j = 1:4 %number of languages (4)
            if(proficiency(i,j) == "full")
                size(i, j) = size_matrix(1);
            end
            if(proficiency(i,j) == "professional")
                size(i, j) = size_matrix(2);
            end
            if(proficiency(i,j) == "working")
                size(i, j) = size_matrix(3);
            end
            if(proficiency(i,j) == "basic")
                size(i, j) = size_matrix(4);
            end
        end
    end

    figure(i*j*2)

    title("Scatter Plot of Language Proficiencies")
    scatter(par, all_avg_pitches(:,1), size(:,1), 'filled') %english
    hold on
    scatter(par, all_avg_pitches(:,2),  size(:,2), 'filled') %
    hold on
    scatter(par, all_avg_pitches(:,3),  size(:,3), 'filled') %
    hold on
    scatter(par, all_avg_pitches(:,4),  size(:,4), 'filled') %
    hold on
    
    xlabel("Participant")
    ylabel("Average Pitch (Hz)")

    legend("English","French","German","Serbo-Croatian")

    hold off

    saveas(gcf, strcat("./figures/pitch_stats.png"))
end


avg_eng_pitch = mean(all_avg_pitches(:,1));
A = all_avg_pitches(:,2);
avg_fre_pitch = mean(A(~isnan(A)));
B = all_avg_pitches(:,3);
avg_ger_pitch = mean(B(~isnan(B)));
C = all_avg_pitches(:,4);
avg_sc_pitch = mean(C(~isnan(C)));