function dy = ONEIZNETWORKQSSAD5(C,klow,khigh,vt,vreset,vpeak,vr,a,d,Tmax,G,I,Er,alpha,beta,tbar,NS,t,y)


s = y(1:NS,1);
h = y(NS+1:2*NS,1); 
w = y(2*NS+1:3*NS,1); 

TS = 1./(alpha.*Tmax+beta);
sinf = (alpha.*Tmax)./(alpha.*Tmax+beta); 

TR = TS; 
TD = 1./beta;
A = sinf.*(tbar + (1./beta-TS).*(1-exp(-tbar./TS))); 

for i = 1:NS 
 vmin1 = 0.5*(vt(i,1)+vr(i,1) + G(i,:)*s/klow(i,1));
 vmin2 = 0.5*(vt(i,1)+vr(i,1) + G(i,:)*s/khigh(i,1));
 H2min = (khigh(i,1)*(vmin2-vt(i,1))*(vmin2-vr(i,1)) - w(i)+I{i,1}(:,1) - G(i,:)*s*vmin2 + (G(i,:))*(s.*Er))/C(i);
 H1min = (klow(i,1)*(vmin1-vt(i,1))*(vmin1-vr(i,1)) - w(i)+I{i,1}(:,1) - G(i,:)*s*vmin1 + (G(i,:))*(s.*Er))/C(i);
 H3 =  (- w(i)+I{i,1}(:,1) - G(i,:)*s*vt(i,1) + (G(i,:))*(s.*Er))/C(i);


 if vmin1 < vt(i,1) 
     H = H1min;
 else 
     if vmin2>vt(i,1) 
         H = H2min; 
     else 
        H = H3; 
     end
 end
 
 
 
 
 
 H1min = (1/klow(i,1))*(I{i,1}(:,1)-w(i,1)+(G(i,:))*(s.*Er)+klow(i,1)*vt(i,1)*vr(i,1)) - (vt(i,1)+vr(i,1)+ G(i,:)*s/klow(i,1))^2/4; 
 H2min = (1/khigh(i,1))*(I{i,1}(:,1)-w(i,1)+(G(i,:))*(s.*Er)+khigh(i,1)*vt(i,1)*vr(i,1)) - (vt(i,1)+vr(i,1)+ G(i,:)*s/khigh(i,1))^2/4; 
 
 
 J1 = (C(i,1)/(klow(i,1)))*(  atan( (vt(i,1) - (vt(i,1)+vr(i,1) + G(i,:)*s/klow(i,1))/2)./sqrt(H1min))- atan( (vreset(i,1) - (vt(i,1)+vr(i,1) + G(i,:)*s/klow(i,1))/2)./sqrt(H1min)))./sqrt(H1min); 
 J2 = (C(i,1)/(khigh(i,1)))*(  atan( (vpeak(i,1) - (vt(i,1)+vr(i,1) + G(i,:)*s/khigh(i,1))/2)./sqrt(H2min))- atan( (vt(i,1) - (vt(i,1)+vr(i,1) + G(i,:)*s/khigh(i,1))/2)./sqrt(H2min)))./sqrt(H2min); 

%vint1 = vreset(i,1):0.1:vt(i,1);
% vint2 = vt(i,1):0.1:vpeak(i,1); 
% 
% dvdt1 =  (klow(i,1).*(vint1-vt(i,1)).*(vint1-vr(i,1)) - w(i) + I(i) - G(i,:)*s*vint1 + (G(i,:))*(s.*Er))/C(i);
% dvdt2 =  (khigh(i,1).*(vint2-vt(i,1)).*(vint2-vr(i,1)) - w(i) + I(i) - G(i,:)*s*vint2 + (G(i,:))*(s.*Er))/C(i);
%  
% 
% 
% J1 = trapz(vint1,1./dvdt1);
% J2 = trapz(vint2,1./dvdt2); 

    R = (H>0)./(J1+J2);
    R = mean(R); 



dy(i,1) = -s(i)/(TR(i)) + h(i); 
dy(NS+i,1) = -h(i) /(TD(i)) + (A(i)/(TR(i)*TD(i)))*R; 
dy(2*NS+i,1) = - w(i)*a(i) +d(i)*R;

end





end