%2(a)
fracTestA = 0.1;
reordA = 0;
misclassA = separateQP(fracTestA,reordA,0.001);
fprintf('For A, fracTest: %d, reord: %d, Misclassified points: %d\n',fracTestA, reordA, misclassA);
clear

%2(b)
fracTestB = 0.15;
reordB = 0;
misclassB = separateQP(fracTestB,reordB,0.001);
fprintf('For B, fracTest: %d, reord: %d, Misclassified points: %d\n',fracTestB, reordB, misclassB);
clear
%2(c)
fracTestC = 0.2;
reordC = 1;
misclassC = separateQP(fracTestC,reordC,0.001);
fprintf('For C, fracTest: %d, reord: %d, Misclassified points: %d\n',fracTestC, reordC, misclassC);
clear

%2(d)
fracTestD = 0.05;
reordD = 1;
misclassD = separateQP(fracTestD,reordD,0.001);
fprintf('For D, fracTest: %d, reord: %d, Misclassified points: %d\n',fracTestD, reordD, misclassD);