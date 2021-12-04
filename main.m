%% Retrieve metadata

metadata = metadata_init( "./clean_audio");


% number of samples of each language
en_samples = sum(strcmp(metadata.LANGUAGE, 'english'));
fr_samples = sum(strcmp(metadata.LANGUAGE, 'french'));
ge_samples = sum(strcmp(metadata.LANGUAGE, 'german'));
se_samples = sum(strcmp(metadata.LANGUAGE, 'serbian'));

fprintf("There are %d English samples\n", en_samples);
fprintf("There are %d French samples\n", fr_samples);
fprintf("There are %d German samples\n", ge_samples);
fprintf("There are %d Serbo-Croatian samples\n", se_samples);


lan = ["english","french","german","serbian"];
prof = ["full","professional","working","basic"];

y = zeros(length(lan),length(prof));
for l=1:length(lan)
    for p=1:length(prof)
        y(l,p)=sum(strcmp(metadata.LANGUAGE, lan(l)) & strcmp(metadata.PROFICIENCY, prof(p)));
    end
end

X = categorical({'English','French','German','Serbo-Croatian'});
bar(X,y);
ylabel("Number of Participants")
title("Distribution of Language Proficiencies")
legend({'Full','Professional','Working','Basic'})
saveas(gcf, 'proficiency_dist.png');


%% Search with features

file_list = find_match_files(["english","full","",""], metadata);



%% Insensity related methods

[y,Fs] = audioread("./clean_audio/english_professional_borjana_kuntos.m4a");

si = soundIntensityMethods();

intensity = si.avg_sound_intensity(y);

intensity_derivative = si.avg_sound_intensity_derivative(y);

