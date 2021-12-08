%% Do the pace analysis

% define global variables
lan = ["english", "french", "german", "serbian"];
landict = containers.Map(lan,1:4);
prof = ["full","professional", "working","basic"];
sizes = [300, 150, 60, 20];
sizedict =containers.Map(prof,sizes);
profdict =containers.Map(prof,1:4);

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

title("Duration of speech")


xlabel("Participant number")
ylabel("Duration of speech (s)")



legend("English","French","German","Serbo-Croatian", "Native speaker")

hold off


%% Average plot per language-proficiency

avg_dur = zeros(length(lan),length(prof));
instances = zeros(length(lan),length(prof));


% loop through the table entries
for i=1:N_entries

    row = metadata(i,:);

    
    % find duration for this person
    dur = results_dur(partdict(row.F_NAME + "_"  + row.L_NAME),landict(row.LANGUAGE));

    % add to the avg array
    i = landict(row.LANGUAGE);
    j = profdict(row.PROFICIENCY);

    avg_dur(i,j) = avg_dur(i,j)+ dur;
    instances(i,j) = instances(i,j) +1;

   

end


avg_dur = avg_dur./instances;

X = categorical({'English','French','German','Serbo-Croatian'});
bar(X,avg_dur);
ylabel("duration (s)")
title("Average duration of speech per profile")
legend({'Full','Professional','Working','Basic'})


