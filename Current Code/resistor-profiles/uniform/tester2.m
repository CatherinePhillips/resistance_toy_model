% Overlay a few curves with different resistivity profiles.
figure;
cols = {'red', 'green', 'blue', 'cyan', 'magenta', 'yellow', 'black', 'white'};
idx = 1: 4;
for i = idx
    errorbar(H, R(:,i), Rdev(:,i), 'ko', 'MarkerFaceColor', cols{(i-idx(1))/(idx(2)-idx(1))+1}, ...
        'LineWidth', 1)
    hold on
end
xlabel('$H\ (T)$')
ylabel('$R/R_0$')
title('Resistance with varying uniform resistivities')
legend(strcat('$\bar{\rho}=$', string(rmean(idx)), '$\ \Omega\cdot m$'))
ylim([1 30])

% Terminal slope plot.
figure;
scatter(rmean, lines(1,:), 'filled')
xlabel('$\bar{\rho}\ (\Omega\cdot m)$')
ylabel('$\Delta \tilde{R}/\Delta H\ (T^{-1})$')
title('Uniform Terminal MR Slope')
% ylim([0.75 1.25])