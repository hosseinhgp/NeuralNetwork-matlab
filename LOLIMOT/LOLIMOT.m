function [Yhtr,Yhte]=LOLIMOT(Utr,Ute,Ytr,Yte,neron,alfa)
AP_flag=0;
[Qtr,n]=size(Utr);
[Qte,n]=size(Ute);
Utr(:,n+1)=ones(Qtr,1);
Ute(:,n+1)=ones(Qte,1);
for i=1:n
    maxD=max(Utr(:,i));
    minD=min(Utr(:,i));
    D1(i)=mean([maxD,minD]);
    L1(i)=maxD-minD;
end
Pr(1).D=D1';
Pr(1).L=L1';
for i=1:Qtr;
    Xi=Utr(i,1:n);
    z=alfa*(Xi-D1)./L1;
    Miu(i)=exp(-z*z');
end
Pr(1).Miu=Miu;
SMc=Miu;
tet=inv(Utr'*Utr)*Utr'*Ytr;
Pr(1).tet=tet;
Yhtr=Utr*tet;
Yhte=Ute*tet;
Ymodel_un=Yhtr.*Miu';
etr=(Yhtr-Ytr);
ete=(Yhte-Yte);
J=etr'*etr/Qtr;
Pr(1).J=J;
JJ=J;
MSE_tr=J;
MSE_te=((ete'*ete)/Qte);
if (neron>1)
    %-------
    stop=0;
    itree=1;
    while stop==0
        %----Worst selection
        [Jmax,iw]=max(JJ);
        %-------------------
        Dw=Pr(iw).D;
        Lw=Pr(iw).L;
        tetw=Pr(iw).tet;
        Miuw=Pr(iw).Miu;
        %-----------------
        Ymodel_un=Ymodel_un-Utr*tetw.*Miuw';
        %-----------------
        SumMi=SMc-Miuw;
        %----------------
        Jmin=1000000;
        for idiv=1:n
            DR=Dw;
            DR(idiv)=Dw(idiv)+Lw(idiv)/4;
            DL=Dw;
            DL(idiv)=Dw(idiv)-Lw(idiv)/4;
            LR=Lw;
            LR(idiv)=Lw(idiv)/2;
            LL=Lw;
            LL(idiv)=Lw(idiv)/2;
            for i=1:Qtr;
                Xi=Utr(i,1:n);
                zR=alfa*(Xi'-DR)./LR;
                zL=alfa*(Xi'-DL)./LL;
                MiuR(i)=exp(-zR'*zR);
                MiuL(i)=exp(-zL'*zL);
            end
            %-----
            SM=SumMi+MiuR+MiuL;
            %--------------
            ZR=MiuR./SM;
            ZL=MiuL./SM;
            ZRs=(ZR.^.5)';
            ZLs=(ZL.^.5)';
            UtrR=Utr;
            UtrL=Utr;
            for k=1:n+1
                UtrR(:,k)=Utr(:,k).*ZRs;
                UtrL(:,k)=Utr(:,k).*ZLs;
            end
            YtrR=Ytr.*(ZRs);
            YtrL=Ytr.*(ZLs);
            tetR=inv(UtrR'*UtrR)*UtrR'*YtrR;
            tetL=inv(UtrL'*UtrL)*UtrL'*YtrL;
            %---------------------
            Ymodel=(Ymodel_un+Utr*tetR.*MiuR'+Utr*tetL.*MiuL')./SM';
            %---------------------
            e=(Ymodel-Ytr);
            Jdiv=e'*e/Qtr;
            if Jdiv<Jmin
                Jmin=Jdiv;
                idivc=idiv;
                Pr(iw).Miu=MiuR;
                Pr(iw).tet=tetR;
                Pr(iw).D=DR;
                Pr(iw).L=LR;
                %%%
                Pr(itree+1).Miu=MiuL;
                Pr(itree+1).tet=tetL;
                Pr(itree+1).D=DL;
                Pr(itree+1).L=LL;
                SMc=SM;
                Ymodelc=Ymodel;
            end
        end
        itree=itree+1;
        JJ=0;
        em=Ytr-Ymodelc;
        Ymodel_un=Ymodelc.*SMc';
        for j=1:itree
            Zj=(Pr(j).Miu)./SMc;
            ej=em.*(Zj'.^.5);
            Jj=ej'*ej/Qtr;
            Pr(j).J=Jj;
            JJ(j)=Jj;
        end
        if itree==neron
            stop=1;
        end
        %------MSE for test and train data
        MSE_tr(itree)=((em'*em)/Qtr);
        %%%
        Y=0;
        for i=1:Qte
            Xi=Ute(i,1:n);
            yi=0;Sd=0;
            for j=1:itree
                tetj=Pr(j).tet;
                Dj=Pr(j).D;
                Lj=Pr(j).L;
                zj=alfa*(Xi'-Dj)./Lj;
                fj=exp(-zj'*zj);
                yi=yi+fj*([Xi,1]*tetj);
                Sd=Sd+fj;
            end
            yi=yi/Sd;
            Y(i)=yi;
        end
        Ete=Y'-Yte;
        MSE_te(itree)=((Ete'*Ete)/Qte);
        
        plot(MSE_tr,'b')
        hold on
        plot(MSE_te,'r')
        drawnow
        Yhte=Y';
        Yhtr=Ymodelc;
    end
end
% -----------------------------------
