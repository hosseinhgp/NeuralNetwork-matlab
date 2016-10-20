   Length=6000;
   step_size = 0.1;	%/* integration step */
   interval=1/step_size;
   x=1.2;
   Xi(1) = x;	%	/* initial condition */
   X=x;
   sample_n = uint32(6000*interval);	%/* total no. of samples, excluding the given
   tau = 17;		%/* delay constant */
   time = 0;
   index = 0;
   history_length =uint16(tau/step_size);
   x_history = zeros(1,history_length);
   i=0;time0=1;
   while i <= sample_n
         i=i+1;
         if i<history_length+1
		      x_tau = 0;
          else
              x_tau=Xi(i-history_length);
          end
          x = RK4(x, time, step_size, x_tau);
          Xi(i)=x;
          time=uint32(i/interval-0.5)+1;
          if time==time0+1;
             time0=time;
             X(time)=x;
          end
    end
%     plot(X)
%200-3200
step_ahead=85;
n=4;
step_u=6;
Xe1=[X(200-108:3200)];
d2=length(Xe1);
d1=(n-1)*step_u+1+step_ahead;
Ytra=Xe1(d1:d2)';
Utra=Ytra;
for i=1:n
    i1=i-1;
    d1=i1*step_u+1;
    d2=d1+length(Ytra)-1;
    Utra(:,i)=Xe1(d1:d2);
end
%-----5001-5500
d1=5088-(step_ahead-step_u*(n-1))-100;
d2=5088+500;
Xe2=[X(d1:d2)];
d2=length(Xe2);
d1=(n-1)*step_u+1+step_ahead;
Ytrb=Xe2(d1:d2)';
Utrb=Ytrb;
for i=1:n
    i1=i-1;
    d1=i1*step_u+1;
    d2=d1+length(Ytrb)-1;
    Utrb(:,i)=Xe2(d1:d2);
end
Ytr=Ytra;
Utr=Utra;

Yte=Ytrb;
Ute=Utrb;







