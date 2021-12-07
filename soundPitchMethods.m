classdef soundPitchMethods
    %SOUNDPITCHMETHODS 
    %   Methods for pitch analysis
    
    methods(Static)
        function mean_pitch = avg_speech_pitch(sig, Fs, plot_flag)
            %AVG_SPEECH_PITCH 
            %   compute average speech pitch
            
            %run pitch funtion on whole signal
            winLength = round(0.05*Fs);
            overlapLength = round(0.045*Fs);
            f0 = pitch(sig,Fs,'Method','SRH','WindowLength',winLength,'OverlapLength',overlapLength);
            %tf0 = idx/Fs;


            % remove silence from pitch
            hr = harmonicRatio(sig,Fs,"Window",hamming(winLength,'periodic'),"OverlapLength",overlapLength);
            thres = 0.8*max(hr);
            indexOfSound_f = hr > thres;
            f0_OnlySound = f0(indexOfSound_f);
           
            % low pass the pitch
            filtered_pitch = lowpass(f0_OnlySound,1e-10);


            mean_pitch = mean(filtered_pitch);


            if plot_flag ==true
                
                tiledlayout(2,2)
                
                %plot signal
                nexttile(1)
                plot(sig)
                
                xlabel("time")
                ylabel("amplitude")
        
                title("Audio signal")

                % plot detected pitch
                nexttile(3)
                plot(f0)
                hold on
                area(indexOfSound_f*max(f0), 'LineStyle','none')
                alpha(.3)

                xlabel("time")
                ylabel("frequency")
        
                title("Detected pitch")

                legend("detected pitch value", "speech detection (harmonic ratio)")

                % plot detected pitch with silence removed
                nexttile(2)
                plot(f0_OnlySound)


                xlabel("time")
                ylabel("frequency")
        
                title("Pitch with silence removed")


                % plot filtered pitch
                nexttile(4)
                plot(filtered_pitch)
                hold on
                plot(mean_pitch*ones(1,length(filtered_pitch)))
            

                xlabel("time")
                ylabel("frequency")
        
                title("Pitch with silence removed filtered")

                legend("pitch", "average pitch")


            end

        end
    end
end

