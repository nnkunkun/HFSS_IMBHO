% CEC2017

clc;clear;close all

func_num = 1;
D=30;
Xmin=-100;
Xmax=100;
pop_size=30;
iter_max=500;
fhd=str2func('cec17_func');
disp(['F',num2str(func_num),' Dim: ',num2str(D)])


disp('BHO is now tackling your problem')
[BEF_BHO,BEP_BHO,BestCost_BHO]=BHO(pop_size,iter_max,Xmin,Xmax,D,fhd,func_num);


semilogy(BestCost_BHO, '-','Color',[1 0 0],'LineWidth',2)  
CurveTitle=['CEC2017-F',num2str(func_num),' (Dim=',num2str(D),')'];
title(CurveTitle)
xlabel('Iteration#');
ylabel('Best Fitness Value');
legend('BHO')
axis tight
box on
set(gca,'FontSize',12,'Fontname', 'Times New Roman');

display(['The best optimal values of the objective funciton found by BHO is : ', num2str(BEF_BHO)]);
