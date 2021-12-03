clear variables

%%Input variables
Lx=1000; %horizontal length of field
Ly=1000; %vertical length of field

Np=10000; %no. of particles
Nt=1000; %time steps
Nk=1; %Number of repeated simulations

%Sigma parameters for step sizes
sigs=10.47;
sigd=11.25;

%Movement frequency parameters
MPd=0.25;
MPs=0.5;

corstr=0.8; %Correlation strength of Von Mises distribution for sparse movement

R=100; %Perception radius

DensityLimit= 5*10^(-3); %Density threshold
dl=DensityLimit*pi*R^2; %Number of slugs within R at the threshold


for k=1:Nk %This for loop can be changed to a parfor loop for parallel simulations

    
    %%initial position
    Px0=rand(1,Np)*Lx; Py0=rand(1,Np)*Ly; th=rand(1,Np)*2*pi;
    Px=Px0; Py=Py0;
    Pxh=zeros(Nt/100,Np); Pyh=zeros(Nt/100,Np);
    
    %% Random Walk
    for j=1:Nt+1
         
        [Px,Py,th]=nextstep(Px,Py,th,sigs,sigd,MPd,MPs,corstr,R,Lx,Ly,dl);       
        
        % Position of all animals is recorded at every 100 time steps to
        % find temporal dynamics without a huge data file
        if mod(j,100)==0
            Pxh(j/100,:)=Px; Pyh(j/100,:)=Py;
        end
        
    end
    
    %
    X{k}=Pxh; Y{k}=Pyh; 
    
end
