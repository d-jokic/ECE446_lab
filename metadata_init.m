function metadata = metadata_init(clean_audio_path)
%METADATA_INIT 
% Init the metadata table based on the content of clean_audio_path folder
% clean_audio_path = "./clean_audio"

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
end

