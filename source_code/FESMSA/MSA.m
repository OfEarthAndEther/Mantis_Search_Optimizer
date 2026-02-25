%_________________________________________________________________________%
%  Mantis Search Algorithm (MSA) source codes demo 1.0               %
%                                                                         %
%  Developed in MATLAB R2019A                                      %
%                                                                         %
%  Author and programmer: Mohamed Abdel-Basset (E-mail: mohamedbasset@ieee.org) & Reda Mohamed (E-mail: redamoh@zu.edu.eg)                              %
%                                                                         %
%   Main paper: Abdel-Basset, M., Mohamed, R.                                    %
%               Mantis Search Algorithm: A novel bio-inspired algorithm for global optimization and engineering design problems,                         %
%               Computer Methods in Applied Mechanics and Engineering, in press              %
%                                                                         %
%_________________________________________________________________________%


% The Mantis Search Algorithm
function [Best_score,Best_P]=MSA(SearchAgents_no,Max_iter,ub,lb,dim,fobj,fhd)

%%-------------------Controlling parameters--------------------------%%
p=0.5;   %% A probability to exchange between the exploration and exploitation stages
A=1.0;   %% Length of the archive
a=0.5;   %% A probability of the strike’s failure
P=2;     %% A recycling factor to exchange between pursuers and spearers
alp=6; %% The gravitational acceleration rate of the mantis’s strike
Pc=0.2;  %% The percentage of sexual cannibalism 

%%-------------------Definitions--------------------------%%
Best_P=zeros(1,dim); % A vector to include the prey position, also referred to as the best-so-far solution
Best_score=inf; % A Scalar variable to include the best-so-far score
LFit=[]; % A vector to include the local-best position for each mantis
archive=[[]]; %% an archive to include the positions of a number of camouflaged places

%%---------------Initialization----------------------%%

Positions=initialization(SearchAgents_no,dim,ub,lb); %Initialize the positions of search agents
Lbest=Positions; %% Set the local best for each mantis as its current position at the beginning.
t=0; %% Function evaluation counter 

