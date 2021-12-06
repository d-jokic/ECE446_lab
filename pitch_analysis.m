

%read in file
[x, fs] = audioread('./clean_audio/french_working_diana_jokic.m4a');


%create time array
t = (0:size(x,1)-1)/fs;

%run pitch funtion on whole signal
winLength = round(0.05*fs);
overlapLength = round(0.045*fs);
[f0,idx] = pitch(x,fs,'Method','SRH','WindowLength',winLength,'OverlapLength',overlapLength);
tf0 = idx/fs;

%create new signal with silence removed
newAudio = x(1:0.3*fs);
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
threshold = 0.8;
f0_OnlySound_2(hr < threshold) = nan;
tf0_OnlySound_2(hr < threshold) = nan;

%remove NaN 
f0_final = f0_OnlySound_2(~isnan(f0_OnlySound_2));
tf0_final = tf0_OnlySound_2(~isnan(tf0_OnlySound_2));

avg_mean = mean(f0_final);
disp(avg_mean);
avg_mean_array = avg_mean .* ones(length(f0_final), 1);

figure(1)
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

clear;


