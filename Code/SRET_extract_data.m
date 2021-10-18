
clear all

%% convert .txt files to .csv
 !ren *.txt *.csv 
%%


load('correct_responses_case.mat') %variable containing correct responses for case judgment trials
    
Base_dir='path to eprime files\CSV\'; %folder containing the CSV files
cd(Base_dir)
dir_contents=dir;
Files_list={dir_contents(3:end).name}; %Grab all CSV files

%Indices for each trial type (based on regressors)
NegCase=[1:5 13:17 37:41 49:53 67:71];
PosCase=[31:35 55:59 79:83 97:101 109:113];
NegSelf=[7:11 25:29 73:77 85:89 115:119];
PosSelf=[19:23 43:47 61:65 91:95 103:107];
Case=[1:5 13:17 31:35 37:41 49:53 55:59 67:71 79:83 97:101 109:113];

%Extract ratings for each condition/run
for n=1:length(Files_list)
    current_file=Files_list{n}; %grab file for current subject
    [numData,textData,rawData] = xlsread(current_file); %import data
    Responses=cell2mat(rawData(9:end,34)); %extract column containing response data
    RT=cell2mat(rawData(9:end,35)); %extract column conraining RT values
    
    Responses_valid=Responses;
    RT_valid=RT;
    %Only include responses when RT > 250 ms (so meaningless/accidental responses are excluded)
    for i=1:length(RT)
        if RT(i) < 250
            Responses_valid(i)=NaN;
            RT_valid(i)=NaN;
        end
    end
    
    %% 
    %for some participants they were told to use responses 4 and 5 for no/yes whereas others were told to use 1 and 2 for no/yes.
    % Answers of 5 and 1 = Yes / Upper case
    if any(Responses_valid(:) == 5)  %check to see if they made a 5 response anywhere      
        PosSelf_endorse=sum(numel(find(Responses_valid(PosSelf)==5))/25)*100; %Percentage of pos words endorsed
        PosSelf_RT=nanmedian(RT_valid(PosSelf)); %median response time for pos trials
        NegSelf_endorse=sum(numel(find(Responses_valid(NegSelf)==5))/25)*100; %Percentage of neg words endorsed
        NegSelf_RT=nanmedian(RT_valid(NegSelf)); %median response time for neg trials
        
    else % cases where 1 and 2 were used as response options
        PosSelf_endorse=sum(numel(find(Responses_valid(PosSelf)==1))/25)*100; %Percentage of pos words endorsed
        PosSelf_RT=nanmedian(RT_valid(PosSelf)); %median response time for pos trials
        NegSelf_endorse=sum(numel(find(Responses_valid(NegSelf)==1))/25)*100; %Percentage of neg words endorsed
        NegSelf_RT=nanmedian(RT_valid(NegSelf)); %median response time for neg trials
    end
        
%% compute accuracy for case condition  

%the data file correct_responses_case has two columns. Column 1 has correct
%answers where 4 and 5 are the response options. Column 2 has correct
%answers where 1 and 2 are the response options. 

    Responses_Case=Responses_valid(Case);
        for j=1:50
            if any(Responses_valid(:) == 5)
                if correct_responses_case(j,1)==Responses_Case(j) %check if correct response and participant's response match
                    Acc(j)=1;
                else
                    Acc(j)=0;
                end
            else
                  if correct_responses_case(j,2)==Responses_Case(j)
                    Acc(j)=1;
                else
                    Acc(j)=0;
                  end
            end
        end
                
        
    %% store data
    SRET.responses.PosSelf(n,1)=PosSelf_endorse;
    SRET.RT.PosSelf(n,1)=PosSelf_RT;
    SRET.responses.NegSelf(n,1)=NegSelf_endorse;
    SRET.RT.NegSelf(n,1)=NegSelf_RT;
    SRET.Accuracy(n,1)=mean(Acc); %proportion correct
    
    SRET.RawData.Responses{n}=Responses_valid;
    SRET.RawData.RT{n}=RT_valid;
    
end
         
    %% NOTE: we decided to compute data for endorsed items and RT on only participants that scored over 70% on case judgment trials (and were therefore paying attention)   

    
  
        
        
        
        