%%---------------------Evaluation-----------------------%%
for i=1:SearchAgents_no
   %% Test suites of CEC-2014, CEC-2017, CEC-2020, and CEC-2022
   MS_Fit(i)=feval(fhd, Positions(i,:)',fobj);
   %% In the beginning, set the local best score for the ith mantis by its current score.
   LFit(i)=MS_Fit(i); 
   % Update the best-so-far solution
   if MS_Fit(i)<Best_score % Change this to > for maximization problem
       Best_score=MS_Fit(i); % Update the best-so-far score
       Best_P=Positions(i,:); % Update te best-so-far solution
       %% Fill in the archive
       arcSol=[Best_P,Best_score]; %% A solution include the best-so-far position and its score
       if (size(archive,1)<A) %% Adding directly to the archive if it is not full; otherwise, remove an existing one selected randomly.
          archive(size(archive,1)+1,:)=arcSol;
       else
          archive(randi(A),:)=arcSol;
       end
   end
end

%% Starting The MSA's optimization process
while t<Max_iter
    RL=0.05*levy(SearchAgents_no,dim,1.5);   %Levy random number vector
    a2=-1+-1*(t/Max_iter); %% a2 linearly decreases from -1 to -2
    for i=1:SearchAgents_no
        l=(a2-1)*rand+1; %% a Factor including a numerical value between ?1 and -2 to control the gravitational acceleration rate 
        bA=archive(randi(size(archive,1)),1:dim); %% Selecting randomly a solution from the archive 
        a1=randi(SearchAgents_no); %% An index selected randomly between 1 and SearchAgents_no
        b=randi(SearchAgents_no); %% An index selected randomly between 1 and SearchAgents_no
        c=randi(SearchAgents_no); %% An index selected randomly between 1 and SearchAgents_no
        while a1==i | a1==b | c==b | c==a1 ||c==i |b==i %% Checking that a1!=b!=c!=i; if the same index is selected twice or more, the following code is applied repeatedly to satisfy this constraint:
            a1=randi(SearchAgents_no); %% An index selected randomly between 1 and SearchAgents_no
            b=randi(SearchAgents_no); %% An index selected randomly between 1 and SearchAgents_no
            c=randi(SearchAgents_no); %% An index selected randomly between 1 and SearchAgents_no
        end
        r1=rand(); % r1 is a random number in [0,1]
        r2=rand(); % r2 is a random number in [0,1]
        r3=rand(); % r1 is a random number in [0,1]
        t2=randn;  % t2 is a normal distribution-based number
        m=1-t/Max_iter; % Eq. (7)
      
        if (rand<p) %% Exchanging between exploration and exploitation
           F=1-rem(t,Max_iter/P)/(Max_iter/P);  % Eq. (10)
           U=rand(1,dim)>rand(1,dim); % A binary vector generated based on Eq. (4).
           for j=1:size(Positions,2)
              if r1<F %% Exploration of pursuers’ behavior
                  if r2<r3 % Eq. (3)
                     Steps=(Positions(i,j)-Positions(a1,j))*RL(i,j)+abs(t2)*U(j)*(Positions(a1,j)- Positions(b,j)); % Eq. (3a)
                     Positions(i,j)= Positions(i,j)+Steps;      % Eq. (3a)
                  else
                     y = Positions(a1,j)+rand.*(Positions(b,j)-Positions(c,j)); % Eq. (3b)
                     if rand<=rand %% Merging the characteristics of the new solution and the current one to simulate sudden orientation for the ith mantis
                       Positions(i,j)=y;
                     end
                  end
              else %% Exploration of spearers’ behavior
                  if r2<r3 % Eq. (9)
                     alpha=cos(pi*rand)*m; % Eq. (6)
                     Positions(i,j)=Positions(i,j)+alpha*(bA(j)-Positions(b,j)); % Eq. (5)
                  else 
                     Positions(i,j)=(bA(j))+(r2*2-1)*m*(lb(j)+rand*(ub(j)- lb(j))); % Eq. (8)
                  end
              end
           end
        else %% Attacking the prey: Exploitation stage
            for j=1:size(Positions,2)
                if rand<r2
                    Positions(i,j)=Positions(i,j)+r1*(Positions(a1,j)-Positions(b,j));      % Eq. (14)
                else
                    vs=1/(1+exp(alp*l)); %%Eq. (11)
                    dsi=Best_P(j)-Positions(i,j); %%Eq. (13)
                    Positions(i,j)=(Positions(i,j)+Best_P(j))/2.0+vs*dsi;      % Eq. (12)
                    Pf=a*(1-t/Max_iter); %%Eq. (16)
                    if r2<Pf 
                       Positions(i,j)=(Positions(i,j))+exp(2*l)*cos(2*l*pi)*abs(Positions(i,j)-bA(j))+(rand*2-1)*(ub(j)-lb(j)); % Eq. (15)
                    end
                end
            end   
        end
        %%%%%%Return the search agents that exceed the search space's bounds
         for j=1:size(Positions,2)
              if  Positions(i,j)>ub(j)
                   Positions(i,j)=lb(j)+rand*(ub(j)-lb(j));
              elseif  Positions(i,j)<lb(j)
                   Positions(i,j)=lb(j)+rand*(ub(j)-lb(j));
               end
         end   

        % Calculate objective function for each search agent
        MS_Fit(i)=feval(fhd, Positions(i,:)',fobj); %% The fitness value of the newly generated position
        % Memory Saving and Updating the best-so-far solution
        if MS_Fit(i)<LFit(i) % Change this to > for maximization problem
            LFit(i)=MS_Fit(i); % Update the local best fitness
            Lbest(i,:)=Positions(i,:); % Update the local best position of the ith mantis
            arcSol=[Lbest(i,:),MS_Fit(i)]; %% A solution include the best-so-far position and its score
            if (size(archive,1)<A) %% Adding directly to the archive if it is not full; otherwise, remove an existing one selected randomly.
               archive(size(archive,1)+1,:)=arcSol;
            else
               archive(randi(A),:)=arcSol;
            end
            if MS_Fit(i)<Best_score % Change this to > for maximization problem
               Best_score=MS_Fit(i); % Update best-so-far fitness
               Best_P=Positions(i,:); % Update best-so-far position
            end
        else
            MS_Fit(i)=LFit(i);
            Positions(i,:)=Lbest(i,:);
        end
        t=t+1; % Increment the current function evaluation
        if t>Max_iter
           break;
        end
    end
    
    if t>Max_iter
       break;
    end
    %% Sexual cannibalism
    if rand<Pc
       % Update the Position of search agents 
        for i=1:SearchAgents_no
            l=(a2-1)*rand+1; 
            r1=rand(); % r1 is a random number in [0,1]
            r3=rand(); % r3 is a random number in [0,1]
            if rand<rand
                  U=rand(1,dim)>rand(1,dim); % A binary vector generated based on Eq. (4).
                  for j=1:size(Positions,2)
                     Positions(i,j)= Positions(i,j)*U(j)+(Positions(1,1)+-rand*(-Positions(1,1)+Positions(i,j))).*(1-U(j)); % Eq. (19)
                  end
            else
                a1=randi(SearchAgents_no);
                while a1==i 
                   a1=randi(SearchAgents_no);
                end
                Pt=r2*(1-t/Max_iter);
                for j=1:size(Positions,2) 
                    if r1<Pt
                        Positions(i,j)= Positions(i,j)+r3*(Positions(i,j)- Positions(a1,j)); %% Eq. (17)
                    else
                        Positions(i,j)=Positions(a1,j)*cos(l*pi*2)*m; %% Eq. (20)
                    end
                end
            end
           %%%%%%Return the search agents that exceed the search space's bounds
            for j=1:size(Positions,2)
                if  Positions(i,j)>ub(j)
                    Positions(i,j)=lb(j)+rand*(ub(j)-lb(j));
                 elseif  Positions(i,j)<lb(j)
                    Positions(i,j)=lb(j)+rand*(ub(j)-lb(j));
                 end
             end   
            % Calculate objective function for each search agent
            MS_Fit(i)=feval(fhd, Positions(i,:)',fobj); %% The fitness value of the newly generated position
            % Memory Saving and Updating the best-so-far solution
            if MS_Fit(i)<LFit(i) % Change this to > for maximization problem
                LFit(i)=MS_Fit(i); % Update the local best fitness
                Lbest(i,:)=Positions(i,:); % Update the local best position of the ith mantis
                arcSol=[Lbest(i,:),MS_Fit(i)]; %% A solution include the best-so-far position and its score
                if (size(archive,1)<A) %% Adding directly to the archive if it is not full; otherwise, remove an existing one selected randomly.
                    archive(size(archive,1)+1,:)=arcSol;
                else
                    archive(randi(A),:)=arcSol;
                end
                if MS_Fit(i)<Best_score % Change this to > for maximization problem
                    Best_score=MS_Fit(i); % Update best-so-far fitness
                    Best_P=Positions(i,:); % Update best-so-far position
                end
            else
               MS_Fit(i)=LFit(i);
               Positions(i,:)=Lbest(i,:);
            end
            t=t+1; % Increment the current function evaluation
            if t>Max_iter
               break;
            end
       end
    end
   end
end