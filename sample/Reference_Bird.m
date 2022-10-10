function Reference = Reference_Bird(Nb)
    %% reference class demo
    % reference property をReference classのインスタンス配列として定義
    clear Reference
    Reference.type = ["BIRD_MOVEMENT"];
    Reference.name = ["birdmove"];
    pos = linspace(0,2*pi,Nb);
    Reference.param = zeros(3,Nb);
    r = 0.5; % 群れのリーダーからの半径
    for i = 1:Nb
        Reference.param(:,i) = r*[cos(pos(i));sin(pos(i));0];
    end
end

