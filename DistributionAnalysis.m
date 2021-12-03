% Distribution Analysis

Nl=10; %Number of bins in the grid (in one dimension, i.e. grid is NlxNl)

for k=1:Nk
    Pxh=X{k}; Pyh=Y{k};
    
    for j=1:Nt/100

        %Calculate the bin populations and reformat for contour plots
        Pt(:,:,j)=histcounts2(Pxh(j,:),Pyh(j,:),0:Lx/Nl:Lx,0:Ly/Nl:Ly);
        Pt(:,:,j)=rot90(Pt(:,Nl:-1:1,j));

        %Calculate Morisita index
        Q=Nl.^2; n=Pt(:,:,j); N=Np;
        MI(j,k)=Q*(sum(sum((n.*(n-1)))))/(N*(N-1));



    end

    %Calculate bin mean and variance of final distribution
    Bmean(k)=mean2(Pt(:,:,end));
    Bvar(k)=var(reshape(Pt(:,:,end),(Nl)^2,1));
    Bmeanlog(k)=log(Bmean(k));
    Bvarlog(k)=log(Bvar(k));

    Ptc{k}=Pt;

end

%% Distribution Plots

figure
plot(X{1}(end,:),Y{1}(end,:),'.')
i=1;
set(i,'paperunits','centimeters');
set(i,'papersize',[16 14]);
set(i,'paperposition',[0 0 16 14]);
ax = gca;
ax.FontSize = 18;
xlim([0 Lx])
ylim([0 Ly])
ylabel('$y$','interpreter','latex','FontSize',28)
xlabel('$x$','interpreter','latex','FontSize',28);

figure
contourf(Ptc{1}(:,:,end))
colorbar
i=1;
set(i,'paperunits','centimeters');
set(i,'papersize',[16 14]);
set(i,'paperposition',[0 0 16 14]);
ax = gca;
ax.FontSize = 18;
xticks([1:9/5:10])
xticklabels([0:0.2:1])
yticks([1:9/5:10])
yticklabels([0:0.2:1])
ylabel('$y$','interpreter','latex','FontSize',28)
xlabel('$x$','interpreter','latex','FontSize',28);