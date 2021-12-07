classdef soundDurationMethods
    %SOUNDDURATIONMETHODS
    % Compute the duration of the audio samples

    methods(Static)
        function duration = audio_duration(sig, Fs, plot_flag)
        %AUDIO_DURATION Threshold the silence before and after the voice
        % and retrun the duration of the actual speech
        % sig: the signal
        % Fs: the sampling frequency
        % plot_flag: true -> plot, false -> no plot
        
            absolute = abs(sig);
            thresh = max(absolute)*0.05;
            
            i_start = 1;
            while absolute(i_start) < thresh
                i_start=i_start+1;
            end
            
            i_end = length(absolute);
            while absolute(i_end) < thresh
                i_end=i_end-1;
            end
            
            
            if plot_flag
        
                x = 1:length(absolute);
                figure(1)
                tiledlayout(2,1)
                
                nexttile
                plot(x,absolute,x, thresh*ones(1,length(x)))
                hold on
                scatter([i_start,i_end],[0,0], 'filled')
        
                xlabel("time")
                ylabel("amplitude")
        
                legend("abs(signal)","threshold","start/end")
        
                title("Absolute signal")
                
                nexttile
                plot(absolute(i_start:i_end))
        
                xlabel("time")
                ylabel("amplitude")
        
                title("Trimmered absolute signal")
        
                
                hold off
            end
        
            duration = (i_end- i_start)/Fs;
        end
    end
end

