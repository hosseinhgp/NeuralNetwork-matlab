function [Yhte,Yhtr]=PRMLP(Ytr1,Utr1,Yte1,Ute1,Neuron,eta,Epochs)
% %-------------
MLP(1).epoch_end=Epochs;
Layer=1;
MLP(1).Layer=Layer;
eps=0.1;
MLP(1).eta=eta;
Qtrain=length(Ytr1);
Qtest=length(Yte1);
N=length(Utr1(1,:));
P=length(Ytr1(1,:));
MLP(1).N=N;
MLP(1).P=P;
MLP(1).Qtest=Qtest;
MLP(1).Qtrain=Qtrain;
%------------------------------------------
for i=1:Layer
    if i>1
        ni_1=Neuron(i-1);
    else
        ni_1=N;
    end
    ner=Neuron(i);
    MLP(i).Neuron=ner;
    MLP(i).W=randn(ner,ni_1)*eps^(1/i);
    MLP(i).B=randn(ner,1)*eps^(1/i);
end
MLP(1).V=randn(P,ner)*eps^(1/i);
MLP(1).D=randn(P,1)*eps^(1/i);
[MLP1]=MLP_algortihm(Ute1,Yte1,Utr1,Ytr1,MLP);
Yhte=MLP1(1).Ytest;
Yhtr=MLP1(1).Ytrain;
