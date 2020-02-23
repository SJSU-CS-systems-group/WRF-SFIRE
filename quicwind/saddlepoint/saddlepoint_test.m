B=rand(6);
B(1:3,4:6)=0;
B(4:6,1:3)=0;
B
D = [1 1 1 0 0 0
     0 0 0 1 1 1];
% D = rand(2,4)
C = [1 0 0 1 0 0
     0 0 0 0 0 1 ]
v0 = rand(6,1)

% repeated subexpressions
Bt=B.';
Dt=D.';
Ct=C.';
ib=inv(Bt*B)
ibd=inv(D*ib*Dt)

% solution matrices
P=ib - ib*Dt*ibd*D*ib
M =C*P*Ct
rhs=(C*P*Bt)*v0

% solution components
q=M\rhs
v=P*(Bt*v0-Ct*q)
p=ibd*D*ib*(Bt*v0-Ct*q)

% test
res=[Bt*B*v + Dt*p + Ct*q - Bt*v0
    D*v
    C*v]
err=norm(res,inf)
