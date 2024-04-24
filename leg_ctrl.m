clear,clc
%%
%RM平衡学习mdy
%%五连杆轮腿机器人建模
%运动学建模
syms Tp T N Nf R L LM l mw mp M Iw Ip IM%结构量
%位置状态，导数，二阶导
x=str2sym('x(t)');
theta=str2sym('theta(t)');
phi=str2sym('phi(t)');
syms dtheta dx dphi 
syms ddtheta ddx ddphi
%常量，自变量
syms g t
%解算
NM= M * (ddx + (L + LM) * (ddtheta * cos(theta) - dtheta ^ 2 * sin(theta))-l*(ddphi*cos(phi)-dphi^2*sin(phi)));
PM=M*g+ M  * ((L + LM) * (-ddtheta * sin(theta) - dtheta ^ 2 * cos(theta))+l*(-ddphi*sin(phi)-dphi^2*cos(phi)));
N=NM+mp*(ddx+L*(ddtheta*cos(theta)-dtheta^2*sin(theta)));
P=PM+mp*g+mp*L*(-ddtheta*sin(theta)-dtheta^2*cos(theta));
eq0=ddx==(T-N*R)/(Iw/R+mw*R);
eq1=Ip*ddtheta==(P*L+PM*LM)*sin(theta)-(N*L+NM*LM)*cos(theta)-T+Tp;
eq2=IM*ddphi==Tp+NM*l*cos(phi)+PM*l*sin(phi);
[ddtheta,ddx,ddphi] = solve(eq0, eq1, eq2, ddtheta,ddx,ddphi);
%非线性状态方程线性化
%dX=f(X,U)
syms dX X U
syms A B C
dX=[dtheta;ddtheta;dx;ddx;dphi;ddphi];
X=[theta;dtheta;x;dx;phi;dphi];
U=[T;Tp];
A_t=jacobian(dX,X);
B_t=jacobian(dX,U);
X_bar=[0;0;x;0;0;0];%X_bar=[0;0;0;0;0;0]
U_bar=[0;0];
A=subs(A_t,[X;U],[X_bar;U_bar]);
B=subs(B_t,[X;U],[X_bar;U_bar]);
dX=A*X+B*U;

