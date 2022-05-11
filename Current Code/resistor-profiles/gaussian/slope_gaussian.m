% M and N are the dimensions of the matrix
M = 8;
N = 8;
% H and mu are magnetic field strength and carrier mobility
H = 0:2:40;
H_len = length(H);
% Applied voltage.
Vapp = -1;



%%%%%%%%%%%%%%% Varying mean resistivity %%%%%%%%%%%%%%%
rdev = 0.5;
rmean = 1: 10;

% Number of random iterations to account for stochasticity.
num_ite = 10;

% Resistances over different resistivities.
R = zeros(H_len, length(rmean));
Rdev = zeros(H_len, length(rmean));
% Resistivity profiles.
rdist = zeros(M*N*num_ite, length(rmean));

% Terminal lines.
lines = zeros(2, length(rmean));

for i = 1: length(rmean)
    [R(:,i), Rdev(:,i), rdist(:,i), lines(:,i)] = gaussian_gen(M, N, H, Vapp, rmean(i), rdev, num_ite);
end

% Plot the averaged random profiles for a given random bound.
idx = 2;
figure;
histogram(rdist(:,idx), 20, 'Normalization', 'pdf')
xlabel('Random resistivity $\rho$')
ylabel('Probability density')
title(sprintf('Random resistivity distribution for $\\bar{\\rho}=%.2f$, $\\Delta\\rho = %.2f$', ...
    rmean(idx), rdev))

% Overlay a few curves with different resistivity profiles.
figure;
max_rmean_disp = 4;
for i = 1: max_rmean_disp
    errorbar(H, R(:,i), Rdev(:,i), 'ko', 'MarkerFaceColor', cols{i}, 'LineWidth', 1)
    hold on
end
xlabel('$H\ (T)$')
ylabel('$R/R_0$')
title(sprintf('Varying mean resistivity. $\\Delta\\rho=%.2f$', rdev))
legend(strcat('$\bar{\rho}=', string(rmean(1:max_rmean_disp)), '\ \Omega\cdot m$'))

% Terminal slope plot.
figure;
scatter(rmean, lines(1,:), 'filled')
xlabel('$\bar{\rho}\ (\Omega\cdot m)$')
ylabel('$\Delta \tilde{R}/\Delta H\ (T^{-1})$')
title('Terminal MR Slope')