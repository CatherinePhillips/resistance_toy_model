%overall function to call
%returns the resistivity matrix (hopefully)
function output = resistance_laplace_solver(phi, rho, beta, nMax)
output = contacts(phi, rho, beta, nMax);
output
end

%S matrix as given by Parish
function S_ = S(phi, n)
    S_ = [2*sin(n*phi/2);
        sin(n*pi/2 + n * phi/2) - sin(n *pi/2 - n *phi/2);
        sin(n *pi + n *phi/2) - sin(n *pi - n *phi/2);
        sin(3*n*pi/2 + n *phi/2) - sin(3*n*pi/2 - n *phi/2)];
end 

%T matrix as given by Parish 
function T_ = T(phi, n) 
    T_ = [0;
         cos(n*pi/2 - n*phi/2) - cos(n*pi/2 + n*phi/2);
        0;
        cos(3*n*pi/2 - n *phi /2) - cos(3*n*pi/2 + n *phi/2)];
end

%U combines S and T matrices, does only for one n at a time though
function U_ = U(phi, rho, beta, theta, n)
U_ = 1/(n.^2) * (rho / (pi * phi)) * ((S(phi, n) - beta * T(phi, n)) * cos(n * theta)... 
+ (T(phi, n) + beta*S(phi, n))* sin(n * theta));
end

%sums up all the U matrices for n from 1 to nMax
function bigU_ = bigU(phi, rho, beta, theta, nMax)
n_list = 1:nMax;
%anonymous function matlab magic from matlab answers question
bigU_ = sum(cell2mat(arrayfun(@(z)U(phi, rho, beta, theta, z), ...
n_list, 'UniformOutput', false)),2);
end

%finds the values for bigU specifically at the contacts 
function contacts_ = contacts(phi, rho, beta, nMax)
contacts_ = [bigU(phi, rho, beta, 0, nMax) - bigU(phi, rho, beta, 3*pi/2, nMax),...
            bigU(phi, rho, beta, pi/2, nMax) - bigU(phi, rho, beta, 0, nMax), ...
            bigU(phi, rho, beta, pi, nMax) - bigU(phi, rho, beta, pi/2, nMax), ...
            bigU(phi, rho, beta, 3*pi/2, nMax) - bigU(phi, rho, beta, pi, nMax)];
end