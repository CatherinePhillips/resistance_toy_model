% M and N are the dimensions of the matrix
M = 8;
N = 8;
% H and mu are magnetic field strength and carrier mobility
H = 0:2:40;
H_len = length(H);
% Applied voltage.
Vapp = -1;

% Number of stochastic iterations per resistivity generation.
num_ite = 10;

% Create a Gaussian profile.
rmean = 2;
rdev = 0.5;
[Rg, Rdg, gd] = gaussian_gen(M, N, H, Vapp, rmean, rdev, num_ite);
figure;
histogram(gd, 20, 'Normalization', 'pdf')
xl = xlim;
xlabel('$\bar{\rho}\ (\Omega\cdot m)$')
ylabel('Probability Density')
title(sprintf('Gaussian $\\bar{\\rho}=%.2f$, $\\Delta\\rho = %.2f$', rmean, rdev))

% Create a uniform random profile.
umean = 2;
span = 0.15;
[Ru, Rdu, ud] = uniform_gen(M, N, H, Vapp, umean, num_ite, span);
figure;
histogram(ud, 20, 'Normalization', 'pdf')
xlabel('$\bar{\rho}\ (\Omega\cdot m)$')
ylabel('Probability Density')
title(sprintf('Uniform $\\bar{\\rho}=%.2f$', umean))
xlim(xl)

cols = {'red', 'green', 'blue', 'cyan', 'magenta', 'yellow', 'black', 'white'};

% Overlay a few curves with different resistivity profiles.
figure;
errorbar(H, Rg, Rdg, 'ko', 'MarkerFaceColor', 'blue', 'LineWidth', 1)
% plot(H, Rg, 'b')
hold on
errorbar(H, Ru, Rdu, 'ko', 'MarkerFaceColor', 'red', 'LineWidth', 1)
% plot(H, Ru, 'r')
xlabel('$H$ (T)')
ylabel('$R/R_0$')
title('Magnetoresistance')
hold on

% Compute terminal slopes.
end_points = 4;
Hter = H(end-end_points+1:end);
pg = polyfit(Hter, Rg(end-end_points+1:end), 1);
pu = polyfit(Hter, Ru(end-end_points+1:end), 1);
[~,lg] = polyplot(pg, H, 'b');
hold on
[~,lu] = polyplot(pu, H, 'r');
ylim([1 max(Rg(end)+Rdg(end), Ru(end)+Rdu(end))])

legend({sprintf('Gaussian $\\bar{\\rho}=%.2f$, $\\Delta\\rho=%.2f$, $s=%.2f$', rmean, rdev, pg(1)), ...
    sprintf('uniform $\\Delta\\rho=%.2f$, $s=%.2f$', span, pu(1))})

% Plot stochastic deviations.
figure;
scatter(H, Rdu, 'filled', 'r')
hold on
scatter(H, Rdg, 'filled', 'b')
xlabel('$H\ (T)$')
ylabel('$\Delta(R/R_0)$')
title(sprintf('Stochastic deviation of resistivity: $\\bar{\\rho}=%.2f$', rmean))
legend({sprintf('uniform $\\Delta\\rho = %.2f$', span), sprintf('Gaussian $\\Delta\\rho = %.2f$', rdev)})
