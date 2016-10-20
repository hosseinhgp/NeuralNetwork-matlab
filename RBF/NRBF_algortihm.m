function [RBF]=NRBF_algortihm(UUtest,TTtest,UUtrain,TTtrain,RBF);
N=RBF(1).N;
P=RBF(1).P;
Qtest=RBF(1).Qtest;
Qtrain=RBF(1).Qtrain;
eta=RBF(1).eta;
Neuron=RBF(1).Neuron;
%------------------------------------------------------------
%Normalizing
for i=1:N
    Ub=UUtrain(:,i);
    Mu=max(Ub);
    mu=min(Ub);
    UUn_train(:,i)=(Ub-mu)/(Mu-mu);
    %
    Ub=UUtest(:,i);
    UUn_test(:,i)=(Ub-mu)/(Mu-mu);
end
for i=1:P
    Tb=TTtrain(:,i);
    Mt=max(Tb);
    mt=min(Tb);
    TTn_train(:,i)=(Tb-mt)/(Mt-mt);
    MaxTT(i)=Mt;
    MinTT(i)=mt;
    %
    Tb=TTtest(:,i);
    TTn_test(:,i)=(Tb-mt)/(Mt-mt);
end
%------------------------------------------------------------
epoch_end=RBF(1).epoch_end;
W=RBF(1).W;
CC=RBF(1).C;
LL=RBF(1).L;
for epoch=1:epoch_end
    EE=0;
    IDATA=randperm(Qtrain);
    for idata1=1:Qtrain
        idata=IDATA(idata1);
        U=(UUn_train(idata,:))';
        T=(TTn_train(idata,:))';
        %----Forward
        for i=1:Neuron
            C=CC(:,i);
            L=LL(:,i);
            Ar=-((U-C)./L).^2;
            Yi(i,1)=exp(sum(Ar));
        end
        S=sum(Yi);
        Y=W*Yi/S;
%     end 
        E=T-Y;
        YYtrain(idata,:)=Y';
    %-----Backward
        for j=1:Neuron
            C=CC(:,j);
            L=LL(:,j);
            yj=Yi(j);
            for i=1:P
                grW(i,j)=-2*E(i)*yj/S;
            end
            W1=W(:,j);
            CT=sum(W1.*E)*(S-yj)/S^2;
            grC=-2*CT*yj*(U-C)./L.^2;
            grL=-2*CT*yj*(U-C).^2./L.^3;
            C=C-eta*grC;
            L=L-eta*grL;
    %%%
            CC(:,j)=C;
            LL(:,j)=L; 
        end  
        W=W-eta*grW;
    %
        E1=E.*(MaxTT-MinTT)';
        EE=EE+sum(E1.^2)/P;
    end   %data
    MSE_train(epoch)=(EE/Qtrain); %Index for analysing the performance of system
    RBF(1).W=W;
    RBF(1).C=C;
    RBF(1).L=L;
    for idata=1:Qtest
        U=(UUn_test(idata,:))';
        T=(TTn_test(idata,:))';
    %----Forward
        for i=1:Neuron
            C=CC(:,i);
            L=LL(:,i);
            Ar=-((U-C)./L).^2;
            Yi(i,1)=exp(sum(Ar));
        end  
        S=sum(Yi);
        Y=W*Yi/S;
        YYtest(idata,:)=Y';
        E=T-Y;
        E1=E.*(MaxTT-MinTT)';
        EE=EE+sum(E1.^2)/P;
    end  
    MSE_test(epoch)=(EE/Qtest);
    plot(MSE_train,'g');
    hold on
    plot(MSE_test,'r');
%     dranow
%     subplot(2,1,1): title('RMSE Learning Rate 0.01, Neuron:[10 5], 1 Layer Exe.2');   ylabel('Test(r)-Train(gr)');  xlabel('epoch');
%     drawnow;
end  %epoch
%---------Rescale
% subplot(2,1,2): plot(YYtrain(:,1),'r');
% hold on
% subplot(2,1,2): plot(TTn_train(:,1),'g');
% subplot(2,1,2): Ylabel('Y(r)-Target(gr)');   xlabel('Data');
% drawnow
for i=1:P
    Ytrain=YYtrain(:,i);
    Mt=MaxTT(i);
    mt=MinTT(i);
    Yun=Ytrain*(Mt-mt)+mt;
    YYtrain(:,i)=Yun;
    %
    Ytest=YYtest(:,i);
    Yun1=Ytest*(Mt-mt)+mt;
    YYtest(:,i)=Yun1;
end
RBF(1).Ytrain=YYtrain;
RBF(1).Ytest=YYtest;