%% p_plot
for i = 1:logger.k
    eX(i) = logger.Data.agent.estimator.result{1,i}.state.p(1,1);
    eY(i) = logger.Data.agent.estimator.result{1,i}.state.p(2,1);
    eq(i) = logger.Data.agent.estimator.result{1,i}.state.q;
    pX(i) = logger.Data.agent.plant.result{1,i}.state.p(1,1);
    pY(i) = logger.Data.agent.plant.result{1,i}.state.p(1,2);
    pq(i) = logger.Data.agent.plant.result{1,i}.state.q;
    rX(i) = logger.Data.agent.reference.result{1,i}.state.p(1,1);
    rY(i) = logger.Data.agent.reference.result{1,i}.state.p(2,1);
    rq(i) = logger.Data.agent.reference.result{1,i}.state.q;
    input = logger.Data.agent.input{1,i};
    input_v(i) = input(1,1);
    input_w(i) = input(2,1);
end

figure(6);
hold on
grid on
plot(logger.Data.t(1:logger.k,1),eq);
plot(logger.Data.t(1:logger.k,1),pq);
plot(logger.Data.t(1:logger.k,1),rq);
legend('eq','pq','rq');
xlabel("time [s]");
ylabel("q");
hold off

figure(7)
hold on
grid on
plot(logger.Data.t(1:logger.k,1),eX);
plot(logger.Data.t(1:logger.k,1),eY);
plot(logger.Data.t(1:logger.k,1),pX);
plot(logger.Data.t(1:logger.k,1),pY);
plot(logger.Data.t(1:logger.k,1),rX);
plot(logger.Data.t(1:logger.k,1),rY);
legend({'eX','eY','pX','pY','rX','rY'},'Location','northwest');
xlabel("time [s]");
ylabel("p [m]");
hold off

figure(8)
hold on 
grid on
plot(logger.Data.t(1:logger.k,1),input_v);
plot(logger.Data.t(1:logger.k,1),input_w);
legend('v','w');
xlabel("time [s]");
ylabel("input")
hold off

figure(9)
hold on
grid on
sum_x = 0;
for i = 1:logger.k
    sa_X(i) = (pX(1,i) - eX(1,i))*(pX(1,i) - eX(1,i));
    sum_x = sum_x + sa_X(i);
end
N_x = (sum_x/logger.k);
RMSE_X = sqrt(N_x);

sum_y = 0;
for i = 1:logger.k
    sa_Y(i) = (pY(1,i) - eY(1,i))*(pY(1,i) - eY(1,i));
    sum_y = sum_y + sa_Y(i);
end
N_y = (sum_y/logger.k);
RMSE_Y = sqrt(N_y);

sum_q = 0;
for i = 1:logger.k
    sa_q(i) = (pq(1,i) - eq(1,i))*(pq(1,i) - eq(1,i));
    sum_q = sum_q + sa_q(i);
end
N_q = (sum_q/logger.k);
RMSE_q = sqrt(N_q);

RMSE = [RMSE_X;RMSE_Y;RMSE_q];
label = categorical({'x','y','q'});
label = reordercats(label,{'x','y','q'});
bar(label,RMSE)
ylabel("RMSE");
hold off