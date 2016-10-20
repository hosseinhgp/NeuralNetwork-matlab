function [MLP]=MLP_algortihm(UUtest,TTtest,UUtrain,TTtrain,MLP);
N=MLP(1).N;
P=MLP(1).P;
Qtest=MLP(1).Qtest;
Qtrain=MLP(1).Qtrain;
eta=MLP(1).eta;
Layer=MLP(1).Layer;
%------------------------------------------------------------
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
%------------------------------------------------------------
epoch_end=MLP(1).epoch_end;
for epoch=1:epoch_end
    EE=0;
    IDATA=randperm(Qtrain);
    for idata1=1:Qtrain
        idata=IDATA(idata1);
        U=(UUn_train(idata,:))';
        T=(TTn_train(idata,:))';
        %----Forward
        F=U;
        for L=1:Layer
            W=MLP(L).W;
            B=MLP(L).B;
            Ar=W*F+B;
            F=FUNC(Ar,MLP,L);
            MLP(L).F=F;
            MLP(L).ARF=Ar;
        end
        V=MLP(1).V;
        D=MLP(1).D;
        Arg=V*F+D;
        G=GUNC(Arg,MLP);
        Y=G;
        E=T-Y;
        YYtrain(idata,:)=Y';
        %-----Backward
        Gp=GUNCP(G,MLP);
        grD=-2*E.*Gp;
        D1=D-eta*grD;%Update
        grV=grD*F';
        V1=V-eta*grV;%Update
        MLP(1).V=V1;
        MLP(1).D=D1;
        W=V;
        grB=grD;
        %%%
%         com1=-2*e;%.*(1-y.^2);
%         com0=(W2'*com1).*(1-f1.^2);
%         gW2=com1*f1';
%         gB2=com1;
%         gW1=com0*u';
%         gB1=com0;
        %%%
        for L1=1:Layer
            L=Layer-L1+1;
%             F=MLP(L).F;
            Fp=FUNP(F,MLP,L);
           grB=(W'*grB).*Fp;
           if L>1
               F=MLP(L-1).F;
           else  
               F=U;
           end  
           grW=grB*F';
           B=MLP(L).B;
           W=MLP(L).W;
           B1=B-eta*grB;
           W1=W-eta*grW;
           MLP(L).B=B1;
           MLP(L).W=W1;
        end
       MMx=(MaxTT-MinTT)';
       E1=E.*MMx;
       EE=EE+(sum(E1.^2))/P;
   end %data
   MSE_train(epoch)=(EE/Qtrain); %Index for analysing the performance of system
   for idata=1:Qtest
        U=(UUn_test(idata,:))';
        T=(TTn_test(idata,:))';
        %----Forward
        F=U;
        for L=1:Layer
            W=MLP(L).W;
            B=MLP(L).B;
            Ar=W*F+B;
            F=FUNC(Ar,MLP,L);
        end
        Arg=V*F+D;
        G=GUNC(Arg,MLP);
        Y=G;
        YYtest(idata,:)=Y';
        E=T-Y;
        MMx=(MaxTT-MinTT)';
        E1=E.*MMx;
%         EE1(i)=E1;
        EE=EE+sum(E1.^2)/P;
    end
    
%     RMSE_test(epoch)=(EE/Qtest)^.5
%     subplot(2,1,1):plot(RMSE_train,'g');
%     hold on
%     subplot(2,1,1): plot(RMSE_test,'r');
%     drawnow;
 
    MSE_test(epoch)=(EE/Qtest);
    plot(MSE_train,'g');
    hold on
    plot(MSE_test,'r');
    drawnow;
        
end %epoch
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
% subplot(2,1,2): plot(YYtest(:,1),'r');
% hold on
% subplot(2,1,2): plot(TTn_test(:,1),'g');
% subplot(2,1,2): Ylabel('Y(r)-Target(gr)');   xlabel('Data');
% drawnow
MLP(1).Ytrain=YYtrain;
MLP(1).Ytest=YYtest;
% MLP(1).EE1=EE1;