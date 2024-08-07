function APP = FIM_ObserbSubAOmegaRungeKutta(obj,x,y,theta,v,omega,a,t,d1,alpha1,phi1)
%FIM_OBSERBSUBAOMEGARUNGEKUTTA
%    APP = FIM_OBSERBSUBAOMEGARUNGEKUTTA(X,Y,THETA,V,OMEGA,A,T,D1,ALPHA1,PHI1)

%    This function was generated by the Symbolic Math Toolbox version 8.7.
%    13-Dec-2021 19:35:13

t2 = cos(alpha1);
t3 = sin(alpha1);
t4 = cos(theta);
t5 = sin(theta);
t6 = a+v;
t7 = omega.*t;
t8 = omega+theta;
t13 = -alpha1;
t14 = -d1;
t15 = a./2.0;
t16 = omega./2.0;
t9 = cos(t8);
t10 = t4.*v;
t11 = sin(t8);
t12 = t5.*v;
t17 = t15+v;
t18 = t16+theta;
t23 = phi1+t7+t13+theta;
t19 = cos(t18);
t20 = sin(t18);
t21 = t6.*t9;
t22 = t6.*t11;
t26 = cos(t23);
t27 = sin(t23);
t24 = t19.*4.0;
t25 = t20.*4.0;
t28 = 1.0./t26;
t30 = t17.*t20.*2.0;
t34 = t17.*t19.*2.0;
t29 = t28.^2;
t31 = t17.*t25;
t32 = t4+t9+t24;
t33 = t5+t11+t25;
t35 = t17.*t24;
t38 = t21+t34;
t39 = t22+t30;
t36 = (t.*t3.*t33)./6.0;
t37 = (t.*t2.*t32)./6.0;
t40 = t10+t21+t35;
t41 = t12+t22+t31;
t42 = (t.*t3.*t38)./6.0;
t43 = (t.*t2.*t39)./6.0;
t44 = -t43;
t45 = (t.*t40)./6.0;
t46 = (t.*t41)./6.0;
t51 = t36+t37;
t47 = t46+y;
t48 = t45+x;
t52 = t42+t44;
t49 = t2.*t48;
t50 = t3.*t47;
t53 = t28.*t52;
t54 = t14+t49+t50;
t55 = t.*t27.*t29.*t54;
t56 = t53+t55;
t57 = t28.*t51.*t56;
APP = reshape([t29.*t51.^2,t57,t57,t56.^2],[2,2]);
