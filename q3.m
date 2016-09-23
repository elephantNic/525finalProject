% q3
fracTest = 0.12;
reord = 0;
fewMis = 0;
fewOpt = 0;
miu = 0.0008;
[train,test,ntrain,ntest]=wdbcData('wdbc.data',30,fracTest,reord);
fh = fopen('soln.txt','w');
for l = 1:30
    for j = l+1:30
        M=[];
        B=[];
        for i =1:ntrain
            if(train(i,1) == 0)
                B=[B;train(i,[l+1 j+1])];
            elseif(train(i,1) == 1)
                M = [M;train(i,[l+1 j+1])];
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
         
         MisClassNum = 0;
         a = M*w-em*Y;
         b = B*w-ek*Y;
         for i = 1:m
             if(a(i) <= 0)
                 MisClassNum = MisClassNum+1;
             end
         end
         for i = 1:k
             if(b(i) > 0)
                 MisClassNum = MisClassNum+1;
             end
         end
         if(l==1 && j==2)
             fewMis = MisClassNum;
             fprintf(fh,'features %2d %2d: misclass %3d\n',l,j,fewMis);
             fewOpt = cvx_optval;
         else
             if(MisClassNum < fewMis)
                 fewMis = MisClassNum;
                 fprintf(fh,'features %2d %2d: misclass %3d\n',l,j,fewMis);
                 fewOpt = cvx_optval;
             elseif(MisClassNum == fewMis)
                 if(cvx_optval < fewMis)
                     fewMis = MisClassNum;
                     fprintf(fh,'features %2d %2d: misclass %3d\n',l,j,fewMis);
                     fewOpt = cvx_optval;
                 end
             end
         end
    end
end

        