function r1 = merge_result(r1,r2)
% merge two structure data
F = fieldnames(r2);

                for j = 1:length(F)

                    if strcmp(F{j}, 'state')
                        r1.(F{j}) = state_copy(r2.(F{j}));
                    else
                        r1.(F{j}) = r2.(F{j});
                    end

                end
end