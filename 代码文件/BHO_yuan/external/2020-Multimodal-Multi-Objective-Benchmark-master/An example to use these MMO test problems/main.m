%% Add path

addpath(genpath('MM_testfunctions/'));
addpath(genpath('Indicator_calculation/'));
 
clear all
clc

  global fname
  N_function=24;% number of test function
  runtimes=1;  % odd number
 %% Initialize the parameters in MMO test functions

     for i_func= 1:N_function
        switch i_func
            case 1
                fname='MMF1';  % function name
                n_obj=2;       % the dimensions of the decision space
                n_var=2;       % the dimensions of the objective space
                xl=[1 -1];     % the low bounds of the decision variables
                xu=[3 1];      % the up bounds of the decision variables
                repoint=[1.1,1.1]; % reference point used to calculate the Hypervolume, it is set to 1.1*(max value of f_i)
                N_ops=2;
            case 2
                fname='MMF2';
                n_obj=2;
                n_var=2;
                xl=[0 0];
                xu=[1 2];
                repoint=[1.1,1.1];
                N_ops=2;
            case 3
                fname='MMF4';
                n_obj=2;
                n_var=2;
                xl=[-1 0];
                xu=[1 2];
                repoint=[1.1,1.1];
                N_ops=2;
            case 4
                fname='MMF5';
                n_obj=2;
                n_var=2;
                xl=[1 -1];
                xu=[3 3];
                repoint=[1.1,1.1];
                N_ops=2;
     
            case 5
                fname='MMF7';
                n_obj=2;
                n_var=2;
                xl=[1 -1];
                xu=[3 1];
                repoint=[1.1,1.1];
                N_ops=2;
             case 6
                fname='MMF8';
                n_obj=2;
                n_var=2;
                xl=[-pi 0];
                xu=[pi 9];
               repoint=[1.1,1.1];
               N_ops=2;
            case 7
               fname='MMF10';  % function name
                n_obj=2;       % the dimensions of the decision space
                n_var=2;       % the dimensions of the objective space
                xl=[0.1 0.1];     % the low bounds of the decision variables
                xu=[1.1 1.1];      % the up bounds of the decision variables
               repoint=[1.21,13.2]; % reference point used to calculate the Hypervolume
               N_ops=1;
            case 8
                fname='MMF11';  % function name
                n_obj=2;       % the dimensions of the decision space
                n_var=2;       % the dimensions of the objective space
                xl=[0.1 0.1];     % the low bounds of the decision variables
                xu=[1.1 1.1];      % the up bounds of the decision variables
                repoint=[1.21,15.4];
                N_ops=1;
            case 9
                fname='MMF12';  % function name
                n_obj=2;       % the dimensions of the decision space
                n_var=2;       % the dimensions of the objective space
                xl=[0 0];     % the low bounds of the decision variables
                xu=[1 1];      % the up bounds of the decision variables
                repoint=[1.54,1.1];
                N_ops=1;
             case 10
                 %*need to be modified
                fname='MMF13';  % function name
                n_obj=2;       % the dimensions of the decision space
                n_var=3;       % the dimensions of the objective space
                xl=[0.1 0.1 0.1];     % the low bounds of the decision variables
                xu=[1.1 1.1 1.1];      % the up bounds of the decision variables
                repoint=[1.54,15.4];
                N_ops=1;
             case 11
                fname='MMF14';  % function name
                n_obj=3;       % the dimensions of the decision space
                n_var=3;       % the dimensions of the objective space
                xl=[0 0 0];     % the low bounds of the decision variables
                xu=[1 1 1];      % the up bounds of the decision variables
                repoint=[2.2,2.2,2.2];
                N_ops=2;
              case 12
                fname='MMF15';  % function name
                n_obj=3;       % the dimensions of the decision space
                n_var=3;       % the dimensions of the objective space
                xl=[0 0 0];     % the low bounds of the decision variables
                xu=[1 1 1];      % the up bounds of the decision variables
                repoint=[2.5,2.5,2.5];
                N_ops=1;
             
            case 13
                fname='MMF1_e';  % function name
                n_obj=2;       % the dimensions of the decision space
                n_var=2;       % the dimensions of the objective space
                xl=[1 -20];     % the low bounds of the decision variables
                xu=[3 20];      % the up bounds of the decision variables
                repoint=[1.1,1.1];
                N_ops=2;
            case 14
                fname='MMF14_a';  % function name
                n_obj=3;
                n_var=3;
                xl=[0 0 0];
                xu=[1 1 1];
                repoint=[2.2,2.2,2.2];
                N_ops=2;
            case 15
                fname='MMF15_a';  % function name
                n_obj=3;
                n_var=3;
                xl=[0 0 0];
                xu=[1 1 1]; 
                repoint=[2.5,2.5,2.5];
                N_ops=1;
            
            case 16
               fname='MMF10_l';  % function name
                n_obj=2;       % the dimensions of the decision space
                n_var=2;       % the dimensions of the objective space
                xl=[0.1 0.1];     % the low bounds of the decision variables
                xu=[1.1 1.1];      % the up bounds of the decision variables
               repoint=[1.21,13.2]; % reference point used to calculate the Hypervolume
                N_ops=2;
            case 17
                fname='MMF11_l';  % function name
                n_obj=2;       % the dimensions of the decision space
                n_var=2;       % the dimensions of the objective space
                xl=[0.1 0.1];     % the low bounds of the decision variables
                xu=[1.1 1.1];      % the up bounds of the decision variables
                repoint=[1.21,15.4];
                N_ops=2;
            case 18
                fname='MMF12_l';  % function name
                n_obj=2;       % the dimensions of the decision space
                n_var=2;       % the dimensions of the objective space
                xl=[0 0];     % the low bounds of the decision variables
                xu=[1 1];      % the up bounds of the decision variables
                repoint=[1.54,1.1];
                N_ops=2;
             case 19
                 %*need to be modified
                fname='MMF13_l';  % function name
                n_obj=2;       % the dimensions of the decision space
                n_var=3;       % the dimensions of the objective space
                xl=[0.1 0.1 0.1];     % the low bounds of the decision variables
                xu=[1.1 1.1 1.1];      % the up bounds of the decision variables
                repoint=[1.54,15.4];
                N_ops=2;
            case 20
                fname='MMF15_l';  % function name
                n_obj=3;       % the dimensions of the decision space
                n_var=3;       % the dimensions of the objective space
                xl=[0 0 0];     % the low bounds of the decision variables
                xu=[1 1 1];      % the up bounds of the decision variables
                repoint=[2.5,2.5,2.5];
                N_ops=2;
            case 21
                fname='MMF15_a_l';  % function name
                n_obj=3;
                n_var=3;
                xl=[0 0 0];
                xu=[1 1 1]; 
                repoint=[2.5,2.5,2.5];
                N_ops=2;
            case 22
                fname='MMF16_l1';  % function name
                n_obj=3;
                n_var=3;
                xl=[0 0 0];
                xu=[1 1 1]; 
                repoint=[2.5,2.5,2.5];
                N_ops=3;
            case 23
                fname='MMF16_l2';  % function name
                n_obj=3;
                n_var=3;
                xl=[0 0 0];
                xu=[1 1 1]; 
                repoint=[2.5,2.5,2.5];
                N_ops=3;
            case 24
                fname='MMF16_l3';  % function name
                n_obj=3;
                n_var=3;
                xl=[0 0 0];
                xu=[1 1 1]; 
                repoint=[2.5,2.5,2.5];
                N_ops=4;
        end
       %% Load reference PS and PF data
          load  (strcat([fname,'_Reference_PSPF_data']));
       %% Initialize the population size and the maximum evaluations
          popsize=200*N_ops;
          Max_fevs=10000*N_ops;
          Max_Gen=fix(Max_fevs/popsize);

           for j=1:runtimes
               %% Search the PSs using MO_PSO_MM
                   [ps,pf]=MO_PSO_MM(fname,xl,xu,n_obj,popsize,Max_Gen,PS);
                   % Indicators
                     hyp=Hypervolume_calculation(pf,repoint);
                     IGDx=IGD_calculation(ps,PS);
                     IGDf=IGD_calculation(pf,PF);
                     CR=CR_calculation(ps,PS);
                     PSP=CR/IGDx;%
                     Indicator.MO_PSO_MM(j,:)=[1./PSP,1./hyp,IGDx,IGDf];
                     PSdata.MO_PSO_MM{j}=ps;
                     PFdata.MO_PSO_MM{j}=pf;%
                     clear ps pf hyp IGDx IGDf CR PSP
               %% Search the PSs using MO_Ring_PSO_SCD
                   [ps,pf]=MO_Ring_PSO_SCD(fname,xl,xu,n_obj,popsize,Max_Gen);
                   % Indicators
                     hyp=Hypervolume_calculation(pf,repoint);
                     IGDx=IGD_calculation(ps,PS);
                     IGDf=IGD_calculation(pf,PF);
                     CR=CR_calculation(ps,PS);
                     PSP=CR/IGDx;%
                     Indicator.MO_Ring_PSO_SCD(j,:)=[1./PSP,1./hyp,IGDx,IGDf];
                     PSdata.MO_Ring_PSO_SCD{j}=ps;
                     PFdata.MO_Ring_PSO_SCD{j}=pf;%
                     clear ps pf hyp IGDx IGDf CR PSP
                %% Search the PSs using DN-NSGAII
                   [ps,pf]=DN_NSGAII(fname,xl,xu,n_obj,popsize,Max_Gen);
                   % Indicators
                     hyp=Hypervolume_calculation(pf,repoint);
                     IGDx=IGD_calculation(ps,PS);
                     IGDf=IGD_calculation(pf,PF);
                     CR=CR_calculation(ps,PS);
                     PSP=CR/IGDx;
                     Indicator.DN_NSGAII(j,:)=[1./PSP,1./hyp,IGDx,IGDf];
                     PSdata.DN_NSGAII{j}=ps;
                     PFdata.DN_NSGAII{j}=pf;
                     clear ps pf hyp IGDx IGDf CR PSP
                 %% Search the PSs using Omni_Opt 
                     [ps,pf]=Omni_Opt(fname,xl,xu,n_obj,popsize,Max_Gen);
                    % Indicators
                     hyp=Hypervolume_calculation(pf,repoint);
                     IGDx=IGD_calculation(ps,PS);
                     IGDf=IGD_calculation(pf,PF);
                     CR=CR_calculation(ps,PS);
                     PSP=CR/IGDx;
                     Indicator.Omni_Opt(j,:)=[1./PSP,1./hyp,IGDx,IGDf];
                     PSdata.Omni_Opt{j}=ps;
                     PFdata.Omni_Opt{j}=pf;
                     clear ps pf hyp IGDx IGDf CR PSP
                 %% Search the PSs using NSGAII
                     [ps,pf]=NSGAII(fname,xl,xu,n_obj,popsize,Max_Gen);
                   % Indicators
                     hyp=Hypervolume_calculation(pf,repoint);
                     IGDx=IGD_calculation(ps,PS);
                     IGDf=IGD_calculation(pf,PF);
                     CR=CR_calculation(ps,PS);
                     PSP=CR/IGDx;% 
                     Indicator.NSGAII(j,:)=[1./PSP,1./hyp,IGDx,IGDf];
                     PSdata.NSGAII{j}=ps;
                     PFdata.NSGAII{j}=pf;
                     clear ps pf hyp IGDx IGDf CR PSP
                  %% Search the PSs using SPEA2
                    [ps,pf]=SPEA2(fname,xl,xu,popsize,Max_Gen);
                   % Indicators
                     hyp=Hypervolume_calculation(pf,repoint);
                     IGDx=IGD_calculation(ps,PS);
                     IGDf=IGD_calculation(pf,PF);
                     CR=CR_calculation(ps,PS);
                     PSP=CR/IGDx;%
                     Indicator.SPEA2(j,:)=[1./PSP,1./hyp,IGDx,IGDf];
                     PSdata.SPEA2{j}=ps;
                     PFdata.SPEA2{j}=pf;%
                     clear ps pf hyp IGDx IGDf CR PSP
                    fprintf('Running test function: %s \n %d times \n', fname,j);
          end
     
