
%Problem 1(b)
fracTest = 0.15;
record = 1;
datafile = 'wdbc.data';
dataDim = 30;
miu = 0.001;
M=[];
B=[];
[train,test,ntrain,ntest]=wdbcData(datafile,dataDim,fracTest,record);

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

MisClassNum = 0;
a = M*w - em *Ygamma;
b = B*w - ek *Ygamma;
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
% w is
w
% Ygamma is
Ygamma
% optimal object
cvx_optval
% number of misclassified points
MisClassNum
% end for p1(b)
