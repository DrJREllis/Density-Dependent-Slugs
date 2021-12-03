function [Px,Py,th]=nextstep(Px,Py,th,sigs,sigd,MPd,MPs,corstr,R,Lx,Ly,dl)

%Calculate a distance matrix of all animals
dists=pdist2([Px' Py'],[Px' Py']);

%Find animals in sparse and dense space
sparseind=find( sum(dists<=R)/2 < dl );
denseind=find( sum(dists<=R)/2 >= dl );
dw=size(denseind,2);

%% Sparse movement

pws=1/(1-MPs);

ss(sparseind)=abs(randn(size(sparseind,2),1)*sigs); %Generate step size
for i=sparseind
    th(i)=circ_vmrnd(th(i),corstr,1); %Generate direction of movement
    if rand*pws-1>=0
        ss(i)=0; %Generate non-movers
    end
end


Delx(sparseind)=ss(sparseind).*cos(th(sparseind)); %step length in x direction
Dely(sparseind)=ss(sparseind).*sin(th(sparseind)); %step length in y direction 


%% Dense movement
pwd=1/(1-MPd);
ss(denseind)=abs(randn(dw,1)*sigd); %Generate step size
th(denseind)=rand(dw,1)*2*pi-pi; %Generate direction of movement

ss(denseind)=ss(denseind).*(rand(dw,1)*pwd-1>=0)'; %Generate non-movers

Delx(denseind)=ss(denseind).*cos(th(denseind)); %step length in x direction
Dely(denseind)=ss(denseind).*sin(th(denseind)); %step length in y direction 


%% Boundary conditions

%For animals that move outside a boundary, the step is regenerated
ind2=find((Px+Delx > Lx) | (Px+Delx < 0) | (Py+Dely > Ly) | (Py+Dely < 0));    
for i=ind2
    while (Px(i)+Delx(i) > Lx) || (Px(i)+Delx(i) < 0) || (Py(i)+Dely(i) > Ly) || (Py(i)+Dely(i) < 0)  %closed boundary      
        
        if ismember(i,sparseind)==1
            th(i)=circ_vmrnd(th(i),corstr,1);
            ss(i)=abs(randn*sigs); 
            else if ismember(i,denseind)==1
                th(i)=rand*2*pi-pi;
                ss(i)=abs(randn*sigd); 
                end
        end
        Delx(i)=ss(i).*cos(th(i)); %step length in x direction
        Dely(i)=ss(i).*sin(th(i)); %step length in y direction 
    end   
end

%% Calculate new positions
Px=Px+Delx;
Py=Py+Dely;

