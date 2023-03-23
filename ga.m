%%%%%%% GA-2etching steps-Shumeng Wang

%% load
model= mphopen('main.mph');
initial_pop=load('initial_pop.mat');

%%%% initial pop
G0_first=initial_pop.G0_gene;

width_first=initial_pop.width_pop;
height_first=initial_pop.height_pop;

etching_depth_first1=initial_pop.etching_depth_pop(:,1);
etching_depth_first2=initial_pop.etching_depth_pop(:,2);

etching_position_first1=initial_pop.etching_position_pop1;
etching_position_first2=initial_pop.etching_position_pop2;


%% main %%%%%%%%%%%%%%%

%%%% parameter set
width=(50:50:1000)*1e-9;  
height=(50:50:1000)*1e-9;  

etching_depth=(0:50:950)*1e-9; 
num_etching_position=1:1:20;    

%%%%% electric field resolution
dx=10e-7/200;
dy=dx;
x_core= -5e-7:dx:5e-7;
y_core= -5e-7:dy:5e-7;
x_sub=-1.65e-6:dx:1.65e-6;
y_sub=-2.2e-6:dy:-5e-7;

[xx_core,yy_core]=meshgrid(x_core,y_core);
coor_core=[xx_core(:),yy_core(:)]';

[xx_sub,yy_sub]=meshgrid(x_sub,y_sub);
coor_sub=[xx_sub(:),yy_sub(:)]';

%%%% generate gene
iteration=100;
N_P=100;

size_gene=44;
gene_first=zeros(N_P,size_gene);
for i=1:1:N_P
    gene_first(i,:)=[width_first(i) height_first(i) etching_depth_first1(i) etching_depth_first2(i) etching_position_first1(i,:) etching_position_first2(i,:)];
end

freq_record=zeros(iteration,N_P);
G0_record=zeros(iteration,N_P);

pattern_record=zeros(iteration,N_P,size_gene);

G0_max_record=zeros(1,iteration);

%select
[winners,winners_index]=maxk(G0_first,50);

pattern_winners=gene_first(winners_index,:);

