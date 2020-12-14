function [SectionPlus] = SectionNumchange(X,Sectionpoint,Section_change)
%ãÊä‘ÇÃïœçXóp
    prev_sp = Sectionpoint(Section_change(1),:);%previous section
    now_sp = Sectionpoint(Section_change(2),:);%now section
    next_sp =  Sectionpoint(Section_change(3),:);%next section
    n_next_sp =  Sectionpoint(Section_change(4),:);%nextnext section
%      prev_r = cell2mat(arrayfun(@(L) abs(det([[prev_sp]-[now_sp];[X(1,L),X(5,L)]-[now_sp]]))/norm([prev_sp]-[now_sp]),1:params.Num,'UniformOutput',false));
%     now_r = cell2mat(arrayfun(@(L) abs(det([[now_sp]-[next_sp];[X(1,L),X(5,L)]-[next_sp]]))/norm([now_sp]-[next_sp]),1:params.Num,'UniformOutput',false));
%     next_r = cell2mat(arrayfun(@(L) abs(det([[next_sp]-[n_next_sp];[X(1,L),X(5,L)]-[n_next_sp]]))/norm([next_sp]-[n_next_sp]),1:params.Num,'UniformOutput',false));
    
    prev_r =abs(det([[prev_sp]-[now_sp];[X(1),X(2)]-[now_sp]]))/norm([prev_sp]-[now_sp]);
    now_r = abs(det([[now_sp]-[next_sp];[X(1),X(2)]-[next_sp]]))/norm([now_sp]-[next_sp]);
    next_r = abs(det([[next_sp]-[n_next_sp];[X(1),X(2)]-[n_next_sp]]))/norm([next_sp]-[n_next_sp]);
    [~,SectionPlus] = min([prev_r;now_r;next_r]);
%     params.Sectionnumber = cell2mat(arrayfun(@(N) params.Sectionnumber(N) + SectionPlus(N)-2,2:X.numbers-1,'UniformOutput',false));
%     for N = 1:X.numbers - 1
%         params.Sectionnumber(N) = params.Sectionnumber(N) + SectionPlus(N)-2;
%         if params.Sectionnumber(N) < 1
%             params.Sectionnumber(N) = 1;
%         end
%     end
end

