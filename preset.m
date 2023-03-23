%%% Boundaries and domains pre-set, 2 etching steps, Shumeng Wang

function preset(model)
%line integral-Moving boundary
index_core=mphselectbox(model,'geom1',[-5.1e-7 -5.1e-7;5.1e-7 5.1e-7]','boundary');
index_air=mphgetadj(model,'geom1','boundary','domain',4);
index_AlN1=mphgetadj(model,'geom1','boundary','domain',6);
index_AlN2=mphgetadj(model,'geom1','boundary','domain',3);
index_AlN3=mphselectbox(model,'geom1',[1.2e-6 -4.5e-7;1.7e-6 -11.5e-7]','boundary');

a=intersect(index_core,index_air);
b=intersect(index_AlN1,index_air);
c=intersect(index_AlN2,index_air);
d=intersect(index_AlN3,index_air);

boundaries=[a b c d];
model.component('comp1').cpl('intop3').selection.set(boundaries);

%surface integral-optical domain

model.component('comp1').cpl('intop1').selection.set((1:1:model.geom('geom1').getNDomains()));

%surface integral-mechanical domain

domain_core=mphselectbox(model,'geom1',[-5.1e-7 -5.1e-7;5.1e-7 5.1e-7]','domain');
domain_sub=mphselectbox(model,'geom1',[-1.66e-6 -4.9e-7; 1.66e-6 -2.22e-6]','domain');
model.component('comp1').cpl('intop2').selection.set([domain_core domain_sub]);

%surface integral-optical domain for the core

model.component('comp1').cpl('intop4').selection.set([domain_core]);

%surface integral-for nonlinear loss

domain1=mphselectbox(model,'geom1',[-1.66e-6 6.1e-7; 1.66e-6 -5.1e-7]','domain');
domain2=mphselectbox(model,'geom1',[-1.26e-6 -4.9e-7; 1.26e-6 -1.81e-6]','domain');

model.component('comp1').cpl('intop5').selection.set([domain1 domain2]);

%materials

model.component('comp1').material('mat1').selection.set([domain_core]);

%Electromagnetic Waves, Frequency Domain



%Solid Mechanics

model.component('comp1').physics('solid').selection.set([domain_core domain_sub]);

%Mesh
%Distribution 123
index_Distribution123=mphselectbox(model,'geom1',[-1.68e-6 -18.5e-7; -1.24e-6 -4.9e-7 ]','boundary');
index1_Distribution123=mphselectbox(model,'geom1',[1.24e-6 -4.9e-7; 1.66e-6 -1.81e-6 ]','boundary');
index_Distribution4=mphselectbox(model,'geom1',[-1.68e-6 -2.21e-6; 1.66e-6 -1.79e-6 ]','boundary');

model.component('comp1').mesh('mesh1').feature('map1').feature('dis1').selection.set([index_Distribution123(2) index_Distribution123(4) index_Distribution123(5) index1_Distribution123(2) index1_Distribution123(4) index1_Distribution123(5)]);
model.component('comp1').mesh('mesh1').feature('map1').feature('dis2').selection.set([index_Distribution123(3) index_Distribution123(7) index1_Distribution123(3) index1_Distribution123(7)]);
model.component('comp1').mesh('mesh1').feature('map1').feature('dis3').selection.set([index_Distribution123(1) index_Distribution123(6) index1_Distribution123(1) index1_Distribution123(6)]);
model.component('comp1').mesh('mesh1').feature('map1').feature('dis4').selection.set([index_Distribution4(1) index_Distribution4(6)]);
model.component('comp1').mesh('mesh1').feature('map1').feature('dis5').selection.set([index_Distribution4(4)]);

model.component('comp1').mesh('mesh1').feature('ftri1').selection.set([domain_core]);
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').selection.set([domain_core]);

model.component('comp1').mesh('mesh1').feature('ftri2').selection.set([domain2(2)]);
model.component('comp1').mesh('mesh1').feature('ftri3').selection.set([domain2(1) 4]);
end







