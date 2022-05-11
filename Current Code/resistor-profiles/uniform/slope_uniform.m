% M and N are the dimensions of the matrix
M = 8;
N = 8;
% H and mu are magnetic field strength and carrier mobility
H = 0:2:40;
H_len = length(H);
% Applied voltage.
Vapp = -1;

% Upper bound for random resistivity.
rmean = 1:1:10;
% Span of distribution.
span = 1;

% Number of iterations per upper bound to account for stochasticity.
num_ite = 10;

% Resistances over different resistivities.
R = zeros(H_len, length(rmean));
Rdev = zeros(H_len, length(rmean));
% Resistivity profiles.
rdist = zeros(M*N*num_ite, length(rmean));

% Terminal lines.
lines = zeros(2, length(rmean));

for i = 1: length(rmean)
    [R(:,i), Rdev(:,i), rdist(:,i), lines(:,i)] = uniform_gen(M, N, H, Vapp, rmean(i), num_ite, span);
end

% Overlay a few curves with different resistivity profiles.
figure;
cols = {'red', 'green', 'blue', 'cyan', 'magenta', 'yellow', 'black', 'white'};
idx = 1: 2: 7;
for i = idx
    errorbar(H, R(:,i), Rdev(:,i), 'ko', 'MarkerFaceColor', cols{(i-idx(1))/(idx(2)-idx(1))+1}, ...
        'LineWidth', 1)
    hold on
end
xlabel('$H\ (T)$')
ylabel('$R/R_0$')
title('Resistance with varying uniform resistivities')
legend(strcat('$\bar{\rho}=$', string(rmean(idx)), '$\ \Omega\cdot m$'))

% Terminal slope plot.
figure;
scatter(rmean, lines(1,:), 'filled')
xlabel('$\bar{\rho}\ (\Omega\cdot m)$')
ylabel('$\Delta \tilde{R}/\Delta H\ (T^{-1})$')
title('Uniform Terminal MR Slope')