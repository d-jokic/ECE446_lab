%% Do the pitch analysis

% define global variables
lan = ["english", "french", "german", "serbian"];
landict = containers.Map(lan,1:4);
sp = soundPitchMethods();


audio_path = "./clean_audio";


% retrieve metadata
metadata = metadata_init( audio_path);
N_entries = height(metadata);

% list participants
unique_name = unique(metadata(:,ismember(metadata.Properties.VariableNames, ["F_NAME","L_NAME"])), 'stable');
unique_name = table2array(unique_name);
unique_name = unique_name(:,1) + "_"+ unique_name(:,2);
N_participants = length(unique_name);
partdict = containers.Map(unique_name, 1:N_participants);

% init the array to be plotted
results_pitch = NaN(N_participants, length(lan)+1);


% loop through the table entries
for i=1:N_entries

    row = metadata(i,:);
    
    % compute intensity
    filepath = audio_path + "/" + row.LANGUAGE + "_" + row.PROFICIENCY +"_" + row.F_NAME+ "_" + row.L_NAME + "." + row.TYPE;

    [y,Fs] = audioread(filepath);
    avg_pitch = sp.avg_speech_pitch(y, Fs,false);

    % find name
    pos= partdict(row.F_NAME + "_" + row.L_NAME);
    
    %append to results
    results_pitch(pos,landict(row.LANGUAGE)) = avg_pitch;

    if row.PROFICIENCY == "full"
        results_pitch(pos,length(lan)+1) = avg_pitch;
    end



end


%% Plot the pitch results


scatter(1:N_participants, results_pitch(:,1), 'filled')
hold on
scatter(1:N_participants,results_pitch(:,2), 'filled')
hold on
scatter(1:N_participants, results_pitch(:,3), 'filled')
hold on
scatter(1:N_participants, results_pitch(:,4), 'filled')
hold on
scatter(1:N_participants, results_pitch(:,5), 100,'d')
hold on



xlabel("Participant")
ylabel("Pitch of speech")



legend("English","French","German","Serbo-Croatian", "Native speaker")

hold off
