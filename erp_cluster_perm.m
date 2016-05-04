%This script does the cluster permutation analysis for the timelock/ERP data,
%comparing hard vs easy trials. The calculated statistics for the first 
%cluster and second cluster are saved and an interactive map of the 
%t-statistic of the cluster is plotted. Channels with high values can be
%selected to see their t-statistic across time. 
%A significant time window of the t-statistic can then be selected
%to find the topographies those times.

grandavgdir = 'E:\TactileDecision\GrandAverages';
experimentdir = 'E:\TactileDecision\Data\';
cd('E:\TactileDecision\fieldtrip-20141231');
ft_defaults;

%load grandaverage timelock files

load([grandavgdir, filesep, 'tmlk_grandavg_medium']);

%% Load structs containing average timelock data for each participant for each condition

load ([experimentdir, '/_AllSubjectsData/allsubjects_tmlk_easy']);
load ([experimentdir, '/_AllSubjectsData/allsubjects_tmlk_hard']);


%% Permutation test based on cluster statistic averaging across time


% Set neighbours

cfg = [];

cfg.method      = 'distance'; % try 'distance' as well
cfg.neighbourdist = 0.17; %number, maximum distance between neighbouring sensors (only for 'distance')

cfg.layout      = 'Bledowski110.lay';                      % specify layout of sensors*
cfg.feedback    = 'yes';                             % show a neighbour plot 
neighbours      = ft_prepare_neighbours(cfg, tmlk_grandavg_medium); % define neighbouring channels

%keyboard();
close all

cfg = [];
cfg.channel     = 'all';
cfg.neighbours  = neighbours; % defined as above
cfg.latency     = [-0.2 0.8]; %Should probably choose a narrower window
cfg.avgovertime = 'no';
cfg.parameter   = 'avg';
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



erp_stat = ft_timelockstatistics(cfg, allsubjects_tmlk_hard{:}, allsubjects_tmlk_easy{:});

save ([experimentdir, '/_AllSubjectsData/erp_stat'], 'erp_stat');

clear allsubjects_tmlk_easy allsubjects_tmlk_hard 


% Plot stat map for first cluster 

%create matrix dumstat containing stats for channels from positive cluster 1.
%Unrelated channels will have  a value of 0.
dumstat = zeros(size(erp_stat.stat)); 
dumstat(find(erp_stat.posclusterslabelmat ==1)) = erp_stat.stat(find(erp_stat.posclusterslabelmat ==1)); 

ERPplot = rmfield(tmlk_grandavg_medium, {'avg'; 'var'; 'dof'});

clear tmlk_grandavg_medium

ERPplot.avg = dumstat;
ERPplot.time = erp_stat.time;
pcfg = struct();
pcfg.parameter = 'avg';
pcfg.xlim = [0.2, 0.70];
%pcfg.zlim = [-1, 1]*3 
pcfg.marker  = 'labels';
pcfg.layout = 'Bledowski110.lay'; 
pcfg.interactive = 'yes';
pcfg.comment = 'xlim';
%  pcfg.highlight = 'on';
%  pos_clusters = erp_stat.posclusterslabelmat(:, find(erp_stat.time > pcfg.xlim(1) & erp_stat.time < pcfg.xlim(2)));
%  pos1 = (pos_clusters == 1)*1;
%  pcfg.highlightchannel = pos1;

figure
ft_topoplotER(pcfg,ERPplot);
title('Cluster t-values between 0.2 s and 0.7 s');
colorbar;

keyboard;


