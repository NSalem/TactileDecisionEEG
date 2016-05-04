%This script plots the ERPs for the relevant channels from the cluster statistics 

grandavgdir = 'E:\TactileDecision\GrandAverages';
experimentdir = 'E:\TactileDecision\Data\';
cd('E:\TactileDecision\fieldtrip-20141231');
ft_defaults;

%load grandaverage timelock files

load([grandavgdir, filesep, 'tmlk_grandavg_easy']);
load([grandavgdir, filesep, 'tmlk_grandavg_hard']);

cfg = [];
cfg.channel = {'1', '5', '9', '10', '97', '98', '101'};
cfg.xlim = [0 0.7];
figure();
ft_singleplotER(cfg, tmlk_grandavg_easy, tmlk_grandavg_hard);
legend('Easy', 'Hard', 'location', 'SouthEast'); 
xlabel('Time(s)'); ylabel('Voltage (\muV)');
title('');
vline(0.174, 'color', 'black', 'LineStyle', '--');
vline(0.254, 'color', 'black', 'LineStyle', '--');


%Late component

cfg = [];
cfg.channel = {'5','9', '10', '15', '97', '98','99','101','102','104', '105'};
cfg.xlim = [0 0.7];
figure();
ft_singleplotER(cfg, tmlk_grandavg_easy, tmlk_grandavg_hard);
legend('Easy', 'Hard', 'location', 'SouthEast'); xlabel('Time(s)'); ylabel('Voltage (\muV)');
title('');
vline(0.33, 'color', 'black', 'LineStyle', '--');
vline(0.52, 'color', 'black', 'LineStyle', '--');