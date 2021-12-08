%% Do the intensity analysis

% define global variables
lan = ["english", "french", "german", "serbian"];
landict = containers.Map(lan,1:4);
prof = ["full","professional", "working","basic"];
sizes = [300, 150, 60, 20];
sizedict =containers.Map(prof,sizes);


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
results_int = NaN(N_participants, length(lan)*2);
results_der_int = NaN(N_participants, length(lan)*2);

% loop through the table entries
for i=1:N_entries

    row = metadata(i,:);
    
    % compute intensity
    filepath = audio_path + "/" + row.LANGUAGE + "_" + row.PROFICIENCY +"_" + row.F_NAME+ "_" + row.L_NAME + "." + row.TYPE;

    [y,Fs] = audioread(filepath);
%     Int = si.avg_sound_intensity(y, false);
    [Int ,Int_der] = si.avg_normalized_sound_intensity_derivative(y, false);

    % find name
    pos= partdict(row.F_NAME + "_" + row.L_NAME);
    
    %append to results
    results_int(pos,landict(row.LANGUAGE)) = Int;
    results_der_int(pos,landict(row.LANGUAGE)) = Int_der;

    results_int(pos,length(lan)+landict(row.LANGUAGE) ) = sizedict(row.PROFICIENCY);
    results_der_int(pos,length(lan)+landict(row.LANGUAGE) ) = sizedict(row.PROFICIENCY);
end


%% Plot the intensity results

tiledlayout(2,1)

nexttile
scatter(1:N_participants, results_int(:,1),results_int(:,5), 'filled')
alpha(0.8)
hold on
scatter(1:N_participants, results_int(:,2), results_int(:,6),'filled')
alpha(0.8)
hold on
scatter(1:N_participants, results_int(:,3), results_int(:,7),'filled')
alpha(0.8)
hold on
scatter(1:N_participants, results_int(:,4),results_int(:,8), 'filled')
alpha(0.8)
hold on

xlabel("Participant")
ylabel("Amplitude")

title("Average Intensity of speech")

legend("English","French","German","Serbo-Croatian")


nexttile
scatter(1:N_participants, results_der_int(:,1),results_der_int(:,5), 'filled')
alpha(0.8)
hold on
scatter(1:N_participants, results_der_int(:,2), results_der_int(:,6),'filled')
alpha(0.8)
hold on
scatter(1:N_participants, results_der_int(:,3),results_der_int(:,7), 'filled')
alpha(0.8)
hold on
scatter(1:N_participants, results_der_int(:,4),results_der_int(:,8), 'filled')
alpha(0.8)

xlabel("Participant")
ylabel("Amplitude")

title("Average Intensity Absolute Derivative")

legend("English","French","German","Serbo-Croatian")

hold off

%%  Avg per profile of relative derivative of intensity

profdict =containers.Map(prof,1:4);

avg_int_der = zeros(length(lan),length(prof));
instances = zeros(length(lan),length(prof));


% loop through the table entries
for i=1:N_entries

    row = metadata(i,:);

    
    % find duration for this person
    Int_der = results_der_int(partdict(row.F_NAME + "_"  + row.L_NAME),landict(row.LANGUAGE));

    % add to the avg array
    xi = landict(row.LANGUAGE);
    xj = profdict(row.PROFICIENCY);

    avg_int_der(xi,xj) = avg_int_der(xi,xj)+ Int_der;
    instances(xi,xj) = instances(xi,xj) +1;

   

end


avg_int_der = avg_int_der./instances;

X = categorical({'English','French','German','Serbo-Croatian'});
bar(X,avg_int_der);
ylabel("amplitude")
title("Normalized Intensity Derivative vs Language Proficiency")
legend({'Full','Professional','Working','Basic'})






