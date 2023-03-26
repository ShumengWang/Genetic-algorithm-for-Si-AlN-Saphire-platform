function child=crossover(N_P,size_gene,pattern_winners)

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
end