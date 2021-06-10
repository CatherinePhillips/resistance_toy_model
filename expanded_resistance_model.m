clear all;
%initializing variables 
%H is magnetic field strength
%mu is carrier mobility
%V is the voltage we're applying 
tic
%syms H mu V;
%we want an M by N matrix
M = 4;
N = 4;
%syms r [M N];

%set everything to 1 so it's happy
H = 1;
mu = 1;
phi = 0.1;
%r(1:M, 1:N) = 1;
V = -1;
nMax = 10;

%v_ab is the voltage in the ath disk at the bth position
%i_ab is analogous
% syms v_ i_ [M*N 4];
% %Z is our impedence matrix that relates v and i 
% syms Z [4 4];
% 
% %here we're creating a matrix out of the r values we made earlier
% syms r_in [M*N 4];
% %preallocate the arrays for faster runtime
% r_in(1:M*N, 1:4) = 1;
% v_(1:M*N, 1:4) = sym(0);
% i_(1:M*N, 1:4) = sym(0);

r = ones(M,N) + 5*rand(M,N);
v_ = zeros(M*N, 4);
i_ = zeros(M*N, 4);
equations = zeros(M*N*8, M*N*8);
b_ = zeros(M*N*8, 1);
%black magic
r_in = r(:);

% %each row in this array corresponds to the resistance at a single node
% for a = 1:M
%     for b = 1:N
%         r_in(N * (a - 1) + b, 1:4) = r(a, b);
%     end
% end 

% %equations is the system of equations that we'll solve
% syms equations [M*N*8 M*N*8]; 
% equations(1:M*N*8, 1:M*N*8) = sym(0);
% %b is the constants for matrix solving a la Ax=b
% syms b_ [M*N*8 1];
% b_(1:M*N*8, 1) = sym(0);

%this matrix is blatantly stolen from Hu, Parish, et al.
Y = [0, -1,  0,  1;
     1,  0, -1,  0;
     0,  1,  0, -1;
    -1,  0,  1,  0];

%T changes from absolute to relative voltages 
T = [-1, 1, 0, 0;
     0, -1, 1, 0;
     0, 0, -1, 1;
     1, 0, 0, -1];

% Za = -0.35 + 3.14/4 * H * mu; 
% Zb = 0.35 + 3.14/4 * H * mu;
% Zc = 0.35 - 3.14/4 * H * mu;
% Zd = -0.35 - 3.14/4 * H * mu;
% Z = [Za, Zb, Zc, Zd; 
%     Zd, Za, Zb, Zc;
%     Zc, Zd, Za, Zb;
%     Zb, Zc, Zd, Za];
%create our impedence matrix 
%follows formula in Hu, Parish, et al.
%Z = sym(1/2) * (sym(eye(4)) + (sym(1/2) * H * mu * Y));
%sanity check that this equation is true and v gives happy numbers
%v_ = (r_in .* i_) * Z;
%v_;

Z_fourResistor = [7, -5, -1, 3;
                  3, 7, -5, -1;
                 -1, 3, 7, -5;
                 -5, -1, 3, 7];


%start filling our system of equations to solve
%the first part will be this same v = Z*i but now in matrix form
%fills rows 1 : 4*M*N
for a = 1:M*N
equations((4*(a-1) + 1):(4*a), (4*(a-1) + 1):(4*a)) = T;
equations((4*(a-1) + 1):(4*a), (4*M*N + 4*(a-1) + 1):(4*M*N + 4*a)) ...
= r_in(a) /pi * ones(4,4) + laplace(phi, r_in(a), H*mu, nMax);

end

%horizontal connections between nodes
%fills rows 4*M*N+1 : M*(6N-2)
for a = 1:M
    for b = 1:(N-1)
        %v equivalences
        equations(4*M*N + (N-1)*(a-1) + b, 4*(N*(a-1) + b - 1) + 3)  = 1;
        equations(4*M*N + (N-1)*(a-1) + b, 4*(N*(a-1) + b) + 1)  = -1;
        %i equivalences
        equations(M*(5*N-1) + (N-1)*(a-1) + b, 4*M*N + 4*(N*(a-1) + b - 1) + 3)  = 1;
        equations(M*(5*N-1) + (N-1)*(a-1) + b, 4*M*N + 4*(N*(a-1) + b) + 1)  = 1;
    end
end

%vertical connections between nodes
%fills rows M*(6N-2)+1 : 8M*N-2(M+N)
for a = 1:(M - 1)
    for b = 1:N
        %v equivalences
        equations(M*(6*N-2) + N*(a-1) + b, 4*(N*(a-1) + b))  = 1;
        equations(M*(6*N-2) + N*(a-1) + b, 4*(N*(a) + b - 1) + 2)  = -1;
        %i equivalences
        equations(7*M*N - 2*M - N + N*(a-1) + b, 4*M*N + 4*(N*(a-1) + b))  = 1;
        equations(7*M*N - 2*M - N + N*(a-1) + b, 4*M*N + 4*(N*(a) + b - 1) + 2)  = 1;
    end
end

%boundary conditions
%top + bottom edges
%fills 8*M*N-2M-2N+1 : 8*M*N - 2M
for a = 1:N
    %first row top current = 0
    equations(8*M*N-2*M-2*N + a, 4*M*N + 4*(a-1) + 2) = 1;
    %last row bottom current = 0
    equations(8*M*N-2*M-N + a, 4*M*N + 4*N*(M-1) + 4*a) = 1;
end

%left edge (input)
%fills 8*M*N-2M+1 : 8*M*N
for a = 1:M
    %entire left edge is grounded (v = 0)
    equations(8*M*N-2*M + a, 4*N*(a-1) + 1) = 1;
    %entire right edge is at constant voltage
    equations(8*M*N-M + a, 4*N*a-1) = 1;
end
b_(8*M*N-M+1:8*M*N, 1) = V;

disp("before solving");
equations;
%attempt to solve the system of equations 
x = linsolve(equations, b_);

disp("finished solving");
x;
%put the output in a form we can actually understand
for a = 1:M*N
    for b = 1:4
        v_(a, b) = x( 4 * (a-1) + b);
    end
end

for a = 1:M*N
    for b = 1:4
        i_(a, b) = x( 4*M*N + 4 * (a-1) + b);
    end
end

v_
i_

toc 

function Z_ = laplace(phi, rho, beta, nMax) 
Z_ = resistance_laplace_solver(phi, rho, beta, nMax);
end
