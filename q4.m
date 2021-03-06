fracTest = 0.12;
reord = 0;
miu = 0.0008;
[train,test,ntrain,ntest]=wdbcData('wdbc.data',30,fracTest,reord);
B = [];
M = [];
for i = 1:ntrain
    if(train(i,1)==0)
        B = [B;train(i,[15 29])];
    elseif(train(i,1)==1)
        M = [M;train(i, [15 29])];
    end
end
m = size(M,1);
k = size(B,1);
em = ones(m,1);
ek = ones(k,1);
cvx_begin quiet
    variable w(2)
    variable Y(1)
    variable y(m)
    variable z(k)
    minimize((1/m)*em'*y + (1/k)*ek'*z + (miu/2)*w'*w)
    subject to
    M*w - em*Y +y >= em
    -B*w + ek*Y+z >= ek
    y >= 0
    z >= 0
cvx_end

BT = [];
MT = [];
for i = 1:ntest
    if(test(i,1)==0)
        BT = [BT;test(i,[15 29])];
    elseif(test(i,1)==1)
        MT = [MT;test(i,[15 29])];
    end
end


MisClassNum = 0;
m = size(MT,1);
k = size(BT,1);
em = ones(m,1);
ek = ones(k,1);

a = MT*w - em *Y;
b = BT*w - ek *Y;
for i = 1:m
    if(a(i) <= 0)
        MisClassNum = MisClassNum+1
    end
end
for i = 1:k
    if(b(i)>0)
        MisClassNum = MisClassNum+1
    end
end

MisClassNum
scatter(BT(:,1),BT(:,2),'o');
hold on;
scatter(MT(:,1),MT(:,2),'x');
x1 = 1:200;
x2 = 1/w(2)*Y-w(1)/w(2)*x1;
plot(x1,x2);
