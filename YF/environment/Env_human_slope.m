function env = Env_human_slope(id,FieldType)
%% environment class demo
%道のりを作るための関数
%2つ以上の通路の組み合わせを前提にしているから2つ以上の通路を作成

if strcmp(FieldType,'Like H')
env.param.load.txt = 'Like H';
vertices = {[-.5 0;.5 0;.5 6.5;-.5 6.5];...
            [-.5 10;.5 10;.5 6.5;-.5 6.5];...
            [-0.5 6;-.5 7;3.5 7;3.5 6];...
            [2.5 6.5;2.5 0;3.5 0;3.5 6.5];...
            [2.5 6.5;2.5 10;3.5 10;3.5 6.5]};
elseif strcmp(FieldType,'Like 6')     
env.param.load.txt = 'Like 6';
vertices = {[0 0;1 0;1 5;0 5];...
            [0 4;0 10;1 10;1 4];...
            [0 4;0 5;5 5;5 4];...
            [4 5;5 5;5 0;4 0];...
            [5 0;5 1;0 1;0 0]};      
elseif strcmp(FieldType,'straight')
env.param.load.txt = 'straight';
vertices = {[0 8;0 0;6 0;6 8]};
elseif strcmp(FieldType,'TCU 2F')
env.param.load.txt = 'TCU 2F';
vertices = func_TCU1();
elseif strcmp(FieldType,'8widths straight')
env.param.load.txt = '8widths straight';
vertices = strighat8();  
elseif strcmp(FieldType,'3widths straight')
env.param.load.txt = '3widths straight';
vertices = strighat3();  
elseif strcmp(FieldType,'2widths straight')
env.param.load.txt = '2widths straight';
vertices = strighat2(); 
elseif strcmp(FieldType,'十字路')
env.param.load.txt = '十字路';
vertices = CrossStreet(); 
end
env.param.load.poly = polyshape(vertices{1});
MoveFeald = cell(length(vertices),1);
baffa = -0.2;
aaaa = env.param.load.poly;
MoveFeald{1} = aaaa.Vertices;
for i =2:length(vertices)
    tmp = polyshape(vertices{i});
    env.param.load.poly = union(env.param.load.poly,polyshape(vertices{i}));
    aaaa = tmp;
    MoveFeald{i} = aaaa.Vertices;
end
env.param.load.spone_area = polybuffer(env.param.load.poly,-0.3);



    env.param.load.vertices = MoveFeald;
    env.name = "huma_load";
    env.type = "huma_load_sim";
    env.param.id=id;
    disp(env.param.load.txt);
    
    figure(90)
    hold on;grid on;
    for i=1:length(vertices)
        plot(polyshape(vertices{i}(:,1),vertices{i}(:,2)));
        [x,y] = centroid(polyshape(vertices{i}(:,1),vertices{i}(:,2))); 
        plot(x,y,'r:*');
        text(x,y,num2str(i),'FontSize',14)
    end
    axis equal
    
end
function result = func_TCU1()

result = {[1 0.;1 6.4;3 6.4;3 0.];...
         [1 3.9;1 10.;3 10.;3 3.9];...
         [1 4;1 6;4 6;4 4];...
         [1 0;6.4 0;6.4 2.;1 2.];...
         [4.6 0;10.2 0;10.2 2.;4.6 2.];...
         [8.6 0;14.2 0;14.2 2.;8.6 2.];...
         [12.6 0;18 0;18 2.;12.6 2.];...
         [16 0;18 0;18 6.2;16 6.2];...
         [1 10;6.2 10;6.2 8;1 8];...
         [4.8 10;10.2 10;10.2 8;4.8 8];...
         [8.8 10;14.2 10;14.2 8;8.8 8];...
         [13 10;18 10;18 8;13 8];...
         [16 10;18 10;18 3.8;16 3.8];...
         [18 4;18 6;15 6;15 4];...
         [5 2.;6 2.;6 -3;5 -3];...
         [9 2.;10 2.;10 -3;9 -3];...
         [14 2.;13 2.;13 -3;14 -3];...
         [6 8;5 8;5 13;6 13];...
         [10 8;9 8;9 13;10 13];...
         [14 8;13 8;13 13;14 13]};
end
function result = strighat8()
result = {[1 0;1 60;9 60;9 0]};
end
function result = strighat3()
result = {[0 0;0 20;4 20;4 0]};
end
function result = strighat2()
result = {[0 0;0 6;2 6;2 0]};
end
function result = CrossStreet()
result = {[-6 6;-6 10;10 10;10 6];...
         [6 -6;6 10;10 10;10 -6];...
         [6 21;6 6;10 6;10 21];...
         [6 6;6 10;22 10;22 6]};

end