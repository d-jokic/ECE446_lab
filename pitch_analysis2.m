%% Do the pitch analysis

% define global variables
lan = ["english", "french", "german", "serbian"];
landict = containers.Map(lan,1:4);
prof = ["full","professional", "working","basic"];
sizes = [300, 150, 60, 20];
sizedict =containers.Map(prof,sizes);

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
results_pitch = NaN(N_participants, length(lan)*2);


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


    results_pitch(pos,length(lan)+landict(row.LANGUAGE) ) = sizedict(row.PROFICIENCY);



end


%% Plot the pitch results


scatter(1:N_participants, results_pitch(:,1), results_pitch(:,5), 'filled')
alpha(0.8)
hold on
scatter(1:N_participants,results_pitch(:,2), results_pitch(:,6),'filled')
alpha(0.8)
hold on
scatter(1:N_participants,results_pitch(:,3), results_pitch(:,7),'filled')
alpha(0.8)
hold on
scatter(1:N_participants, results_pitch(:,4), results_pitch(:,8),'filled')
alpha(0.8)
hold on


title("Pitch of speech")

xlabel("Participant")
ylabel("Pitch of speech")



legend("English","French","German","Serbo-Croatian", "Native speaker")

hold off