%LQR计算
%不同工况
syms E
E = [Ip LM L R l mw mp M Iw IM g];
%数据来源：抄
F = zeros(28, 11);
F(1, 1:11) = [0.020735 * 2, 0.052123, 0.053137, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(2, 1:11) = [0.021533 * 2, 0.062761, 0.052399, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(3, 1:11) = [0.022231 * 2, 0.072906, 0.052704, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(4, 1:11) = [0.022853 * 2, 0.082122, 0.053558, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(5, 1:11) = [0.023436 * 2, 0.090598, 0.054712, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(6, 1:11) = [0.024041 * 2, 0.099111, 0.056159, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(7, 1:11) = [0.024647 * 2, 0.107288, 0.057752, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(8, 1:11) = [0.025344 * 2, 0.116247, 0.059693, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(9, 1:11) = [0.025953 * 2, 0.123711, 0.061449, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(10, 1:11) = [0.026650 * 2, 0.131846, 0.063464, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(11, 1:11) = [0.027434 * 2, 0.140559, 0.065741, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(12, 1:11) = [0.028131 * 2, 0.147935, 0.067745, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(13, 1:11) = [0.028886 * 2, 0.155585, 0.069885, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(14, 1:11) = [0.029713 * 2, 0.163601, 0.072199, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(15, 1:11) = [0.030532 * 2, 0.171209, 0.074451, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(16, 1:11) = [0.031363 * 2, 0.178625, 0.076685, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(17, 1:11) = [0.032250 * 2, 0.186238, 0.079022, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(18, 1:11) = [0.033189 * 2, 0.194006, 0.081444, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(19, 1:11) = [0.034198 * 2, 0.202039, 0.083991, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(20, 1:11) = [0.035104 * 2, 0.209000, 0.086023, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(21, 1:11) = [0.037214 * 2, 0.224451, 0.091299, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(22, 1:11) = [0.038227 * 2, 0.231522, 0.093668, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(23, 1:11) = [0.039378 * 2, 0.239330, 0.096310, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(24, 1:11) = [0.040487 * 2, 0.246645, 0.098815, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(25, 1:11) = [0.041585 * 2, 0.253698, 0.101262, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(26, 1:11) = [0.042851 * 2, 0.261638, 0.104072, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(27, 1:11) = [0.043944 * 2, 0.268347, 0.106493, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
F(28, 1:11) = [0.045994 * 2, 0.280684, 0.111146, 0.100, 0.0082704, 1.424, 3.686, 15.054, 0.0033, 0.259856909, 9.8];
Q = [1 0 0 0 0 0; ...
       0 10 0 0 0 0; ...
       0 0 500 0 0 0; ...
       0 0 0 110 0 0; ...
       0 0 0 0 30000 0; ...
       0 0 0 0 0 50];
R = [1.5 0;0 0.25];

AT=A;
BT=B;
L0=L+LM;
for i=1:1:28
    AT=double(subs(A,E,F(i,1:11)));
    BT=double(subs(B,E, F(i, 1:11)));
    %K_L0(2 * i - 1:2 * i, 1:6) = K_t;
    K_t=double(lqr(AT,BT,Q,R));
    K11_t(i) = K_t(1, 1);
    K12_t(i) = K_t(1, 2);
    K13_t(i) = K_t(1, 3);
    K14_t(i) = K_t(1, 4);
    K15_t(i) = K_t(1, 5);
    K16_t(i) = K_t(1, 6);
    K21_t(i) = K_t(2, 1);
    K22_t(i) = K_t(2, 2);
    K23_t(i) = K_t(2, 3);
    K24_t(i) = K_t(2, 4);
    K25_t(i) = K_t(2, 5);
    K26_t(i) = K_t(2, 6);
    L0(i)=subs(L+LM,[LM,L],F(i,2:3));
    L0=double(L0);
    %可控制性检验
    % C=ctrb(AT,BT);
    % [c,r]=size(C);
    % if rank(C)==min(c,r)
    %     disp('controlable');
    % else
    %     disp('uncontrolable');
    % end
end
L0=[0.14;0.15;0.16;0.17;0.18;0.19;0.20;0.21;0.22;0.23;0.24;0.25;0.26;0.27;0.28;0.29;0.30;0.31;0.32;0.33;0.34;0.35;0.36;0.37;0.38;0.39;0.40;0.41];
K_L011v = polyfit(L0, K11_t, 3);
K_L012v = polyfit(L0, K12_t, 3);
K_L013v = polyfit(L0, K13_t, 3);
K_L014v = polyfit(L0, K14_t, 3);
K_L015v = polyfit(L0, K15_t, 3);
K_L016v = polyfit(L0, K16_t, 3);
K_L021v = polyfit(L0, K21_t, 3);
K_L022v = polyfit(L0, K22_t, 3);
K_L023v = polyfit(L0, K23_t, 3);
K_L024v = polyfit(L0, K24_t, 3);
K_L025v = polyfit(L0, K25_t, 3);
K_L026v = polyfit(L0, K26_t, 3);

K_L0v=[K_L011v,K_L012v,K_L013v,K_L014v,K_L015v,K_L016v;
K_L021v, K_L022v, K_L023v, K_L024v, K_L025v, K_L026v];
K_L0v=double(K_L0v);
L0=str2sym('L0');
for i=1:1:2
    for j=1:1:6
        K_L0(i, j) = K_L0v(i, 4 * (j - 1) + 1)*L0^3 + K_L0v(i, 4 * (j - 1) + 2)*L0^2 + K_L0v(i, 4 * (j - 1) + 3)*L0 + K_L0v(i, 4 * (j - 1) + 4);
    end
end
%验证
K_L0=double(subs(K_L0,L0,0.280684+0.111146))
%由于求导，位置期望舍去初始的常数，补充
syms Xd x_expect
Xd=[0;0;x_expect;0;0;0];
U=K_L0*(Xd-X);
%%
%VMC五连杆
syms xb yb xd yd
syms l0 l1 l2 l3 l4
syms phi0 phi1 phi2 phi3 phi4
% In=[l1 ,l2 ,l3 ,l4 ,l0 ,phi1 ,phi0];
% In=[0.15 ,0.26 ,0.26 ,0.15 ,0.11 ,2.094 ,0.52];

xb=l1*cos(phi1);
yb=l1*sin(phi1);
xd=l0+l4*cos(phi4);
yd=l4*sin(phi4);
%不要直接求，3060测试运行了3分钟才运行完，而且解不出来了
% f1=l1*cos(phi1)+l2*cos(phi2)==l0+l4*cos(phi4)+l3*cos(phi3);
% f2=l1*sin(phi1)+l2*sin(phi2)==l4*sin(phi4)+l3*sin(phi3);
% [phi2,phi3]=solve(f1,f2,phi2,phi3)
% phi2=phi2(1);
yd = l4*sin(phi4);
lBD=sqrt((xd-xb)^2+(yd-yb)^2);
A0 = 2*l2*(xd-xb);A1=2*l3*(xb-xd);
B0 = 2*l2*(yd-yb);B1=2*l3*(yb-yd);
C0 = l2^2 + lBD^2 -l3^2;C1=l3^2+lBD^2-l2^2;
D0=sqrt(A0^2+B0^2-C0^2);D1=sqrt(A1^2+B1^2-C1^2);
phi2=2*atan((B0+D0)/(A0+C0));phi3=2*atan((B1+D1)/(A1+C1));
xc = xb + l2 * cos(phi2);
yc = yb + l2 * sin(phi2);
L0=norm([xc,yc]-[l0/2,0]);
phi0=atan(yc/(xc-l0/2));


Xt=[L0;phi0];
Q=[phi1;phi4];
%使用simplify化简时间过长
%J=[diff(L0,phi1),diff(L0,phi4);diff(phi0,phi1),diff(phi0,phi4)];
J = [l1 * sin(phi0 - phi3) * sin(phi1 - phi2) / sin(phi3 - phi2),l1 * cos(phi0 - phi3) * sin(phi1 - phi2) / L0/sin(phi3 - phi2); 
     l4 * sin(phi0 - phi2) * sin(phi3 - phi4) / sin(phi3 - phi2),l4 * cos(phi0 - phi2) * sin(phi3 - phi4) / L0/sin(phi3 - phi2)];
syms T1 T2 f
T=[T1;T2];
F=[f;Tp];
%T=J'*F;
%验证
Value = [0.15 0.26 0.26 0.15 0.11 2.094 0.52];
L0=double(subs(L0,[l1,l2,l3,l4,l0,phi1,phi4],Value));
phi0=double(subs(phi0,[l1,l2,l3,l4,l0,phi1,phi4],Value));
J=double(subs(J,[l1,l2,l3,l4,l0,phi1,phi4],Value));


