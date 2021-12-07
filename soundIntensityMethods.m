classdef soundIntensityMethods
    %SOUNDINTENSITYMETHODS  
    % Defines the methods related to sound intensity
    % the plot flag is meant to allow plotting the steps of the

    
    
     methods(Static)
         function mean_intensity = avg_sound_intensity(sig, plot_flag)
            
            % absolute value of sig
            instant_intensity = abs(sig);
            
            % detect envelope
            env = envelope(instant_intensity,1000, 'peak'); % second argument is the smoothing
            
            % remove the silences
            thresh = 0.1 * max(env);
            indexOfLoud = env > thresh; % threshold = 20% of mean value
            onlyLoudParts = env(indexOfLoud);
            
            % average on the parts when the person's speaking
            mean_intensity = mean(onlyLoudParts);
            
            if plot_flag 
                figure(1)
                tiledlayout(3,1)
                
                % absolute signal
                nexttile()
                plot(abs(sig))

                xlabel("time")
                ylabel("signal")
        
                title("Absolute signal")
                
                % envolope and silence detection
                nexttile()
                plot(env)
                hold on
                plot(thresh*ones(1, length(env)))
                hold on
                area(indexOfLoud, 'LineStyle','none')
                alpha(.3)

                xlabel("time")
                ylabel("signal")
        
                title("Signal envelope")

                legend("signal envelope", "threshold","voice detected")
                
                % only loud and mean intensity
                nexttile()
                plot(1:length(onlyLoudParts), onlyLoudParts, 1:length(onlyLoudParts),mean_intensity * ones(1,length(onlyLoudParts)));
                
                xlabel("time")
                ylabel("signal")
        
                title("Trimmered signal envelope (silence removed)")

                legend("signal envelope", "average intensity")
                
                
                
                hold off;
            end
         end

         function mean_intensity_derivative = avg_sound_intensity_derivative(sig, plot_flag)
            
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
                
                % signal envelope
                nexttile()
                plot(env)

                xlabel("time")
                ylabel("signal")
        
                title("Signal envelope")
                
                % derivative of signal envelope
                nexttile()
                plot(1:length(der),der, 1:length(der),mean_intensity_derivative * ones(1,length(der)))
                
                xlabel("time")
                ylabel("signal")
        
                title("Derivative of signal envelope")
                
                legend("signal envelope derivative", "average absolute intensity derivative")

                hold off;
            end
         end
     
     
    end
    
end

