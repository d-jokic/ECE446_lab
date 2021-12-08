%% Do the pace analysis

% define global variables
lan = ["english", "french", "german", "serbian"];
landict = containers.Map(lan,1:4);
prof = ["full","professional", "working","basic"];
sizes = [300, 150, 60, 20];
sizedict =containers.Map(prof,sizes);

sd = soundDurationMethods();



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
results_dur = NaN(N_participants, length(lan)*2);


% loop through the table entries
for i=1:N_entries

    row = metadata(i,:);
    
    % compute intensity
    filepath = audio_path + "/" + row.LANGUAGE + "_" + row.PROFICIENCY +"_" + row.F_NAME+ "_" + row.L_NAME + "." + row.TYPE;

    [y,Fs] = audioread(filepath);
    dur = sd.audio_duration(y, Fs,false);

    % find name
    pos= partdict(row.F_NAME + "_" + row.L_NAME);
    
    %append to results
    results_dur(pos,landict(row.LANGUAGE)) = dur;

    results_dur(pos,length(lan)+landict(row.LANGUAGE) ) = sizedict(row.PROFICIENCY);



end


%% Plot the duration results


scatter(1:N_participants, results_dur(:,1), results_dur(:,5),'filled')
alpha(0.8)
hold on
scatter(1:N_participants,results_dur(:,2), results_dur(:,6),'filled')
alpha(0.8)
hold on
scatter(1:N_participants, results_dur(:,3),results_dur(:,7), 'filled')
alpha(0.8)
hold on
scatter(1:N_participants, results_dur(:,4),results_dur(:,8), 'filled')
alpha(0.8)
hold on




xlabel("Participant")
ylabel("Duration of speech")



legend("English","French","German","Serbo-Croatian", "Native speaker")

hold off
