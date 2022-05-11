% M and N are the dimensions of the matrix
M = 8;
N = 8;
% H and mu are magnetic field strength and carrier mobility
H = 0:0.5:10;
H_len = length(H);
% Applied voltage.
Vapp = -1;

% Two modes.
r0 = 1;
% Vary the higher node.
r1 = 1:0.5:4;

% Number of iterations per upper bound to account for stochasticity.
num_ite = 5;

% Resistances over different resistivities.
R = zeros(H_len, length(r1), num_ite);
R_dev = zeros(H_len, length(r1), num_ite);

% Random resistivity profiles stored.
res = zeros(M, N, length(r1), num_ite);

plot_trials = 0;

for i = 1: length(r1)
    for k = 1: num_ite
        % Generate random resistivity profile.
        rand_res = round(rand([M N])+1);
        rand_res(rand_res==1) = -r0;
        rand_res(rand_res==2) = r1(i);
        rand_res(rand_res==-r0) = r0;
        res(:,:,i,k) = rand_res;
        % Normalized magnetoresistance profile.
        [~, ~, R(:,i,k), R_dev(:,i,k)] = magnetoresistance(M, N, Vapp, H, rand_res, plot_trials);
        if plot_trials
            figure;
            [x, y] = meshgrid(1:N, 1:M);
            scatter(x(:), y(:), M^3, rand_res(:), 'filled')
            xlim([-N/4 5*N/4])
            ylim([-M/4 5*M/4])
            colorbar
            title(sprintf('Bimodal random resistivity $\\rho_1=%.2f$, $\\rho_2=%.2f$', r0, r1(i)))
            pause
        end
    end
end

% Average over trials.
Rave = mean(R, 3);
% Variation in different trials.
R_var = std(R, 0, 3);

% Plot the averaged random profiles for a given random bound.
idx = 3;
res_profile = reshape(res(:,:,idx,:), 1, []);
figure;
histogram(res_profile, 100, 'Normalization', 'pdf')
xlabel('Random resistivity $\rho$')
ylabel('Probability Density')
title(sprintf('Bimodal distribution for $\\rho_1=%.2f$, $\\rho_2=%.2f$', r0, r1(idx)))

% Overlay a few curves with different resistivity profiles.
figure;
max_disp = 3;
cols = {'red', 'green', 'blue', 'cyan', 'magenta', 'yellow', 'black', 'white'};
for i = 1: max_disp
    errorbar(H, Rave(:,i), R_var(:,i), 'ko', 'MarkerFaceColor', cols{i}, 'LineWidth', 1)
    hold on
end
xlabel('$H$ (T)')
ylabel('$R$')
title(sprintf('Varying higher mode. $\\rho_1 = %.2f$', r0))
legend(strcat('$\rho_2=$', string(r1(1:max_disp))))
