%Make grand average of timelock/ERP data for all participants, saves the
%data to a file and makes plots

%% Find subject folders
experimentdir = 'E:\TactileDecision\Data\';
grandavgdir = 'E:\TactileDecision\GrandAverages';
cd('E:\TactileDecision\fieldtrip-20141231');
ft_defaults;

[directories,sessions] = collectsubjectinfo(experimentdir); 
mysubjects = [1:length(directories)]; %select subjects by number
mysubjects

%% Load all participants data

allsubjects_tmlk_easy = {};
allsubjects_tmlk_medium ={};
allsubjects_tmlk_hard = {};

for isubject = mysubjects

    display('________________________________________________');
    display(['subject: ',num2str(isubject)]);
    if ~exist([experimentdir,directories{isubject},filesep,'matfiles'],'dir')

        %display error message?

    end

    datafile_tmlk_easy = [experimentdir,directories{isubject},filesep,'matfiles',filesep,'timelock_easy'];
    datafile_tmlk_medium = [experimentdir,directories{isubject},filesep,'matfiles',filesep,'timelock_medium'];
    datafile_tmlk_hard = [experimentdir,directories{isubject},filesep,'matfiles',filesep,'timelock_hard'];

    load(datafile_tmlk_easy, 'easy');
    load(datafile_tmlk_medium, 'medium');
    load(datafile_tmlk_hard, 'hard');


    allsubjects_tmlk_easy = [allsubjects_tmlk_easy, easy]; 
    allsubjects_tmlk_medium = [allsubjects_tmlk_medium, medium];
    allsubjects_tmlk_hard = [allsubjects_tmlk_hard, hard];

    clear easy medium hard
end


% Save all subjects timelock data for each condition 
save ([experimentdir, '/_AllSubjectsData/allsubjects_tmlk_easy'], 'allsubjects_tmlk_easy');
save ([experimentdir, '/_AllSubjectsData/allsubjects_tmlk_medium'], 'allsubjects_tmlk_medium');
save ([experimentdir, '/_AllSubjectsData/allsubjects_tmlk_hard'], 'allsubjects_tmlk_hard');


%% Do grandaverages 

 cfg = []; 
 cfg.channel        = {'all', '-21', '-22', '-31'}; %deselect eog channels
 cfg.method         = 'across' ;

tmlk_grandavg_easy =  ft_timelockgrandaverage(cfg, allsubjects_tmlk_easy{:}); %%grand average for easy trials
tmlk_grandavg_medium =  ft_timelockgrandaverage(cfg, allsubjects_tmlk_medium{:}); %%grand average for medium trials
tmlk_grandavg_hard =  ft_timelockgrandaverage(cfg, allsubjects_tmlk_hard{:}); %%grand average for hard trials

save ([grandavgdir, '/tmlk_grandavg_easy'], 'tmlk_grandavg_easy'); 
save ([grandavgdir,  '/tmlk_grandavg_medium'], 'tmlk_grandavg_medium');
save ([grandavgdir,  '/tmlk_grandavg_hard'], 'tmlk_grandavg_hard');

clear data_easy data_medium data_hard


%%plot


cfg = [];
        cfg.channel = {'all', '-21','-22','-31'}; %take out eog channels
        cfg.layout = 'Bledowski110.lay';
        cfg.interactive = 'yes';
        cfg.showoutline = 'yes';
        cfg.graphcolor    ='rgb';
        cfg.xlim = [-0.7, 1.3];



%multiplot

figure();   
ft_multiplotER(cfg, tmlk_grandavg_easy, tmlk_grandavg_medium, tmlk_grandavg_hard);
saveas(gcf, [experimentdir, filesep,'_plots', filesep, 'multiplot_lowfreq_grandavg.png']);
close;


figure();
%ABSOLUTE VALUES
tmlk_grandavg_easy.avg = abs(tmlk_grandavg_easy.avg);
tmlk_grandavg_medium.avg = abs(tmlk_grandavg_medium.avg);
tmlk_grandavg_hard.avg = abs(tmlk_grandavg_hard.avg);

ft_singleplotER(cfg, tmlk_grandavg_easy, tmlk_grandavg_medium, tmlk_grandavg_hard);
legend('Hard','Medium', 'Easy');
xlabel('Time (s)'); ylabel('Amplitude(\muV)'); title ('');
saveas(gcf, [experimentdir, filesep, '_plots', filesep, 'singleplot_lowfreq_grandavg.png']);
close



