clc
disp(['P  ',num2str(diag(gui.agent.controller.mpc.weight(1:3,1:3))')])
disp(['Q  ',num2str(diag(gui.agent.controller.mpc.weight(4:6,4:6))')])
disp(['V  ',num2str(diag(gui.agent.controller.mpc.weight(7:9,7:9))')])
disp(['W  ',num2str(diag(gui.agent.controller.mpc.weight(10:12,10:12))')])
disp(['R  ',num2str(diag(gui.agent.controller.mpc.weightR)')])