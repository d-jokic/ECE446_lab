


sp = soundPitchMethods;

[y,Fs] = audioread("./clean_audio/english_full_diana_jokic.m4a");

mean_pitch = sp.avg_speech_pitch(y, Fs, true);