classdef soundIntensityMethods
    %SOUNDINTENSITYMETHODS  
    % Defines the methods related to sound intensity
    
%     properties
%         Property1
%     end
    
%     methods
%         function obj = soundIntensityMethods(inputArg1,inputArg2)
%             %SOUNDINTENSITYMETHODS Construct an instance of this class
%             %   Detailed explanation goes here
%             obj.Property1 = inputArg1 + inputArg2;
%         end
%         
%         function outputArg = method1(obj,inputArg)
%             METHOD1 Summary of this method goes here
%               Detailed explanation goes here
%             outputArg = obj.Property1 + inputArg;
%         end
%     end
     methods(Static)
         function mean_intensity = avg_sound_intensity(sig)

            plot_flag = false;   % the plot doesn't show even when true ...
            
            % absolut value of sig
            instant_intensity = abs(sig);
            
            % detect envelope
            env = envelope(instant_intensity,1000, 'peak'); % second argument is the smoothing
            
            % remove the silences
            indexOfLoud = env > 0.1 * max(env); % threshold = 20% of mean value
            onlyLoudParts = env(indexOfLoud);
            
            % average on the parts when the person's speaking
            mean_intensity = mean(onlyLoudParts);
            val = amean_intensity * ones(1,length(onlyLoudParts));
            
            if plot_flag 
                figure(1)
                tiledlayout(3,1)
                
                nexttile()
                plot(abs(y))
                
                nexttile()
                plot(1:length(env), env, 1:length(env), indexOfLoud)
                
                nexttile()
                plot(1:length(onlyLoudParts), onlyLoudParts, 1:length(onlyLoudParts),val);
                hold on;
            end
       end
     end
    
end

