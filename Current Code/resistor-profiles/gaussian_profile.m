% M and N are the dimensions of the matrix
M = 8;
N = 8;
% H and mu are magnetic field strength and carrier mobility
H = 0:2:40;
H_len = length(H);
% Applied voltage.
Vapp = -1;

% Number of random iterations to account for stochasticity.
num_ite = 10;
% Colors for plotting.
cols = {'red', 'green', 'blue', 'cyan', 'magenta', 'yellow', 'black', 'white'};
%%%%%%%%%%%%%%% Varying mean resistivity %%%%%%%%%%%%%%%
mean_res = true;
if mean_res
    rdev = 0.5;
    rmean = 1: 4;
    % Random resistivity profiles stored.
    res_m = zeros(M, N, length(rmean), num_ite);
    
    % Resistances over different mean resistivities.
    Rm = zeros(H_len, length(rmean), num_ite);
    Rm_dev = zeros(H_len, length(rmean), num_ite);
    
    plot_mean = 0;
    for i = 1: length(rmean)
        for k = 1: num_ite
            % Generate random resistivity profile.
            rand_res = random('Normal', rmean(i), rdev, M, N);
            rand_res(rand_res < 0) = 0.001;
            res_m(:,:,i,k) = rand_res;
            % Normalized magnetoresistance profile.
            [~, ~, Rm(:,i,k), Rm_dev(:,i,k)] = magnetoresistance(M, N, Vapp, H, rand_res, plot_mean);
            if plot_mean
                figure;
                [x, y] = meshgrid(1:N, 1:M);
                scatter(x(:), y(:), M^(3), rand_res(:), 'filled')
                xlim([-N/4 5*N/4])
                ylim([-M/4 5*M/4])
                colorbar
                title(sprintf('Gaussian random resistivity $\\rho=%.2f$, $\\Delta\\rho=%.2f$', rmean(i), rdev))
                disp('----------------------------')
                fprintf('Mean resistivity: %f\n', rmean(i))
                fprintf('Standard deviation: %f\n', rdev)
                pause
            end
        end
    end
    
    % Average over trials.
    Rm_ave = mean(Rm, 3);
    % Variation in different trials.
    Rm_var = std(Rm, 0, 3);
    
    % Plot the averaged random profiles for a given random bound.
    idx = 2;
    resm_profile = reshape(res_m(:,:,idx,:), 1, []);
    figure;
    histogram(resm_profile, 20, 'Normalization', 'pdf')
    xlabel('Random resistivity $\rho$')
    ylabel('Probability density')
    title(sprintf('Random resistivity distribution for $\\bar{\\rho}=%.2f$, $\\Delta\\rho = %.2f$', ...
        rmean(idx), rdev))
    
    % Overlay a few curves with different resistivity profiles.
    figure;
    max_rmean_disp = 3;
    for i = 1: max_rmean_disp
        errorbar(H, Rm_ave(:,i), Rm_var(:,i), 'ko', 'MarkerFaceColor', cols{i}, 'LineWidth', 1)
        hold on
    end
    xlabel('$H$ (T)')
    ylabel('$R$')
    title(sprintf('Varying mean resistivity. $\\Delta\\rho=%.2f$', rdev))
    legend(strcat('$\bar{\rho}=$', string(rmean(1:max_rmean_disp))))
end


%%%%%%%%%%%%%%%%% Varying variance %%%%%%%%%%%%%%%
var_res = false;
if var_res
    % H and mu are magnetic field strength and carrier mobility
    H = 0:1:30;
    H_len = length(H);
    
    rmean = 10;
    rdev = 1:4;
    % Random resistivity profiles stored.
    res_d = zeros(M, N, length(rdev), num_ite);
    % Resistances over different deviations.
    Rd = zeros(H_len, length(rmean), num_ite);
    Rd_dev = zeros(H_len, length(rmean), num_ite);
    
    plot_dev = 0;
    for i = 1: length(rdev)
        for k = 1: num_ite
            % Generate random resistivity profile.
            rand_res = random('Normal', rmean, rdev(i), M, N);
            rand_res(rand_res < 0) = 0.001;
            res_d(:,:,i,k) = rand_res;
            % Normalized magnetoresistance profile.
            [~, ~, Rd(:,i,k), Rd_dev(:,i,k)] = magnetoresistance(M, N, Vapp, H, rand_res, plot_dev);
            if plot_dev
                figure;
                [x, y] = meshgrid(1:N, 1:M);
                scatter(x(:), y(:), M^(3.7), rand_res(:), 'filled')
                xlim([-N/4 5*N/4])
                ylim([-M/4 5*M/4])
                colorbar
                title(sprintf('Gaussian random resistivity $\\rho=%.2f$, $\\Delta\\rho=%.2f$', rmean, rdev(i)))
                disp('----------------------------')
                fprintf('Mean resistivity: %f\n', rmean)
                fprintf('Standard deviation: %f\n', rdev(i))
            end
        end
    end
    
    % Average over trials.
    Rd_ave = mean(Rd, 3);
    % Variation in different trials.
    Rd_var = std(Rd, 0, 3);
    
    % Plot the averaged random profiles for a given random bound.
    idx = 2;
    resd_profile = reshape(res_d(:,:,idx,:), 1, []);
    figure;
    histogram(resd_profile, 20, 'Normalization', 'pdf')
    xlabel('Random resistivity $\rho$')
    ylabel('Probability density')
    title(sprintf('Random resistivity distribution for $\\bar{\\rho}=%.2f$, $\\Delta\\rho = %.2f$', ...
        rmean, rdev(idx)))
    
    % Magnetoresistance profiles.
    figure;
    % Make a uniform distribution for baseline comparison.
    [Ru, Rdu, rdistu] = uniform_gen(M, N, H, Vapp, rmean*2, num_ite);
    scatter(H, Ru, 'ko', 'MarkerFaceColor', 'red', 'LineWidth', 1)
    hold on
    
    max_rdev_disp = 4;
    for i = 1: max_rdev_disp
        scatter(H, Rd_ave(:,i), 'ko', 'MarkerFaceColor', cols{i+1}, 'LineWidth', 1)
        hold on
    end
    xlabel('$H$ (T)')
    ylabel('$R/R_0$')
    title(sprintf('Mean magnetoresistance of Gaussian profiles: $\\bar{\\rho}=%.2f$', rmean))
    legend(['uniform distribution', strcat('$\Delta \rho=$', string(rdev(1:max_rdev_disp)))])
    
    % Plot stochastic deviations.
    figure;
    % Make a uniform distribution for baseline comparison.
    scatter(H, Rdu, 'ko', 'MarkerFaceColor', 'red', 'LineWidth', 1)
    hold on
    
    max_rdev_disp = 4;
    for i = 1: max_rdev_disp
        scatter(H, Rd_var(:,i), 'ko', 'MarkerFaceColor', cols{i+1}, 'LineWidth', 1)
        hold on
    end
    xlabel('$H$ (T)')
    ylabel('$\Delta(R/R_0)$')
    title(sprintf('Stochastic deviations of Gaussian profiles: $\\bar{\\rho}=%.2f$', rmean))
    legend(['uniform distribution', strcat('$\Delta \rho=$', string(rdev(1:max_rdev_disp)))])
end
