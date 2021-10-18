%Compute correlation between motion parameters and framewise displacement

root_dir='/path to root directory/';
base_dir = strcat(root_dir, 'Data/');
ROI_analysis_dir=strcat(root_dir,'ROI_Analysis/');
cd(base_dir)
dir_contents=dir; %list directory contents
Sub_list = {dir_contents(3:end).name};

for n = 1:length(Sub_list)
    for k=1:3
        Func_dir=strcat(base_dir, Sub_list{n}, '/ses-pre/', 'Run', int2str(k),'/');
        cd(Func_dir)
        load('Framewise_Displacement_timecourse.mat');
        motion_file=spm_select('list',pwd,'rp_sb*');
        motion_regressors=load(motion_file);
        motion_regressors_abs=abs(motion_regressors);
        
        matrix=corrcoef([fd motion_regressors_abs]);
        Z_r=0.5.*log((1+matrix)./(1-matrix));
        mean_Z_r(k)=mean(Z_r(2:7,1)); %mean r value between FD and 6 motion parameters
    end
    
    All_mean_corr(n)=mean(mean_Z_r);
end

