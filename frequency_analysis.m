function frequency_analysis()
%Does frequency analysis, performs baseline correction and saves the
%results and corresponding plots

    analyzelowfreqs = 1;
    analyzehighfreqs = 0;

    
    addpath('E:\TactileDecision\fieldtrip-20141231');
    experimentdir = 'E:\TactileDecision\Data\';

    %% Find subject folders and files
    [directories] = collectsubjectinfo(experimentdir); 
    if nargin<1
        mysubjects = [1:length(directories)]; %select subjects by number
    mysubjects
    end
    
    for isubject = mysubjects

        display('________________________________________________');
        display(['subject: ',num2str(isubject)]);
        if ~exist([experimentdir,directories{isubject},filesep,'matfiles'],'dir')

            %display error message?
        end;
              datafile = [experimentdir,directories{isubject},filesep,'matfiles',filesep,'dataclean_merged'];
              load(datafile);
              data = merged_data;

         %% Low frequency analyisis 
        
         if analyzelowfreqs
             
             
             display(['__Subject: ',num2str(isubject)]);
             disp('Low freqs')
             
    %general cfg parameters for all conditions (lowfreq)
            cfg = [];    
            cfg.output       = 'pow';
            cfg.channel      = {'all'};
            cfg.method       = 'mtmconvol'; %'mtmconvol
            cfg.taper        = 'hanning';
            cfg.foi          = 2.5:2.5:40;    %2.5:2.5:40                     % analysis 2.5 to 40 Hz in steps of 2.5 Hz 
            cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.4;   % length of time window = 0.4 sec
            cfg.toi          = -0.6:0.05:1.2;                  % time window "slides" from -0.6 to 1.2 sec in steps of 0.05 sec (50 ms)
            
             cfgplot = []; 
             cfgplot.zlim         = [-10 10];	        
             cfgplot.showlabels   = 'yes';
             cfgplot.colorbar         = 'yes';
             cfgplot.hotkeys          = 'yes';
             cfgplot.layout       = 'Bledowski110.lay';
            
            cfgb =[];
            cfgb.baseline =[-0.5 -0.1]; %baseline window
            
            
            %%Low-frequency analysis for hard trials
            disp('Processing hard trials')                       
         
            cfg.trials       =  find(data.trialinfo<=2);
            
            lowfreqs_hard= ft_freqanalysis(cfg, data);
                      
            %baseline correction

            lowfreqs_hard = ft_freqbaseline(cfgb, lowfreqs_hard);
            
            save ([experimentdir, directories{isubject}, filesep, 'matfiles/', 'lowfreqs_hard']); 
           
            figure(); 
            ft_multiplotTFR(cfgplot, lowfreqs_hard);
            
            %keyboard();
            
            saveas(gcf, [experimentdir,directories{isubject},filesep,'plots', filesep,'lowfreqs_hard_multi.png']);
            close();   
            
            figure(); 
            ft_singleplotTFR(cfgplot, lowfreqs_hard);
            title('Hard trials'); xlabel('Time (s)'); ylabel('Frequency (Hz)');
            xlabel('Time (s)'); ylabel ('Frequency (Hz)'); title ('');
            saveas(gcf, [experimentdir,directories{isubject},filesep,'plots', filesep,'lowfreqs_hard.png']);
            
            close();   
            clear lowfreqs_hard
            

            %%Low-frequency analysis for medium trials
            disp('Processing medium trials')           
            cfg.trials = find(data.trialinfo>2 & data.trialinfo<5);
            
          lowfreqs_medium= ft_freqanalysis(cfg, data);
                      
            %baseline correction

            lowfreqs_medium = ft_freqbaseline(cfgb, lowfreqs_medium);
            
            save ([experimentdir, directories{isubject}, filesep, 'matfiles/', 'lowfreqs_ medium']); 
           
            figure();   
            ft_multiplotTFR(cfgplot, lowfreqs_medium);
            saveas(gcf, [experimentdir,directories{isubject},filesep,'plots', filesep,'lowfreqs_medium_multi.png']);
            close();   
            
            figure(); 
            ft_singleplotTFR(cfgplot, lowfreqs_medium);   
            title('Hard trials'); xlabel('Time (s)'); ylabel('Frequency (Hz)');
            saveas(gcf, [experimentdir,directories{isubject},filesep,'plots', filesep,'lowfreqs_medium.png']);
            
            close();   
            clear lowfreqs_medium
            
            
                        %%Low-frequency analysis for easy trials
            disp('Processing easy trials')           
            
            cfg.trials       =  find(data.trialinfo>=5);

             lowfreqs_easy= ft_freqanalysis(cfg, data);
                      
            %baseline correction

            lowfreqs_easy = ft_freqbaseline(cfgb, lowfreqs_easy);
            
            save ([experimentdir, directories{isubject}, filesep, 'matfiles/', 'lowfreqs_easy']); 
           
            figure(); 
            ft_multiplotTFR(cfgplot, lowfreqs_easy);
            saveas(gcf, [experimentdir,directories{isubject},filesep,'plots', filesep,'lowfreqs_easy_multi.png']);
            close();   
            
            figure(); 
            ft_singleplotTFR(cfgplot, lowfreqs_easy);   
            title('Hard trials'); xlabel('Time (s)'); ylabel('Frequency (Hz)');
            saveas(gcf, [experimentdir,directories{isubject},filesep,'plots', filesep,'lowfreqs_easy.png']);
            
            close();   
            clear lowfreqs_easy
            
         end
            
            %% High frequency analyisis 
            if analyzehighfreqs

                display(['___Subject: ',num2str(isubject)]);
                disp('High freqs')
                
                
                
                %%Low-frequency analysis for hard trials
                disp('Processing hard trials')                       
                cfg              = [];
                cfg.trials       =  find(data.trialinfo<=2);
                
                highfreqs_hard = highfreq_analysis(cfg, data);
                save ([experimentdir, directories{isubject}, filesep, 'matfiles/', 'highfreqs_hard']); 
                makeplots(highfreqs_hard);
                saveas(gcf, [experimentdir,directories{isubject},filesep,'plots', filesep,'highfreqs_hard.png']);
                close   
                clear highfreqs_hard

                %%high-frequency analysis for medium trials
                disp('Processing medium trials')           
                cfg              = [];
                cfg.trials = find(data.trialinfo>2 & data.trialinfo<5);

                highfreqs_medium = highfreq_analysis(cfg, data);
                save ([experimentdir, directories{isubject}, filesep, 'matfiles/', 'highfreqs_medium']); 
                makeplots(highfreqs_medium);
                saveas(gcf, [experimentdir,directories{isubject},filesep,'plots', filesep,'highfreqs_medium.png']);
                close   
                clear highfreqs_medium


                            %%high-frequency analysis for easy trials
                disp('Processing easy trials')           
                cfg              = [];
                cfg.trials       =  find(data.trialinfo>=5);

                highfreqs_easy = highfreq_analysis(cfg, data);
                save ([experimentdir, directories{isubject}, filesep, 'matfiles/', 'highfreqs_easy']); 
                makeplots(highfreqs_easy);
                saveas(gcf, [experimentdir,directories{isubject},filesep,'plots', filesep,'highfreqs_easy.png']);
                close   
                clear highfreqs_easy 
            
            end
            
            clear data  
            
            
    end
    
