% Only look at fully fluent speakers for each language to establish a  baseline
% Look at different characteristics of the languages to see how they differ, 

% retrieve metadata
audio_path = "./clean_audio";
metadata = metadata_init( audio_path);
N_entries = height(metadata);


% Only take native speakers 
natives = metadata( metadata.PROFICIENCY == "full", :);
N= height(natives);

% init the resulst
PERSON = strings(N,1);
LANGUAGE = strings(N,1);
PITCH = NaN(N,1);
INTENSITY = NaN(N,1);
INTENSITY_DER = NaN(N,1);
DURATION = NaN(N,1);

si = soundIntensityMethods;
sd = soundDurationMethods;
sp = soundPitchMethods;

for i =1:N

    row = natives(i,:);
    filepath = audio_path + "/" + row.LANGUAGE + "_" + row.PROFICIENCY +"_" + row.F_NAME+ "_" + row.L_NAME + "." + row.TYPE;

    [y,Fs] = audioread(filepath);

    PERSON(i,1) = row.F_NAME + "_" + row.L_NAME ;
    LANGUAGE(i,1) = row.LANGUAGE;
    PITCH(i,1) = sp.avg_speech_pitch(y, Fs, false);
    INTENSITY(i,1) = si.avg_sound_intensity(y, false);
    INTENSITY_DER(i,1) = si.avg_sound_intensity_derivative(y, false);
    DURATION(i,1) = sd.audio_duration(y,Fs, false);
end


results = table(PERSON,LANGUAGE,PITCH,INTENSITY,INTENSITY_DER,DURATION);

% Get the table in string form.
TString = evalc('disp(results)');
% Use TeX Markup for bold formatting and underscores.
TString = strrep(TString,'<strong>','\bf');
TString = strrep(TString,'</strong>','\rm');
TString = strrep(TString,'_','\_');
% Get a fixed-width font.
FixedWidth = get(0,'FixedWidthFontName');
% Output the table using the annotation command.
annotation(gcf,'Textbox','String',TString,'Interpreter','Tex',...
    'FontName',FixedWidth,'Units','Normalized','Position',[0 0 1 1]);

%% Compute the average values

lan=["english","french","german","serbian"];

LANG = strings(4,1);
AVG_PITCH = NaN(4,1);
AVG_INTENSITY = NaN(4,1);
AVG_INTENSITY_DER = NaN(4,1);
AVG_DURATION = NaN(4,1);


for  i=1:4
    arr = table2array(results(results.LANGUAGE==lan(i),["PITCH","INTENSITY","INTENSITY_DER","DURATION"]));
    avg = mean(arr,1);

    LANG(i,1) = lan(i);
    AVG_PITCH(i,1) = avg(1,1);
    AVG_INTENSITY(i,1) = avg(1,2);
    AVG_INTENSITY_DER(i,1) = avg(1,3);
    AVG_DURATION(i,1) = avg(1,4);

end


avg_results = table(LANG,AVG_PITCH,AVG_INTENSITY,AVG_INTENSITY_DER,AVG_DURATION);



% Get the table in string form.
TString = evalc('disp(avg_results)');
% Use TeX Markup for bold formatting and underscores.
TString = strrep(TString,'<strong>','\bf');
TString = strrep(TString,'</strong>','\rm');
TString = strrep(TString,'_','\_');
% Get a fixed-width font.
FixedWidth = get(0,'FixedWidthFontName');
% Output the table using the annotation command.
annotation(gcf,'Textbox','String',TString,'Interpreter','Tex',...
    'FontName',FixedWidth,'Units','Normalized','Position',[0 0 1 1]);
