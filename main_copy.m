%% Retrieve metadata

clean_audio_path = "./clean_audio";
files = dir(clean_audio_path);

LANGUAGE = [];
PROFICIENCY = [];
F_NAME = [];
L_NAME = [];
TYPE = [];

for k=1:length(files)
    filename = files(k).name;

    if ~strcmp(filename,'.') && ~strcmp(filename,'..')
        name = split(filename,'.');
        features =  split(name(1),'_');
        
        LANGUAGE = [LANGUAGE; string(features(1))];
        PROFICIENCY= [PROFICIENCY; string(features(2))];
        F_NAME =[F_NAME; string(features(3))];
        L_NAME = [L_NAME; string(features(4))];
        TYPE = [TYPE; string(name(2))];
    end
end



metadata = table(LANGUAGE,PROFICIENCY,F_NAME,L_NAME,TYPE);

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



file_list = find_files(["german","full","",""], metadata);



function match_file_list = find_files(features, metadata)
    % Usage find_files([language,proficiency,first_name,last_name], metadata)
    match_file_list = [];
    keyset = ["LANGUAGE","PROFICIENCY", "F_NAME", "L_NAME"];
    meta_size = height(metadata);
    for entry=1:meta_size
        append_flag =true;

        for k=1:length(keyset)
            append_flag = append_flag & (strcmp(features(k),"") | strcmp(features(k), metadata{entry,keyset(k)}));
        end

        if append_flag
            filename = metadata{entry,"LANGUAGE"} + "_" + metadata{entry,"PROFICIENCY"} + "_" + metadata{entry,"F_NAME"} + "_" + metadata{entry,"L_NAME"} + "." + metadata{entry,"TYPE"};
            match_file_list = [match_file_list, filename ];
        end
    end

end

