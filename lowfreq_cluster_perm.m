%This script does the cluster permutation analysis for the frequency data,
%comparing hard vs easy trials. The calculated statistics for the first 
%cluster and second cluster are saved and an interactive map of the 
%t-statistic of the cluster is plotted. Channels with high values can be
%selected to see their t-statistic across time and frequencies. 
%A significant time-frequency window of the t-statistic can then be selected
%to find the topographies those frequencies and times.

grandavgdir = 'E:\TactileDecision\GrandAverages';
experimentdir = 'E:\TactileDecision\Data\';
cd('E:\TactileDecision\fieldtrip-20141231');
%cd('E:\TactileDecision\fieldtrip-20160430');
addpath('C:\DATA\matlab\donders\common');

ft_defaults;

%load grandaverage files

load([grandavgdir, filesep, 'lowfreq_grandavg_easy']);
load([grandavgdir, filesep, 'lowfreq_grandavg_medium']);
load([grandavgdir, filesep, 'lowfreq_grandavg_hard']);

[lowfreq_grandavg_easy.powspctrm,outlierindcs] = removeoutliers(lowfreq_grandavg_easy.powspctrm,0,3,1); 
[lowfreq_grandavg_medium.powspctrm,outlierindcs] = removeoutliers(lowfreq_grandavg_medium.powspctrm,0,3,1);
[lowfreq_grandavg_hard.powspctrm,outlierindcs] = removeoutliers(lowfreq_grandavg_hard.powspctrm,0,3,1);

%% Permutation test based on cluster stats w/o averaging across time

%Set neighbour electrodes

cfg = [];
cfg.layout      = 'Bledowski110.lay';                      % specify layout of sensors*
cfg.method      = 'distance';
cfg.neighbourdist = 0.17; %number, maximum distance between neighbouring sensors (only for 'distance')


cfg.feedback    = 'yes';                             % show a neighbour plot 
neighbours      = ft_prepare_neighbours(cfg, lowfreq_grandavg_medium); % define neighbouring channels

%keyboard();
close all

% do stats

cfg = [];
cfg.channel     = 'all';
cfg.neighbours  = neighbours; % defined as above
cfg.latency     = [-0.2 0.8];
cfg.avgovertime = 'no';
cfg.avgoverfreq = 'no';
%cfg.parameter   = 'avg';
cfg.frequency   = [2.5 40]; %allsubjects_lowfreq_easy{1,1}.freq; <- Not necessary. 
cfg.method              = 'montecarlo';
cfg.statistic           = 'depsamplesT';      %cfg.statistic           = 'depsamplesregrT'; 
cfg.correctm            = 'cluster';
cfg.clusteralpha        = 0.05;
cfg.clusterstatistic    = 'maxsum';
cfg.minnbchan           = 2;
cfg.tail                = 0;
cfg.clustertail         = 0;
cfg.alpha               = 0.05; % 0.025;
cfg.numrandomization    = 1000;
cfg.correcttail = 'prob';

Nsub = 14;


cfg.design(1,1:2*Nsub)  = [ones(1,Nsub) 2*ones(1,Nsub)];
cfg.design(2,1:2*Nsub)  = [1:Nsub 1:Nsub];

cfg.ivar                = 1; % the 1st row in cfg.design contains the independent variable
cfg.uvar                = 2; % the 2nd row in cfg.design contains the subject number
 

%Check time axes for participants. There seem to be minor differences
%between the time bins for each condition

if any(lowfreq_grandavg_hard.time ~= lowfreq_grandavg_easy.time); 
    
    lowfreq_grandavg_hard.time = lowfreq_grandavg_easy.time

end

%Do the stats 

lowfreq_stat = ft_freqstatistics(cfg, lowfreq_grandavg_hard, lowfreq_grandavg_easy);



save ([experimentdir, '/_AllSubjectsData/lowfreq_stat'], 'lowfreq_stat');

% 
dumstat = zeros(size(lowfreq_stat.stat));
 
dumstat(find(lowfreq_stat.posclusterslabelmat ==1)) = lowfreq_stat.stat(find(lowfreq_stat.posclusterslabelmat ==1));


%% Plot for cluster 1 (REMEMBER 2nd cluster also significant)

lowfreqplot = rmfield(lowfreq_grandavg_easy, {'powspctrm', 'dimord'});
lowfreqplot.powspctrm = dumstat%(:,1,:)%dumstat_mean 
lowfreqplot.time = lowfreq_stat.time;
lowfreqplot.dimord = 'chan_freq_time';
pcfg = struct();
pcfg.parameter = 'powspctrm';
pcfg.xlim = [0.0, 0.8]
pcfg.marker = 'labels';
%pcfg.zlim = [-1, 1]*3 
pcfg.layout = 'Bledowski110.lay';
pcfg.dimord = 'chan_freq_time';

% pcfg.highlight = 'on';
% pos_clusters = lowfreq_stat.posclusterslabelmat(:, :, find(lowfreq_stat.time > pcfg.xlim(1) & lowfreq_stat.time < pcfg.xlim(2))); %this contain ALL POSITIVE CLUSTERS in window significant or not
% pos1 = (pos_clusters == 1)*1;
% pos2 = (pos_clusters == 2)*1;
% 
% pcfg.highlightchannel = pos1, pos2 ;

pcfg.interactive = 'yes';
figure
ft_topoplotTFR(pcfg,lowfreqplot);
colorbar;
title('Cluster t-values between 0.0 s and 0.7 s');

keyboard;

%% 2nd Cluster

% 
dumstat = zeros(size(lowfreq_stat.stat));
 
dumstat(find(lowfreq_stat.posclusterslabelmat ==2)) = lowfreq_stat.stat(find(lowfreq_stat.posclusterslabelmat ==2));

lowfreqplot = rmfield(lowfreq_grandavg_easy, {'powspctrm', 'dimord'});
lowfreqplot.powspctrm = dumstat; 
lowfreqplot.time = lowfreq_stat.time;
lowfreqplot.dimord = 'chan_freq_time';
pcfg = struct();
pcfg.parameter = 'powspctrm';
pcfg.xlim = [0.0, 0.8] 

pcfg.marker = 'labels';
%pcfg.zlim = [-1, 1]*3 
pcfg.layout = 'Bledowski110.lay';
pcfg.dimord = 'chan_freq_time';

% pcfg.highlight = 'on';
% pos_clusters = lowfreq_stat.posclusterslabelmat(:, :, find(lowfreq_stat.time > pcfg.xlim(1) & lowfreq_stat.time < pcfg.xlim(2))); %this contain ALL POSITIVE CLUSTERS in window significant or not
% pos1 = (pos_clusters == 1)*1;
% pos2 = (pos_clusters == 2)*1;
% 
% pcfg.highlightchannel = pos1, pos2 ;

pcfg.interactive = 'yes';
figure
ft_topoplotTFR(pcfg,lowfreqplot);
colorbar;
title('Cluster t-values between 0.0 s and 0.8 s');

keyboard;


