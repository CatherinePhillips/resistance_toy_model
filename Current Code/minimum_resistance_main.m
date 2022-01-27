%M and N are the dimensions of the matrix
M = 10;
N = 10;
%H and mu are magnetic field strength and carrier mobility
H = 0;
mu = 1;
r_factor = 1;
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

%r_base is boring, all ones
r_base = r_factor * ones(M,N);
%r_random is pure random number generator between 0 and 2, so also average 1
r_random = r_factor * random('Normal', 1, 1, M,N);


% Examples 

% base resistance visualization - voltage, current
%   x_random = expanded_resistance_function(M, N, H, mu, phi, V, n_max, r_random);
%   resistance_visualization(M, N, x_random, r_random, Tc_random, 1, 1, 0, 0);

% Tc visualization - comparative voltage, resistance, Tc 
%   resistance_visualization(M, N, x_random - x_base, r_random, Tc_random, 1, 0, 1, 1);

% creates movie for a 5x5
%  temperature_resistance_movie(M, N, 1, phi, V, n_max, 5, 5, 0, 2, 0.1, 1)

% creates longitudinal graph
%  transverse_resistance_visualization(M, N, 1, phi, V, n_max, r_base, 5, 5, 0, 0.2, 0.01, 0, 0, 1);

% creates transverse graph at 3 points - 3, 5, and 7 
%  transverse_resistance_visualization(M, N, 1, phi, V, n_max, r_random, [3,5,7], [3,5,7], -20, 20, 1, 1, 0);

% hall effect 
% x_magnet = expanded_resistance_function(M, N, 1, mu, phi, V, n_max, r_base);
% resistance_visualization(M, N, x_magnet, r_base, Tc_random, 1, 1, 0, 0);
% resistance_visualization(M, N, x_magnet - x_base, r_base, Tc_random, 1, 0, 1, 0);