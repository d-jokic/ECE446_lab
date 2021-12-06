classdef soundIntensityMethods
    %SOUNDINTENSITYMETHODS  
    % Defines the methods related to sound intensity
    
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
            
            if plot_flag 
                figure(1)
                tiledlayout(3,1)
                
                nexttile()
                plot(abs(y))
                
                nexttile()
                plot(1:length(env), env, 1:length(env), indexOfLoud)
                
                nexttile()
                plot(1:length(onlyLoudParts), onlyLoudParts, 1:length(onlyLoudParts),mean_intensity * ones(1,length(onlyLoudParts)));
                hold on;
            end
         end

         function mean_intensity_derivative = avg_sound_intensity_derivative(sig)

            plot_flag = false;   % the plot doesn't show even when true ...
            
            % absolut value of sig
            intensity = abs(sig);

            % detect envelope
            env = envelope(intensity,1000, 'peak');

            % compute the derivative of the intensity
            der = diff(env);
            
            % take
            mean_intensity_derivative = mean(abs(der));
            
            if plot_flag 

                figure(1)
                tiledlayout(2,1)
                
                nexttile()
                plot(env)
                
                nexttile()
                plot(1:length(der),der, 1:length(der),mean_intensity_derivative * ones(1,length(der)))
            end
         end
     
     
    end
    
end

