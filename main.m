clear all
clc
%% select case and method
tic
Case1=2;
Model=2;
%% data load or creation
if (Case1==1)
    Sinc_Function;
end
if (Case1==2)
    load('MG_gen');
    Ytr=Ytra;
    Utr=Utra;
    Yte=Ytrb;
    Ute=Utrb;
end
%% ---------- MLP
if (Model==1)
    path(path,'.\MLP')
    Neuron=100;
    eta=0.001;
    Epochs=200;
    [Yhte,Yhtr]=PRMLP(Ytr,Utr,Yte,Ute,Neuron,eta,Epochs);
    toc_MLP=toc
end
%% ---------- ANFIS
if (Model==2)
    Ztr=[Utr,Ytr];
    Zte=[Ute,Yte];
    N_epoch=30;
    dis=0.3;   %0.05; % 71
    fis = genfis2(Ztr(:,1:end-1),Ztr(:,end),dis);
    fis2 = anfis(Ztr,fis,N_epoch);
    Yhtr=evalfis(Ztr(:,1:end-1),fis2);
    Yhte=evalfis(Zte(:,1:end-1),fis2);
    %-------------------------------
    MSE_tr=mean((Yhtr-Ytr).^2)
    MSE_te=mean((Yhte-Yte).^2)
    toc_ANFIS=toc
    
end
%% ---------- LOLIMOT
if (Model==3)
    
    path(path,'.\LOLIMOT');
    alfa=3;
    neron=20;
    [Yhtr,Yhte]=LOLIMOT(Utr,Ute,Ytr,Yte,neron,alfa);
    %-------------------------------
    toc_LOLIMOT=toc
    %------------------------------
    Etr=(Ytr-Yhtr);
    SSE_tr=mean(Etr.^2);
    Ete=(Yte-Yhte);
    SSE_te=mean(Ete.^2);
end
%% ---------- RBF
if (Model==4)
    path(path,'.\RBF')
    eta=0.01;
    neron=3;
    epoch_end=200;
    [Yhte,Yhtr]=PRBF(Ytr,Utr,Yte,Ute,neron,eta,epoch_end);
    %-------------------------------
    toc_NRBF=toc
end
toc













