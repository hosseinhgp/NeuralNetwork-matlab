function [Yhte,Yhtr]=PRBF(Ytr,Utr,Yte,Ute,M,eta,epoch_end)
Utr1=Utr;
Ute1=Ute;
Ytr1=Ytr;
Yte1=Yte;
%-----------------------------
[Qtr,n]=size(Utr);
[Qte,n]=size(Ute);
RBF(1).epoch_end=epoch_end;
RBF(1).Neuron=M;
RBF(1).eta=eta;
[Qtest,P]=size(Yte1);
[Qtrain,N]=size(Utr1);
RBF(1).N=N;
RBF(1).P=P;
RBF(1).Qtest=Qtest;
RBF(1).Qtrain=Qtrain;
Output_Dimensuion=P
Input_Diemension=N
Neuron_Number=M
%---
RBF(1).W=randn(P,M)*0.1;
RBF(1).C=rand(N,M);
RBF(1).L=0.9*randn(N,M)+0.1;
[RBF1]=NRBF_algortihm(Ute1,Yte1,Utr1,Ytr1,RBF);

Yhtr=RBF1(1).Ytrain;
Yhte=RBF1(1).Ytest;

RMSE_te=(mean((Yte1-Yhte).^2))^.5;
RMSE_tr=(mean((Ytr1-Yhtr).^2))^.5;

NDEI_tr=RMSE_tr/(var(Ytr1))^.5;
NDEI_te=RMSE_te/(var(Yte1))^.5;

toc
