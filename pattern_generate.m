%%%%% for pattern generation, 2 etching steps, Shumeng Wang
%%%% 6 input parameter: width,height,etching_position1,etching_depth1,etching_position2,etching_depth2

function [etch_label,n_etch]=pattern_generate(model,width,height,etching_position1,etching_depth1,etching_position2,etching_depth2)

    model.param.set('width', num2str(width));
    model.param.set('height', num2str(height));
    model.param.set('etch_depth1', num2str(etching_depth1));
    model.param.set('etch_depth2', num2str(etching_depth2));

    if etching_depth1 ==0 || isempty(etching_position1)
        etching_depth1=[];
        etching_position1=[];    
    end
    if etching_depth2 ==0 || isempty(etching_position2)
        etching_depth2=[];
        etching_position2=[];    
    end

    n_etch1=length(etching_position1);
    n_etch2=length(etching_position2);
    n_etch=n_etch1+n_etch2;

    if n_etch1 ==0 && n_etch2 ==0
        etch_label=[];
        model.component('comp1').geom('geom1').run;
        model.component('comp1').geom('geom1').run('fin');
        return;
    end

    
    etching_position=[etching_position1 etching_position2];
    etching_depth=zeros(1,length(etching_position));
    etching_depth(1:length(etching_position1))=etching_depth1;
    etching_depth(length(etching_position1)+1:end)=etching_depth2;

     etch_label=strings(1,n_etch);
  
    
    for j=1:1:n_etch        
        model.component('comp1').geom('geom1').create(['etch' num2str(j)], 'Rectangle');
        model.component('comp1').geom('geom1').feature(['etch' num2str(j)]).label(['etch' num2str(j)]);
        model.component('comp1').geom('geom1').feature(['etch' num2str(j)]).set('pos', {num2str(-(width)/2+(2*etching_position(j)-1)*25e-9) num2str(height/2-etching_depth(j)/2+(height-1e-6)/2)});
        model.component('comp1').geom('geom1').feature(['etch' num2str(j)]).set('base', 'center');
        model.component('comp1').geom('geom1').feature(['etch' num2str(j)]).set('size', {'50 [nm]' num2str(etching_depth(j))});
        etch_label(j)=['etch' num2str(j)];
    end



    model.component('comp1').geom('geom1').create('dif1', 'Difference');
    model.component('comp1').geom('geom1').feature('dif1').label('core silicon');
    model.component('comp1').geom('geom1').feature('dif1').set('intbnd', false);
    model.component('comp1').geom('geom1').feature('dif1').selection('input').set({'r30'});
    model.component('comp1').geom('geom1').feature('dif1').selection('input2').set(etch_label);

    model.component('comp1').geom('geom1').create('dif2', 'Difference');
    model.component('comp1').geom('geom1').feature('dif2').label('air cladding');
    model.component('comp1').geom('geom1').feature('dif2').set('keepsubtract', true);
    model.component('comp1').geom('geom1').feature('dif2').set('intbnd', false);
    model.component('comp1').geom('geom1').feature('dif2').selection('input').set({'r24'});
    model.component('comp1').geom('geom1').feature('dif2').selection('input2').set({'dif1'});

    model.component('comp1').geom('geom1').run;
    model.component('comp1').geom('geom1').run('fin');
end