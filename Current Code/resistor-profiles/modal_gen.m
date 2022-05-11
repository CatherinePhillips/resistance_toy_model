M, 
N, 
H, 
Vapp, 
rbound,
num_ite

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
    rand_res = rand([M N])*rbound;
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