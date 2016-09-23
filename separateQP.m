function misclass = separateQP(fracTest1, reord1,mu)
fracTest = fracTest1;
reord = reord1;
[train,test,ntrain,ntest]=wdbcData('wdbc.data',30,fracTest,reord);

B = [];
M = [];
for i = 1:ntrain
    if(train(i,1) == 0)
        B = [B;train(i,2:end)];
    
    elseif(train(i,1) == 1)
        M = [M;train(i,2:end)];
    end
end

m = size(M,1);
k = size(B,1);
em = ones(m,1);
ek = ones(k,1);
miu = mu;

cvx_begin quiet
    variable w(30)
    variable Ygamma(1)
    variable y(m)
    variable z(k)
    minimize ((1/m)*em'*y + (1/k)*ek'*z + (miu/2)*w'*w)
    subject to
    M*w - em* Ygamma +y >= em
    -B*w + ek* Ygamma + z >= ek
    y >= 0
    z >= 0
cvx_end

BT = [];
MT = [];
for i=1:ntest
    if(test(i,1)==0)
        BT = [BT;test(i,2:end)];
    end
    if(test(i,1)==1)
        MT = [MT;test(i,2:end)];
    end
end

MisClassNum = 0;
m = size(MT,1);
k = size(BT,1);
em = ones(m,1);
ek = ones(k,1);

a = MT*w - em *Ygamma;
b = BT*w - ek *Ygamma;

for i = 1:m
    if(a(i)<=0)
        MisClassNum = MisClassNum+1;
    end
end

for i = 1: k
    if(b(i)>0)
        MisClassNum = MisClassNum+1;
    end
end
misclass = MisClassNum;