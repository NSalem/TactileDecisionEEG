%Does timelock/ERP analysis for each subject, saves the results to
%corresponding files and makes plots.

addpath('E:\TactileDecision\fieldtrip-20141231');
experimentdir = 'E:\TactileDecision\Data\';

%% Find subject folders and files
[directories,sessions] = collectsubjectinfo(experimentdir); 
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
%% Do the timelock analysis for each subject

        %%lowpass filter at 35 Hz
        cfg.lpfilter    = 'yes';
        cfg.lpfreq      = 35;
        data          = ft_preprocessing(cfg,data); %maybe should save this to new file?


        %%ERP of S1 and S2
        cfg = [];
        cfg.keeptrials         = 'no';
        cfg.trials = find(data.trialinfo<=2);
        cfg.vartrllength = 2; %???
        display ('hard trials')
        hard = ft_timelockanalysis(cfg, data);


        %%ERP of S3 and S4
        cfg = [];
        cfg.keeptrials         = 'no';
        cfg.trials = find(data.trialinfo>2 & data.trialinfo<5);
        cfg.vartrllength = 2; %???
        display ('medium trials')
        medium = ft_timelockanalysis(cfg, data);



        %%ERP of S5 and S6
        cfg = [];
        cfg.keeptrials         = 'no';

        cfg.trials = find(data.trialinfo>=5);
        cfg.vartrllength = 2; %???
        display ('easy trials')
        easy = ft_timelockanalysis(cfg, data);


        %baseline correction
        cfg =[];
        cfg.baseline =[-0.1, 0]; %baseline window
        easy = ft_timelockbaseline(cfg, easy)
        medium = ft_timelockbaseline(cfg, medium)
        hard = ft_timelockbaseline(cfg, hard)



        %save files for each difficulty leel
        save ([experimentdir, directories{isubject}, filesep, 'matfiles/timelock_hard'], 'hard')
        save ([experimentdir, directories{isubject}, filesep, 'matfiles/timelock_medium'], 'medium')
        save ([experimentdir, directories{isubject}, filesep, 'matfiles/timelock_easy'], 'easy')

        %%Make plots 
        if ~exist([experimentdir,directories{isubject},filesep,'plots'],'dir')
            mkdir([experimentdir,directories{isubject}],'plots');
        end

        cfg = [];
        cfg.channel = {'all', '-21','-22','-31'}; %take out eog channels
        cfg.layout = 'Bledowski110.lay';
        cfg.interactive = 'yes';
        cfg.showoutline = 'yes';
        cfg.graphcolor    ='rgb';
        cfg.xlim = [-0.7, 1.3];

        figure();
        ft_multiplotER(cfg, hard, medium, easy);
        saveas(gcf, [experimentdir,directories{isubject},filesep,'plots', filesep,'multiplot.png']);
        close 


        %% Plot average of absolute value voltage for each condition

        easy.avg = abs(easy.avg); 
        medium.avg = abs(medium.avg);
        hard.avg = abs(hard.avg);

        figure();
        ft_singleplotER(cfg, hard, medium, easy);
        xlabel('Time (s)'); ylabel('Voltage (\muV)'); title('');
        legend('Hard','Medium', 'Easy');
        saveas(gcf, [experimentdir,directories{isubject},filesep,'plots', filesep,'ERPs.png']);
        close

end

