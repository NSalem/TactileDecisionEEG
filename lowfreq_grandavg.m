    %Does the grand averages of frequency data for all subjects saves the
    %data and makes power spectrum plots.
    
%% Find subject folders
    
grandavgdir = 'E:\TactileDecision\GrandAverages';
experimentdir = 'E:\TactileDecision\Data\';
cd('E:\TactileDecision\fieldtrip-20141231');
%cd('E:\TactileDecision\fieldtrip-20160430');

ft_defaults;
    
[directories,sessions] = collectsubjectinfo(experimentdir); 

mysubjects = [1:length(directories)]; %select subjects by number
mysubjects

    
   

    % Load all participants data
    
    allsubjects_lowfreq_easy = {};
    allsubjects_lowfreq_medium ={};
    allsubjects_lowfreq_hard = {};
    
    for isubject = mysubjects

        display('________________________________________________');
        display(['subject: ',num2str(isubject)]);
        if ~exist([experimentdir,directories{isubject},filesep,'matfiles'],'dir')

            %display error message?

        end
        
        datafile_lowfreq_easy = [experimentdir,directories{isubject},filesep,'matfiles',filesep,'lowfreqs_easy'];
        datafile_lowfreq_medium = [experimentdir,directories{isubject},filesep,'matfiles',filesep,'lowfreqs_medium'];
        datafile_lowfreq_hard = [experimentdir,directories{isubject},filesep,'matfiles',filesep,'lowfreqs_hard'];

        load(datafile_lowfreq_easy, 'lowfreqs_easy');
        load(datafile_lowfreq_medium, 'lowfreqs_medium');
        load(datafile_lowfreq_hard, 'lowfreqs_hard');
        

        allsubjects_lowfreq_easy = [allsubjects_lowfreq_easy, lowfreqs_easy]; 
        allsubjects_lowfreq_medium = [allsubjects_lowfreq_medium, lowfreqs_medium];
        allsubjects_lowfreq_hard = [allsubjects_lowfreq_hard, lowfreqs_hard];
    
        clear easy medium hard
    end

    clear lowfreqs_easy lowfreqs_medium lowfreqs hard sessions mysubjcects isubject

% Save all subjects freq data for each condition 
    save ([experimentdir, '/_AllSubjectsData/allsubjects_lowfreq_easy'], 'allsubjects_lowfreq_easy');
    save ([experimentdir, '/_AllSubjectsData/allsubjects_lowfreq_medium'], 'allsubjects_lowfreq_medium');
    save ([experimentdir, '/_AllSubjectsData/allsubjects_lowfreq_hard'], 'allsubjects_lowfreq_hard');
 

%% Do grandaverages 

     cfg = []; 
     cfg.channel        = {'all', '-21', '-22', '-31'}; %deselect eog channels
     cfg.keepindividual = 'yes';
     
    lowfreq_grandavg_easy =  ft_freqgrandaverage(cfg, allsubjects_lowfreq_easy{:}); %%grand average for easy trials
    lowfreq_grandavg_medium =  ft_freqgrandaverage(cfg, allsubjects_lowfreq_medium{:}); %%grand average for medium trials
    lowfreq_grandavg_hard =  ft_freqgrandaverage(cfg, allsubjects_lowfreq_hard{:}); %%grand average for hard trials
    
    save ([grandavgdir, '/lowfreq_grandavg_easy'], 'lowfreq_grandavg_easy'); 
    save ([grandavgdir,  '/lowfreq_grandavg_medium'], 'lowfreq_grandavg_medium');
    save ([grandavgdir,  '/lowfreq_grandavg_hard'], 'lowfreq_grandavg_hard');
    
    clear data_easy data_medium data_hard allsubjects_lowfreq_easy allsbuject_lowfreq_medium allsubjects_lowfreq_hard
    %%plot
  
    cfg = [];
            cfg.channel = {'all', '-21','-22','-31'}; %take out eog channels
            cfg.layout = 'Bledowski110.lay';
            cfg.interactive = 'yes';
            cfg.showoutline = 'yes';
            cfg.graphcolor    ='rgb';
            cfg.xlim = [-0.7, 1.3];
            cfg.colorbar         = 'yes';
            cfg.hotkeys          = 'yes';
            cfg.zlim         =  [-10 10];	        

    
  
    %multiplots
    figure();
    ft_multiplotTFR(cfg, lowfreq_grandavg_easy);
    saveas(gcf, [experimentdir, filesep, '_plots', filesep, 'lowfreq_grandavg_easy_multiplot.png']);
    close();
    
    
    figure();
    ft_multiplotTFR(cfg, lowfreq_grandavg_medium);
    saveas(gcf, [experimentdir, filesep, '_plots', filesep, 'lowfreq_grandavg_medium_multiplot.png']);
    close();
    
    figure();
    ft_multiplotTFR(cfg, lowfreq_grandavg_hard);
    saveas(gcf, [experimentdir, filesep, '_plots', filesep, 'lowfreq_grandavg_hard_multiplot.png']);
    close();
    
    
    %Singleplots
    
    figure();
    ft_singleplotTFR(cfg, lowfreq_grandavg_easy);
    title('Easy trials');
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    saveas(gcf, [experimentdir, filesep, '_plots', filesep, 'lowfreq_grandavg_easy_singleplot.png']);
    close();
    
    
    figure();
    ft_singleplotTFR(cfg, lowfreq_grandavg_medium);
    title('Medium trials')
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    saveas(gcf, [experimentdir, filesep, '_plots', filesep, 'lowfreq_grandavg_medium_singleplot.png']);
    close();
    
    figure();
    ft_singleplotTFR(cfg, lowfreq_grandavg_hard);
    title('Hard trials');
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');    
    saveas(gcf, [experimentdir, filesep, '_plots', filesep, 'lowfreq_grandavg_hard_singleplot.png']);
    close();
   