end


%% Low frequency analysis

function lowfreqs = lowfreq_analysis(cfg, data)
           
%assing cfg.trials before function...
            
            cfg.output       = 'pow';
            cfg.channel      = {'all'};
            cfg.method       = 'mtmconvol'; %'mtmconvol
            cfg.taper        = 'hanning';
            cfg.foi          = 2.5:2.5:40;    %2.5:2.5:40                     % analysis 2.5 to 40 Hz in steps of 2.5 Hz 
            cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.4;   % length of time window = 0.4 sec
            cfg.toi          = -0.6:0.05:1.2;                  % time window "slides" from -0.6 to 1.2 sec in steps of 0.05 sec (50 ms)
            
            
            lowfreqs = ft_freqanalysis(cfg, data);
                      
            %baseline correction
            cfg =[];
            cfg.baseline =[-0.5 -0.1]; %baseline window
            lowfreqs = ft_freqbaseline(cfg, lowfreqs)


end

%% High frequency analysis

function highfreqs =highfreq_analysis(cfg, data)
           
%assing cfg.trials before function...

            cfg.output       = 'pow';
            cfg.channel      = {'all'};
            cfg.method       = 'mtmconvol';
            cfg.taper        = 'dpss';
            cfg.foi          = 40:5:100;                         % analysis 40 to 100 Hz in steps of 5 Hz 
            cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.4;   % length of time window = 0.4 sec
            cfg.toi          = -0.6:0.05:1.2;                  % time window "slides" from -0.6 to 1.2 sec in steps of 0.05 sec (50 ms)
            cfg.tapsmofrq = 20; % Not sure about this            
            
            highfreqs = ft_freqanalysis(cfg, data);

end

%% Make and save plots

function makeplots(data)
%make frequency plot averaging across channels

             cfg = [];
             %cfg.baseline     = [-0.5 -0.1]; 
             %cfg.baselinetype = 'absolute'; 
             %cfg.zlim         = [-3e-27 3e-27];	        
             cfg.showlabels   = 'yes';	
             cfg.layout       = 'Bledowski110.lay';
             figure(); 
             ft_singleplotTFR(cfg, data);   

end
          