%       %% Choose one PS with the median indicators
          % Choose one PS for MO_Ring_PSO_SCD
%            choosen_In=Indicator.MO_Ring_PSO_SCD(:,1);% Choose PS according to PSP (the fifth indicator) value
%            median_index=find(choosen_In==median(choosen_In));
%            choose_ps.MO_Ring_PSO_SCD= PSdata.MO_Ring_PSO_SCD{median_index};
%            choose_pf.MO_Ring_PSO_SCD= PFdata.MO_Ring_PSO_SCD{median_index};
%            clear choosen_In median_index
%           % Choose one PS for DN_NSGAII
%            choosen_In=Indicator.DN_NSGAII(:,1);
%            median_index=find(choosen_In==median(choosen_In));
%            choose_ps.DN_NSGAII= PSdata.DN_NSGAII{median_index};
%            choose_pf.DN_NSGAII= PFdata.DN_NSGAII{median_index};
%            clear choosen_In median_index
       %% Calculate mean and std of the indicators
           % MO_PSO_MM--------------------------------------------------------------------------------------
            Indicator.MO_PSO_MM(runtimes+1,:)=min(Indicator.MO_PSO_MM); %the minimum is the best
            Indicator.MO_PSO_MM(runtimes+2,:)=max(Indicator.MO_PSO_MM); %the maximum is the worst
            Indicator.MO_PSO_MM(runtimes+3,:)=mean(Indicator.MO_PSO_MM);
            Indicator.MO_PSO_MM(runtimes+4,:)=median(Indicator.MO_PSO_MM);
            Indicator.MO_PSO_MM(runtimes+5,:)=std(Indicator.MO_PSO_MM);
          % Generate Table data in the report 
            MO_PSO_MM_results.rPSP(i_func,:)=(Indicator.MO_PSO_MM(:,1))';%Talbe II data
            MO_PSO_MM_results.rHV(i_func,:)=(Indicator.MO_PSO_MM(:,2))';%Talbe III data
            MO_PSO_MM_results.IGDX(i_func,:)=(Indicator.MO_PSO_MM(:,3))';%Talbe IV data
            MO_PSO_MM_results.IGDF(i_func,:)=(Indicator.MO_PSO_MM(:,4))';%Talbe V data
         % MO_Ring_PSO_SCD--------------------------------------------------------------------------------
            Indicator.MO_Ring_PSO_SCD(runtimes+1,:)=min(Indicator.MO_Ring_PSO_SCD); %the minimum is the best
            Indicator.MO_Ring_PSO_SCD(runtimes+2,:)=max(Indicator.MO_Ring_PSO_SCD); %the maximum is the worst
            Indicator.MO_Ring_PSO_SCD(runtimes+3,:)=mean(Indicator.MO_Ring_PSO_SCD);
            Indicator.MO_Ring_PSO_SCD(runtimes+4,:)=median(Indicator.MO_Ring_PSO_SCD);
            Indicator.MO_Ring_PSO_SCD(runtimes+5,:)=std(Indicator.MO_Ring_PSO_SCD);
         % Generate Table data in the report
            MO_Ring_PSO_SCD_results.rPSP(i_func,:)=(Indicator.MO_Ring_PSO_SCD(:,1))';%Talbe II data
            MO_Ring_PSO_SCD_results.rHV(i_func,:)=(Indicator.MO_Ring_PSO_SCD(:,2))';%Talbe III data
            MO_Ring_PSO_SCD_results.IGDX(i_func,:)=(Indicator.MO_Ring_PSO_SCD(:,3))';%Talbe IV data
            MO_Ring_PSO_SCD_results.IGDF(i_func,:)=(Indicator.MO_Ring_PSO_SCD(:,4))';%Talbe V data
         % DN_NSGAII--------------------------------------------------------------------------------------
            Indicator.DN_NSGAII(runtimes+1,:)=min(Indicator.DN_NSGAII); %the minimum is the best
            Indicator.DN_NSGAII(runtimes+2,:)=max(Indicator.DN_NSGAII); %the maximum is the worst
            Indicator.DN_NSGAII(runtimes+3,:)=mean(Indicator.DN_NSGAII);
            Indicator.DN_NSGAII(runtimes+4,:)=median(Indicator.DN_NSGAII);
            Indicator.DN_NSGAII(runtimes+5,:)=std(Indicator.DN_NSGAII);
          % Generate Table data in the report 
            DN_NSGAII_results.rPSP(i_func,:)=(Indicator.DN_NSGAII(:,1))';%Talbe II data
            DN_NSGAII_results.rHV(i_func,:)=(Indicator.DN_NSGAII(:,2))';%Talbe III data
            DN_NSGAII_results.IGDX(i_func,:)=(Indicator.DN_NSGAII(:,3))';%Talbe IV data
            DN_NSGAII_results.IGDF(i_func,:)=(Indicator.DN_NSGAII(:,4))';%Talbe V data
          % Omni-opt--------------------------------------------------------------------------------------
            Indicator.Omni_Opt(runtimes+1,:)=min(Indicator.Omni_Opt); %the minimum is the best
            Indicator.Omni_Opt(runtimes+2,:)=max(Indicator.Omni_Opt); %the maximum is the worst
            Indicator.Omni_Opt(runtimes+3,:)=mean(Indicator.Omni_Opt);
            Indicator.Omni_Opt(runtimes+4,:)=median(Indicator.Omni_Opt);
            Indicator.Omni_Opt(runtimes+5,:)=std(Indicator.Omni_Opt);
          % Generate Table data in the report 
            Omni_Opt_results.rPSP(i_func,:)=(Indicator.Omni_Opt(:,1))';%Talbe II data
            Omni_Opt_results.rHV(i_func,:)=(Indicator.Omni_Opt(:,2))';%Talbe III data
            Omni_Opt_results.IGDX(i_func,:)=(Indicator.Omni_Opt(:,3))';%Talbe IV data
            Omni_Opt_results.IGDF(i_func,:)=(Indicator.Omni_Opt(:,4))';%Talbe V data
          % NSGAII--------------------------------------------------------------------------------------
            Indicator.NSGAII(runtimes+1,:)=min(Indicator.NSGAII); %the minimum is the best
            Indicator.NSGAII(runtimes+2,:)=max(Indicator.NSGAII); %the maximum is the worst
            Indicator.NSGAII(runtimes+3,:)=mean(Indicator.NSGAII);
            Indicator.NSGAII(runtimes+4,:)=median(Indicator.NSGAII);
            Indicator.NSGAII(runtimes+5,:)=std(Indicator.NSGAII);
          % Generate Table data in the report 
            NSGAII_results.rPSP(i_func,:)=(Indicator.NSGAII(:,1))';%Talbe II data
            NSGAII_results.rHV(i_func,:)=(Indicator.NSGAII(:,2))';%Talbe III data
            NSGAII_results.IGDX(i_func,:)=(Indicator.NSGAII(:,3))';%Talbe IV data
            NSGAII_results.IGDF(i_func,:)=(Indicator.NSGAII(:,4))';%Talbe V data
          % SPEA2--------------------------------------------------------------------------------------
            Indicator.SPEA2(runtimes+1,:)=min(Indicator.SPEA2); %the minimum is the best
            Indicator.SPEA2(runtimes+2,:)=max(Indicator.SPEA2); %the maximum is the worst
            Indicator.SPEA2(runtimes+3,:)=mean(Indicator.SPEA2);
            Indicator.SPEA2(runtimes+4,:)=median(Indicator.SPEA2);
            Indicator.SPEA2(runtimes+5,:)=std(Indicator.SPEA2);
          % Generate Table data in the report 
            SPEA2_results.rPSP(i_func,:)=(Indicator.SPEA2(:,1))';%Talbe II data
            SPEA2_results.rHV(i_func,:)=(Indicator.SPEA2(:,2))';%Talbe III data
            SPEA2_results.IGDX(i_func,:)=(Indicator.SPEA2(:,3))';%Talbe IV data
            SPEA2_results.IGDF(i_func,:)=(Indicator.SPEA2(:,4))';%Talbe V data
      
       %% save resultdata
