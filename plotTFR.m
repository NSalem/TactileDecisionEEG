%%This script plots the power spectra for the relevant channels from 
%the cluster statistics for the two significant clusters found.  


%% Load data

grandavgdir = 'E:\TactileDecision\GrandAverages';
experimentdir = 'E:\TactileDecision\Data\';
cd('E:\TactileDecision\fieldtrip-20141231');
%cd('E:\TactileDecision\fieldtrip-20160430');
addpath('C:\DATA\matlab\donders\common');

load([grandavgdir, filesep, 'lowfreq_grandavg_easy']);
load([grandavgdir, filesep, 'lowfreq_grandavg_hard']);

[lowfreq_grandavg_easy.powspctrm,outlierindcs] = removeoutliers(lowfreq_grandavg_easy.powspctrm,0,3,1);
[lowfreq_grandavg_hard.powspctrm,outlierindcs] = removeoutliers(lowfreq_grandavg_hard.powspctrm,0,3,1);

%% 1st cluster

cluster_times =  [0.405050 0.638174];
cluster_freqs = [1.287669 5.774843];
pos = [cluster_times(1) cluster_freqs(1) cluster_times(2)-cluster_times(1) cluster_freqs(2)-cluster_freqs(1)];

cfg= [];
cfg.xlim =[0 1];
cfg.channel = {'2', '3', '6', '7', '33', '35', '38', '39', '44'};
cfg.zlim =[-3 3];
figure();
ft_singleplotTFR(cfg, lowfreq_grandavg_easy)
colorbar;
xlabel('Time (s)'); ylabel('Frequency (Hz)');
title ('Easy trials');
rectangle ('Position',pos, 'LineStyle', '--') 
figure();
ft_singleplotTFR(cfg, lowfreq_grandavg_hard)
title('Hard trials')
colorbar;
xlabel('Time (s)'); ylabel('Frequency (Hz)');
rectangle ('Position',pos, 'LineStyle', '--') 

%% 2nd cluster

cluster_times = [0.641052 0.823810];
cluster_freqs = [15.134414 22.202627];
pos = [cluster_times(1) cluster_freqs(1) cluster_times(2)-cluster_times(1) cluster_freqs(2)-cluster_freqs(1)];

cfg= [];
cfg.channel = {'8','35', '39','40','45', '54'}; % Best difference in plot
%cfg.channel = {'35', '39','40','54'}; %highest t
cfg.xlim = [0 1];
cfg.zlim =[-1 1]
figure();
ft_singleplotTFR(cfg, lowfreq_grandavg_easy);
colorbar;
xlabel('Time (s)'); ylabel('Frequency (Hz)');
title ('Easy trials');
rectangle ('Position', pos, 'LineStyle', '--') 
figure();
ft_singleplotTFR(cfg, lowfreq_grandavg_hard)
title('Hard trials')
colorbar;
xlabel('Time (s)'); ylabel('Frequency (Hz)');

rectangle ('Position', pos, 'LineStyle', '--') 