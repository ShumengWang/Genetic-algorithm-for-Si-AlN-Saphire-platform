%%%%% for pattern removal, 2 etching steps, Shumeng Wang
function pattern_remove(model,n_etch,etching_depth1,etching_depth2,etch_label)

if n_etch ==0
    return;
end

if etching_depth1 ==0 && etching_depth2 ==0
    return;
end
model.geom('geom1').feature.remove({'dif1'});
model.geom('geom1').feature.remove({'dif2'});

for j=1:1:n_etch
    model.geom('geom1').feature.remove(etch_label(j));  
end
end