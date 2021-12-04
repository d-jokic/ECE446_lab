function match_file_list = find_match_files(features, metadata)
    % FIND_MATCH_FILES 
    % Find all the paths to files corresponding to these criteria
    % Usage find_files([language,proficiency,first_name,last_name], metadata)
    % eg. find_files(["english","full","",""], metadata)
    
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

