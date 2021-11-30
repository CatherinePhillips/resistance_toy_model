%calculates the v and i for a material given parameters with expected
%boundary conditions
%output: a 1 by 8*M*N matrix that contains all the voltages and then all
%the currents, going first around the circles clockwise from the left
%side, then left to right and top to bottom in rows

%input variables
%we want an M by N matrix
%H is magnetic field strength
%mu is carrier mobility
%V is the voltage we're applying 
%phi is the width of the contacts 
%n_max is how far we go into the taylor expansion
%r is the M by N resistance matrix
function x_out = expanded_resistance_function(M, N, H, mu, phi, V, n_max, r)
tic


%v_ab is the voltage in the ath disk at the bth position
%i_ab is analogous
% %Z is our impedence matrix that relates v and i 

%preallocating our arrays 
%equations is the system of equations that we'll solve
equations = zeros(M*N*8, M*N*8);
%b_ is the constants for matrix solving a la Ax=b
b_ = zeros(M*N*8, 1);
%turning r into a column vector
r_in = r(:);

%T changes from absolute to relative voltages 
%but is a bit weird - make sure that T and Z line up properly in which
%row is which 
T = [-1, 1, 0, 0;
     0, -1, 1, 0;
     0, 0, -1, 1;
     1, 0, 0, -1];

%start filling our system of equations to solve
%the first part will be this same v = Z*i but now in matrix form
%fills rows 1 : 4*M*N
for a = 1:M*N
equations((4*(a-1) + 1):(4*a), (4*(a-1) + 1):(4*a)) = T;
equations((4*(a-1) + 1):(4*a), (4*M*N + 4*(a-1) + 1):(4*M*N + 4*a)) ...
= ones(4,4) + resistance_laplace_solver(phi, r_in(a), H*mu, n_max);
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
    %entire right edge is at constant voltage V
    equations(8*M*N-M + a, 4*N*a-1) = 1;
end
%set that constant voltage V
b_(8*M*N-M+1:8*M*N, 1) = V;
%equations
%attempt to solve the system of equations 
x = linsolve(equations, b_);

%set our output
x_out = x;
toc 
end

