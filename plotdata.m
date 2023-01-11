plottime = logger.Data.t(1:kei,1);
hold on
grid on
yticks(0:0.2:1.5)
plot(plottime,tend)
xlabel("t [s]");
ylabel("computation time [s]");
hold off