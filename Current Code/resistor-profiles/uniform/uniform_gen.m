function [R_ave, R_var, rdist, p] = uniform_gen(M, N, H, Vapp, rmean, num_ite, span)

if ~exist('span', 'var')
    span = rmean;
end

% Minimal resistivity.
rmin = rmean-span;

H_len = length(H);

% Random resistivity profiles stored.
res = zeros(M, N, num_ite);

% Resistances and edge variations.
R = zeros(H_len, num_ite);
R_dev = zeros(H_len, num_ite);

% Seed random.
rng(0)

for k = 1: num_ite
    % Generate random resistivity profile.
    rand_res = rmin + rand([M N])*2*span;
    res(:,:,k) = rand_res;
    % Normalized magnetoresistance profile.
    [~, ~, R(:,k), R_dev(:,k)] = magnetoresistance(M, N, Vapp, H, rand_res, 0);
end

% Average over trials.
R_ave = mean(R, 2);
% Variation in different trials.
R_var = std(R, 0, 2);
% Total frequency of random resistivity profile over all trials.
rdist = res(:);

% Compute terminal slopes.
end_points = 4;
Hter = H(end-end_points+1:end);
p = polyfit(Hter, R_ave(end-end_points+1:end), 1);