%%%%%%% iteration starts
for i=1:1:iteration
    
   %crossover
   child=zeros(N_P,size_gene);
   count=1;
   for j=1:1:N_P/2      
       pattern_1=pattern_winners(j,:);
       %randomly pick parents
       index_pattern=randi(50,1);
       while (index_pattern==j)
           index_pattern=randi(50,1);
       end
       pattern_2=pattern_winners(index_pattern,:);
       %crossover
       child1=[pattern_1(1) pattern_2(2) pattern_2(3) pattern_2(4) pattern_1(5:24) pattern_1(25:end)];
       child2=[pattern_2(1) pattern_1(2) pattern_1(3) pattern_1(4) pattern_2(5:24) pattern_2(25:end)];

       child(count,:)=child1;
       count=count+1;      
       child(count,:)=child2;
       count=count+1;
   end
   %mutation
   for k=1:1:length(child)
       w=child(k,1);
       h=child(k,2);
       ed1=child(k,3);
       ed2=child(k,4);
       ep1=child(k,5:24);
       ep2=child(k,25:end);
       %20% w ep1 ep2 change
       o=randi(100,1);
       if o<=20
           index_width=randi(20);
           width_new=width(index_width);
           while width_new == w
               index_width=randi(20);
               width_new=width(index_width);
           end
           w=width_new;
           maxnum_etching_position_allow=round(w/(50*1e-9));

           new_etching_position_allow1=zeros(1,20);
           new_etching_position_allow2=zeros(1,20);

           num_etching_position_allow=randi(maxnum_etching_position_allow);

           position=randi(maxnum_etching_position_allow,1,num_etching_position_allow);
           uniq=size(position,2)-size(unique(position),2);
           while uniq ~=0
               position=randi(maxnum_etching_position_allow,1,num_etching_position_allow);
               uniq=size(position,2)-size(unique(position),2);
           end
           index=randi(length(position));
           new_etching_position_allow1(1:index)=position(1:index);
           new_etching_position_allow2(1:(length(position)-index))=position(index+1:end);

           ep1=new_etching_position_allow1;
           ep2=new_etching_position_allow2;

           child(k,1)=w;
           child(k,5:24)=ep1;
           child(k,25:end)=ep2;
       end
       %20% h ed1 ed2 change
       r=randi(100,1);
       if r<=20
           index_height=randi(20);
           height_new=height(index_height);
           while height_new == h
               index_height=randi(20);
               height_new=height(index_height);
           end
           h=height_new;
           etching_depth_allow=round(h/(50*1e-9));
           etching_depth_index1=randi(etching_depth_allow);
           etching_depth_index2=randi(etching_depth_allow);
           if etching_depth_allow ~=1 
                while (etching_depth_index1 == etching_depth_index2)
                    etching_depth_index2=randi(etching_depth_allow);
                end
           end
           etching_depth_new_1=etching_depth(etching_depth_index1);
           etching_depth_new_2=etching_depth(etching_depth_index2);

           ed1=etching_depth_new_1;
           ed2=etching_depth_new_2;
           child(k,2)=h;
           child(k,3)=ed1;
           child(k,4)=ed2;
       end
   end
   pattern_record(i,:,:)=child;
   %calculate fitness
   for u=1:1:N_P
    %%pattern generation
    width_picked=child(u,1);
    height_picked=child(u,2);
    etching_depth_picked1=child(u,3);
    etching_depth_picked2=child(u,4);
    
    position_picked1=child(u,5:24);
    position_picked2=child(u,25:end);
    position_picked1=position_picked1(position_picked1~=0);
    position_picked2=position_picked2(position_picked2~=0);


    [etch_label,n_etch]=pattern_generate(model,width_picked,height_picked,position_picked1,etching_depth_picked1,position_picked2,etching_depth_picked2);
    
    %preset
    preset(model);
    %calculate
    %%find optical mode
    model.study('std1').feature('mode').set('neigs', 10);
    model.study('std1').feature('mode').set('shift', '3');
    model.study('std1').feature('mode2').set('neigs', 10);
    model.study('std1').feature('mode2').set('shift', '3');
    model.study('std1').feature('eig').active(false);
    
    model.component('comp1').mesh('mesh1').run;
    model.sol('sol1').runAll;
    %%data analysis
    effective_index=real(mphglobal(model,'emw_p.neff'));
    E_core=mphinterp(model,'emw_s.normE','coord',coor_core,'dataset','dset3','outersolnum',1);
    E_sub=mphinterp(model,'emw_s.normE','coord',coor_sub,'dataset','dset3','outersolnum',1);

    int_core=sum(E_core.*(dx*dy),2);
    int_sub=sum(E_sub*(dx*dy),2);
    ratio=int_core./int_sub;
    [Biggest_int,Biggest_index]=maxk(ratio,3);
    %%calculate G0
    effective_index_picked=effective_index(Biggest_index);
    G0_max=zeros(1,length(effective_index_picked));
    G0_max_freq=zeros(1,length(effective_index_picked));
    for k=1:1:length(effective_index_picked)
    model.study('std1').feature('mode').set('neigs', 1);
    model.study('std1').feature('mode').set('shift',num2str(effective_index_picked(k)));
    model.study('std1').feature('mode2').set('neigs', 1);
    model.study('std1').feature('mode2').set('shift',num2str(effective_index_picked(k)));
    model.study('std1').feature('eig').active(true);
    model.sol('sol1').runAll;
    G0=mphglobal(model,'G0');
    freq=real(mphglobal(model,'solid.freq'))/1e9;
    [max_G0,max_G0_index]=maxk(G0,1);
    G0_max(k)=max_G0;
    G0_max_freq(k)=freq(max_G0_index);
    
    %plot
    mphplot(model,'pg1','server','off');
    title(['it=' num2str(i) 'pattern=' num2str(u) ' index=' num2str(effective_index_picked(k))])
    savefig(['it=' num2str(i) 'pattern=' num2str(u) ' index=' num2str(effective_index_picked(k)) '.fig']);
    mphplot(model,'pg3','server','off');
    title(['it=' num2str(i) 'pattern=' num2str(u) ' G0=' num2str(G0_max(k)) ' Freq=' num2str(G0_max_freq(k))])
    savefig(['it=' num2str(i) 'pattern=' num2str(u) '_G0=' num2str(G0_max(k)) '_Freq=' num2str(G0_max_freq(k)) '.fig']);
    end
    [G0_max_total,G0_max_total_index]=maxk(G0_max,1);
    G0_record(i,u)=G0_max_total;
    freq_record(i,u)=G0_max_freq(G0_max_total_index);
    
    save('data');
    %remove
    pattern_remove(model,n_etch,etching_depth_picked1,etching_depth_picked2,etch_label);
   end
   %select
   [winners,winners_index]=maxk(G0_record(i,:),50);
    pattern_winners=child(winners_index,:);
   G0_max_record(i)=max(G0_record(i,:));
   %save data
   save('data');
end


