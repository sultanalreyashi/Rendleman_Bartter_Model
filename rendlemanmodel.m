clear all;
close all;

theta = input('What is theta?');
sigma = input('What is sigma?');
r0 = input('What is the intial interest value?');
T = input('What is the value of T?');
N = input('What is the value of N?');
u = 5;
d = 1/u;
strike = 500;

for k = 1:1000;
    for l = 1:N;
        deltaW(l) = (T/N)^(1/2)*randn(1,1);
    end;
    r(1) = r0 + theta*r0*(T/N) + sigma*r0*deltaW(1);
    for j = 2:N;
        r(j) = r(j-1) + theta*r(j-1)*(T/N) + sigma*r(j-1)*deltaW(j);
    end;
    
    endvalueAmer(k) = max(r);
    endvalueEuro(k) = r(N);
    endvalueAsian(k) = mean(r);
end;

%risk neutral probability
%for n = 1:length(endvalueEuro);
for n = 1:length(endvalueAmer);
%for n = 1:length(endvalueAsian);

    %p(n) = ( 1 + endvalueEuro(n) - d)/( u - d);
    p(n) = ( 1 + endvalueAmer(n) - d)/( u - d);
    %p(n) = ( 1 + endvalueAsian(n) - d)/( u - d);
end;

stockarray = [];
stockarray(1) = 500; %sake of testing limit values from around 25-1000 
                     %may vary due to the checks below

for i = 1:length(p); %run a test per calculated probability
    m = 1;
    while m < length(p);
        x = binornd(1,p(i), 1, 1); %the chances of success with prob p
        if x == 1;
            if stockarray(m)>=1000;
                stockarray(m+1) = stockarray(m)*d;
            else
                stockarray(m+1) = stockarray(m)*u; % if heads then mulitple previous price by u
            end;
        else
            if stockarray(m) <= 25;
                stockarray(m+1) = stockarray(m)*u; % otherwise it went down, so multiple by d
            else
                stockarray(m+1) = stockarray(m)*d;
            end;
        end;
        m = m+1;
        
        %European Option
        %varrayEuroPut(i) = max( strike - stockarray(end) , 0 ); %put option
        %varrayEuroCall(i) = max( stockarray(end) - strike , 0 ); %call option
        
        %American Option 
        %varrayAmerPut(i) = max( strike - min(stockarray) , 0 ); %put option
        %varrayAmerCall(i) = max( max(stockarray) - strike , 0 ); %call option
        
        %Asian Option
        varrayAsianPut(i) = max( strike - mean(stockarray), 0 ); %put option
        varrayAsianCall(i) = max( mean(stockarray) - strike , 0 ); %call option
    end;
end;