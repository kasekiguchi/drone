%% p_plot
close all
for i = 1:logger.k
    resultplot.eX(i) = logger.Data.agent.estimator.result{1,i}.state.p(1,1);
    resultplot.eY(i) = logger.Data.agent.estimator.result{1,i}.state.p(2,1);
    resultplot.eq(i) = logger.Data.agent.estimator.result{1,i}.state.q;
    if fExp
        resultplot.pX(i) = logger.Data.agent.plant.result{1,i}.state.p(1,1);
        resultplot.pY(i) = logger.Data.agent.plant.result{1,i}.state.p(2,1);
        resultplot.pq(i) = logger.Data.agent.plant.result{1,i}.state.q;
    end
    resultplot.rX(i) = logger.Data.agent.reference.result{1,i}.state.p(1,1);
    resultplot.rY(i) = logger.Data.agent.reference.result{1,i}.state.p(2,1);
    resultplot.rq(i) = logger.Data.agent.reference.result{1,i}.state.q;
    resultplot.input = logger.Data.agent.input{1,i};
    resultplot.input_v(i) = resultplot.input(1,1);
    resultplot.input_w(i) = resultplot.input(2,1);
end

figure(6);
hold on
grid on
plot(logger.Data.t(1:logger.k,1),resultplot.eq)
plot(logger.Data.t(1:logger.k,1),resultplot.rq)
if fExp
    plot(logger.Data.t(1:logger.k,1),resultplot.pq)
end
legend('eq','rq','pq','Location','northwest');
xlabel("time [s]");
ylabel("q[rad]");
hold off

figure(7)
hold on
grid on
plot(logger.Data.t(1:logger.k,1),resultplot.eX)
plot(logger.Data.t(1:logger.k,1),resultplot.eY)
plot(logger.Data.t(1:logger.k,1),resultplot.rX)
plot(logger.Data.t(1:logger.k,1),resultplot.rY)
if fExp
    plot(logger.Data.t(1:logger.k,1),resultplot.pX)
    plot(logger.Data.t(1:logger.k,1),resultplot.pY)
end
legend({'eX','eY','rX','rY','pX','pY'},'Location','northwest');
xlabel("time [s]");
ylabel("p [m]");
hold off


figure(8)
hold on 
grid on
plot(logger.Data.t(1:logger.k,1),resultplot.input_v)
plot(logger.Data.t(1:logger.k,1),resultplot.input_w)
legend('v','w');
xlabel("time [s]");
ylabel("input")
hold off

if fExp
figure(9)
hold on
grid on
resultplot.sum_x = 0;
for i = 1:logger.k
    resultplot.sa_X(i) = (resultplot.pX(1,i) - resultplot.eX(1,i))*(resultplot.pX(1,i) - resultplot.eX(1,i));
    resultplot.sum_x = resultplot.sum_x + resultplot.sa_X(i);
end
resultplot.N_x = (resultplot.sum_x/logger.k);
resultplot.RMSE_X = sqrt(resultplot.N_x);

resultplot.sum_y = 0;
for i = 1:logger.k
    resultplot.sa_Y(i) = (resultplot.pY(1,i) - resultplot.eY(1,i))*(resultplot.pY(1,i) - resultplot.eY(1,i));
    resultplot.sum_y = resultplot.sum_y + resultplot.sa_Y(i);
end
resultplot.N_y = (resultplot.sum_y/logger.k);
resultplot.RMSE_Y = sqrt(resultplot.N_y);

resultplot.sum_q = 0;
for i = 1:logger.k
    resultplot.sa_q(i) = (resultplot.pq(1,i) - resultplot.eq(1,i))*(resultplot.pq(1,i) - resultplot.eq(1,i));
    resultplot.sum_q = resultplot.sum_q + resultplot.sa_q(i);
end
resultplot.N_q = (resultplot.sum_q/logger.k);
resultplot.RMSE_q = sqrt(resultplot.N_q);

resultplot.RMSE = [resultplot.RMSE_X;resultplot.RMSE_Y;resultplot.RMSE_q];
label = categorical({'x','y','q'});
label = reordercats(label,{'x','y','q'});
bar(label,resultplot.RMSE)
ylabel("RMSE");
hold off
end
resultplot.max.x = max(resultplot.sa_X); 
resultplot.max.y = max(resultplot.sa_Y);
resultplot.max.q = max(resultplot.sa_q);

figure(10)
resultplot.estresult = logger.Data.agent.estimator.result{1,logger.k};
resultplot.Ewall = resultplot.estresult.map_param;
resultplot.Ewallx = reshape([resultplot.Ewall.x,NaN(size(resultplot.Ewall.x,1),1)]',3*size(resultplot.Ewall.x,1),1);
resultplot.Ewally = reshape([resultplot.Ewall.y,NaN(size(resultplot.Ewall.y,1),1)]',3*size(resultplot.Ewall.y,1),1);
hold on
grid on
plot(resultplot.Ewallx,resultplot.Ewally,'g-');
xlabel("$x$ [m]","Interpreter","latex");
ylabel("$y$ [m]","Interpreter","latex");
xlim([-4 12])
ylim([-4 12])
hold off