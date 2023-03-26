function child_m=mutation(child,etching_depth,height)
   for k=1:1:length(child)
       w=child(k,1);
       h=child(k,2);
       ed1=child(k,3);
       ed2=child(k,4);
       ep1=child(k,5:24);
       ep2=child(k,25:end);       
       % 20% mirror
       r=randi(100,1);
       if r<=20
           s=randi(50,1);
           if s>=50
               child(k,:)=[child(k,3:24) flip(child(k,3:24))];
           else
               child(k,:)=[flip(child(k,25:end)) child(k,25:end)];
           end                   
       end

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
   child_m=child;
end