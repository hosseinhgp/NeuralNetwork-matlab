% Q=192;
% u1=(rand(Q,1)-0.5)*20;
% u2=(rand(Q,1)-0.5)*20;
load ('Sinc');
Ut=[u1,u2];
n=2;
for id=1:Q
    ut=Ut(id,:);
    if (ut(1)==0)
        f1=1;
    else
        f1=sin(ut(1))/ut(1);
    end
    if (ut(2)==0)
        f2=1;
    else
        f2=sin(ut(2))/ut(2);
    end
    Yt(id,1)=f1*f2;
end
Qtr=121;
Qte=71;
%---------------------
Ytr=Yt(1:Qtr,1);
Utr=Ut(1:Qtr,:);
%---------------------
Yte=Yt(Qtr+1:end,1);
Ute=Ut(Qtr+1:end,:);
%----------------------
    

