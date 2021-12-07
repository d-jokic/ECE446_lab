%% Do the intensity analysis

% define global variables
lan = ["english", "french", "german", "serbian"];
landict = containers.Map(lan,1:4);


audio_path = "./clean_audio";
si = soundIntensityMethods(); % allows using sound intensity methods

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
results_int = NaN(N_participants, length(lan));
results_der_int = NaN(N_participants, length(lan));

% loop through the table entries
for i=1:N_entries

    row = metadata(i,:);
    
    % compute intensity
    filepath = audio_path + "/" + row.LANGUAGE + "_" + row.PROFICIENCY +"_" + row.F_NAME+ "_" + row.L_NAME + "." + row.TYPE;

    [y,Fs] = audioread(filepath);
    Int = si.avg_sound_intensity(y, false);
    Int_der = si.avg_sound_intensity_derivative(y, false);

    % find name
    pos= partdict(row.F_NAME + "_" + row.L_NAME);
    
    %append to results
    results_int(pos,landict(row.LANGUAGE)) = Int;
    results_der_int(pos,landict(row.LANGUAGE)) = Int_der;

end


%% Plot the intensity results

tiledlayout(2,1)

nexttile
scatter(1:N_participants, results_int(:,1), 'filled')
hold on
scatter(1:N_participants, results_int(:,2), 'filled')
hold on
scatter(1:N_participants, results_int(:,3), 'filled')
hold on
scatter(1:N_participants, results_int(:,4), 'filled')
hold on

xlabel("Participant")
ylabel("Average Intensity")



legend("English","French","German","Serbo-Croatian")


nexttile
scatter(1:N_participants, results_der_int(:,1), 'filled')
hold on
scatter(1:N_participants, results_der_int(:,2), 'filled')
hold on
scatter(1:N_participants, results_der_int(:,3), 'filled')
hold on
scatter(1:N_participants, results_der_int(:,4), 'filled')

xlabel("Participant")
ylabel("Average Intensity Derivative")


legend("English","French","German","Serbo-Croatian")

hold off





