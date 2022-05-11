% M and N are the dimensions of the matrix
N = 4:4:12;
% H and mu are magnetic field strength and carrier mobility
H = 0:1:15;
H_len = length(H);
% Applied voltage.
Vapp = -1;

cols = {'red', 'green', 'blue', 'cyan', 'magenta', 'yellow', 'black', 'white'};

figure;
for i = 1: length(N)
    n = N(i)
    rand_res = 10*ones(n, n);
    magnetoresistance(n, n, Vapp, H, rand_res, 1, cols{i});
    hold on
end
legend(strcat('$N = ', string(N), '$'))