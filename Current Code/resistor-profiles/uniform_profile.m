% M and N are the dimensions of the matrix
M = 8;
N = 8;
% H and mu are magnetic field strength and carrier mobility
H = 0:2:40;
H_len = length(H);
% Applied voltage.
Vapp = -1;

% Upper bound for random resistivity.
ubound = 1: 10;
% Number of iterations per upper bound to account for stochasticity.
num_ite = 10;

% Resistances over different resistivities.
R = zeros(H_len, length(ubound), num_ite);
R_dev = zeros(H_len, length(ubound), num_ite);

% Random resistivity profiles stored.
res = zeros(M, N, length(ubound), num_ite);

plot_trials = 0;

for i = 1: size(ubound, 2)
    for k = 1: num_ite
        % Generate random resistivity profile.
        rand_res = rand([M N])*ubound(i);
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
            title(sprintf('Uniform random resistivity $\\rho=%f$', ubound(i)))
            disp('----------------------------')
            fprintf('Resistivity bound: %f\n', ubound(i))
            pause
        end
    end
end

% Average over trials.
Rave = mean(R, 3);
% Variation in different trials.
R_var = std(R, 0, 3);

% % Plot the averaged random profiles for a given random bound.
% idx = 5;
% res_profile = reshape(res(:,:,idx,:), 1, []);
% figure;
% histogram(res_profile, 10, 'Normalization', 'pdf')
% xlabel('Random resistivity $\rho$')
% ylabel('Probability Density')
% title(sprintf('Random resistivity distribution for $\\bar{\\rho}=%.2f$', ubound(idx)/2))

% Overlay a few curves with different resistivity profiles.
figure;
% max_disp = 3;
cols = {'red', 'green', 'blue', 'cyan', 'magenta', 'yellow', 'black', 'white'};
idx = 1: 2: 9;
for i = idx
    errorbar(H, Rave(:,i), R_var(:,i), 'ko', 'MarkerFaceColor', cols{(i-idx(1))/(idx(2)-idx(1))+1}, ...
        'LineWidth', 1)
    hold on
end
xlabel('$H\ (T)$')
ylabel('$R/R_0$')
title('Resistance with varying uniform resistivity bound')
legend(strcat('$\bar{\rho}=$', string(ubound(idx)/2), '$\Omega\dot m$'))

% rsq = zeros(1, length(ubound));
% % Fit quadratic curves.
% for i = 1: length(ubound)
%     Ri = Rave(:,i);
%     q = polyfit(H, Ri, 2);
%     q = @(h) q(1)*h.^2 + q(2)*h + q(3);
%     rsq(i) = cor(q(H), Ri);
% end
% 
% figure;
% scatter(ubound, rsq, 'filled', 'r')
% xlabel('Uniform resistivity bound')
% ylabel('Corr')
% title('$R^2$ for quadraticity')