%            save(strcat([fname,'PSPF_indicator_data']),'PSdata','PFdata','Indicator');
           clear PSdata PFdata Indicator
%            save(strcat([fname,'ChoosenPSPFdata']),'choose_ps','choose_pf');
       %% Plot figure
%            if size(choose_ps.MO_Ring_PSO_SCD,2)==2
%                figure
%                plot(choose_ps.MO_Ring_PSO_SCD(:,1),choose_ps.MO_Ring_PSO_SCD(:,2),'o');
%                hold on;
%                plot(PS(:,1),PS(:,2),'r+');
%                legend 'Obtained PS' 'True PS'
%          
%            elseif size(choose_ps.MO_Ring_PSO_SCD,2)==3
%                figure
%                plot3(choose_ps.MO_Ring_PSO_SCD(:,1),choose_ps.MO_Ring_PSO_SCD(:,2),choose_ps.MO_Ring_PSO_SCD(:,3),'o');
%                hold on;
%                plot3(PS(:,1),PS(:,2),PS(:,3),'r+');
%                legend 'Obtained PS' 'True PS'
%             
%            end
%            clear choose_ps
     end

%     save MO_PSO_MM_results MO_PSO_MM_results
%     save MO_Ring_PSO_SCD_results MO_Ring_PSO_SCD_results
%     save DN_NSGAII_results DN_NSGAII_results
%     save Omni_Opt_results Omni_Opt_results
%     save NSGAII_results NSGAII_results
%     save SPEA2_results SPEA2_results
    
