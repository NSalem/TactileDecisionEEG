%For each subject, combine data from different sessions and save it to a
%single file.


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
    display(['SUBJECT ',num2str(isubject)]);
    if ~exist([experimentdir,directories{isubject},filesep,'matfiles'],'dir')

        %display error message?

    end;

    subjectdata = [];
    for isess = 1:length(sessions{isubject})
        display(['*****SESSION ',num2str(isess),' ******']);
        datafile = [experimentdir,directories{isubject},filesep,'matfiles',filesep,'dataclean_sess',num2str(sessions{isubject}(isess))];
        load (datafile, 'data');
        subjectdata = [subjectdata, data];      
    end

        cfg = [];
        merged_data = ft_appenddata(cfg, subjectdata(1), subjectdata(2)); % merge sessions  
        save([experimentdir,directories{isubject},filesep,'matfiles',filesep,'dataclean_merged'], 'merged_data');
end