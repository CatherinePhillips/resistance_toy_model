%M and N are the dimensions of the matrix
M = 5;
N = 5;
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

%experimenting with different types of randomness
%r_base is boring, all ones
r_base = ones(M,N);
%r_random is pure random number generator between 0 and 2, so also average 1
r_random = 2*rand(M,N);
%r_hgrad is a gradient across the horizontal axis
%r_vgrad is a gradient along the vertical axis
%r_neighbor is r_random with nearest neighbor interpolation 
%k_neighbor dictates the strength of the interaction
%r_patches is r_random overlaid with another, larger random pattern

%use logical masking to set the superconducting bits
r_random(Tc_random < T) = 0.001;

%comparison graphs 
x_base = expanded_resistance_function(M, N, H, mu, phi, V, n_max, r_base);
resistance_visualization(M, N, x_base, r_base, Tc_base, 1, 1, 0, 0);

x_random = expanded_resistance_function(M, N, H, mu, phi, V, n_max, r_random);
resistance_visualization(M, N, x_random, r_random, Tc_random, 1, 1, 0, 0);
resistance_visualization(M, N, x_random - x_base, r_random, Tc_random, 1, 0, 1, 1);

%x_magnet = expanded_resistance_function(M, N, 1, mu, phi, V, n_max, r_base);
%resistance_visualization(M, N, x_magnet, r_base, 1, 1, 0);
%resistance_visualization(M, N, x_magnet - x_base, r_base, 1, 0, 1);