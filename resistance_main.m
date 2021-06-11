%M and N are the dimensions of the matrix
M = 6;
N = 6;
%H and mu are magnetic field strength and carrier mobility
H = 0;
mu = 1;
%V is the voltage we're applying 
%phi is the width of the contacts 
%n_max is how far we go into the taylor expansion
V = -1;
phi = 0.1;
n_max = 10;
%T is the temperature 
T = 4;
%Tc is a matrix of the critical temperatures for each node 
%can have different types of randomness on Tc too
Tc_base = 5*ones(M,N);
Tc_random = 10*rand(M,N);

%Tc_patches is Tc_random overlaid with another, larger random pattern
%TpatchSize is the size of the patches
%Tk_patches is how much the patches impact relative to the base randomness
TpatchSize = [2, 2];
Tk_patches = 0.7;
Tc_patchOverlay = 2*kron(rand(M/TpatchSize(1), N/TpatchSize(2)), ones(TpatchSize));
Tc_patches = (1 - Tk_patches) * Tc_random + Tk_patches * Tc_patchOverlay;



%experimenting with different types of randomness

%r_base is boring, all ones
r_base = ones(M,N);
%r_random is pure random number generator between 0 and 2, so also average 1
r_random = 2*rand(M,N);

%r_hgrad is a gradient across the horizontal axis
r_hgrad = reshape(mod((1:M*N) - 1,N) + 1, [M,N]);
%r_vgrad is a gradient along the vertical axis
r_vgrad = r_hgrad.';

%r_neighbor is r_random with nearest neighbor interpolation 
%k_neighbor dictates the strength of the interaction
%k = 1 means completely smoothed, 0 is completely random, 0.5 is 50/50
k_neighbor = 0.5;
%movmean and gaussian are both good options for the smoothing
r_smooth = smoothdata(smoothdata(r_random, 1, 'movmean', 3), 2, 'movmean', 3);
r_neighbor = (1 - k_neighbor) * r_random + k_neighbor * r_smooth;

%r_patches is r_random overlaid with another, larger random pattern
%patchSize is the size of the patches
%k_patches is how much the patches impact relative to the base randomness
patchSize = [2, 2];
k_patches = 0.7;
r_patchOverlay = 2*kron(rand(M/patchSize(1), N/patchSize(2)), ones(patchSize));
r_patches = (1 - k_patches) * r_random + k_patches * r_patchOverlay;

%use logical masking to set the superconducting bits
r_random(Tc_random < T) = 0.001;

%comparison graphs 
x_base = expanded_resistance_function(M, N, H, mu, phi, V, n_max, r_base);
resistance_visualization(M, N, x_base, r_base, Tc_base, 1, 1, 0, 0);

% x_random = expanded_resistance_function(M, N, H, mu, phi, V, n_max, r_random);
% resistance_visualization(M, N, x_random, r_random, Tc_random, 1, 1, 0, 0);
% resistance_visualization(M, N, x_random - x_base, r_random, Tc_random, 1, 0, 1, 1);

% x_vgrad = expanded_resistance_function(M, N, H, mu, phi, V, n_max, r_vgrad);
% resistance_visualization(M, N, x_vgrad, r_vgrad, Tc_base, 1, 1, 0, 0);
% resistance_visualization(M, N, x_vgrad - x_base, r_vgrad, Tc_base, 1, 0, 1, 0);

x_patches = expanded_resistance_function(M, N, H, mu, phi, V, n_max, r_patches);
resistance_visualization(M, N, x_patches, r_patchOverlay, Tc_base, 1, 1, 1, 0);
resistance_visualization(M, N, x_patches - x_base, r_patches, Tc_base, 1, 0, 1, 0);

%x_magnet = expanded_resistance_function(M, N, 1, mu, phi, V, n_max, r_base);
%resistance_visualization(M, N, x_magnet, r_base, 1, 1, 0);
%resistance_visualization(M, N, x_magnet - x_base, r_base, 1, 0, 1);