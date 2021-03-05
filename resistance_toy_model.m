clear all;

%initializing variables 
%H is magnetic field strength
%mu is carrier mobility
%V is the voltage we're applying 
syms H mu V;
%r1-4 are the resistivities of each disk
syms r1 r2 r3 r4;

%DELETE LATER
%set everything to 1 so it's happy
H = 1;
mu = 1;
r1 = 1;
r2 = 2;
r3 = 3;
r4 = 4;

%v_ab is the voltage in the ath disk at the bth position
%i_ab is analogous
syms v i [4 4];
%Z is our impedence matrix that relates v and i 
syms Z [4 4];
%here we're creating a matrix out of the r values we made earlier
syms r_in [4 4];
r_in = [r1, r1, r1, r1;
        r2, r2, r2, r2;
        r3, r3, r3, r3;
        r4, r4, r4, r4];
%this matrix is blatantly stolen from Hu, Parish, et al.
syms Y [4 4];
Y = [0, -1,  0,  1;
     1,  0, -1,  0;
     0,  1,  0, -1;
    -1,  0,  1,  0];

%equations is the system of equations that we'll solve
syms equations [32 32]; 
equations(1:32, 1:32) = sym(0);
syms b [32 1];
b(1:32, 1) = sym(0);
b(29:30, 1) = V;


%create our impedence matrix 
%follows formula in Hu, Parish, et al.
Z = r_in .* (sym(eye(4)) + sym(1/2) * H * mu * Y);
%sanity check that this equation is true and v gives happy numbers
v = Z * i.';
v;

%start filling our system of equations to solve
%the first part will be this same v = Z*i but now in matrix form
%fills rows 1-16
equations(1:16, 1:16) = eye(16);
equations(1:4, 17:20) = Z;
equations(5:8, 21:24) = Z;
equations(9:12, 25:28) = Z;
equations(13:16, 29:32) = Z;

%next we'll do everything that's the same 
%fills rows 17-24
%v1_3 and v2_1
equations(17, 3) = 1;
equations(17, 5) = -1;
%i1_3 and i2_1
equations(18, 16+3) = 1;
equations(18, 16+5) = 1;
%v1_4 and v3_2
equations(19, 4) = 1;
equations(19, 10) = -1;
%i1_4 and i3_2 
equations(20, 16+4) = 1;
equations(20, 16+10) = 1;
%v2_4 and v4_2
equations(21, 8) = 1;
equations(21, 14) = -1;
%i2_4 and i4_2
equations(22, 16+8) = 1;
equations(22, 16+14) = 1;
%v3_3 and v4_1
equations(23, 11) = 1;
equations(23, 13) = -1;
%i3_3 and i4_1
equations(24, 16+11) = 1;
equations(24, 16+13) = 1;

%now the boundary conditions
%i_12 = 0
equations(25, 16+2) = 1;
%i_22 = 0
equations(26, 16+6) = 1;
%i_34 = 0
equations(27, 16+12) = 1;
%i_44 = 0
equations(28, 16+16) = 1;

%these correspond w/ lines 29 + 30 in b 
%IF YOU CHANGE THESE ROWS CHANGE THAT TOO
%v_11 = V
equations(29, 1) = 1; 
%v_31 = V
equations(30, 9) = 1;

%kirchoff loop rule
%v_14 + v_13 + v_41 + v_42 = 0
equations(31, 3) = 1;
equations(31, 4) = 1;
equations(31, 13) = 1;
equations(31, 14) = 1;

%attempt to solve the system of equations 
x = linsolve(equations, b);
x

% v1_1 = V;
% v2_1 = V; 
% i1_2 = 0;
% i2_2 = 0;
% i3_4 = 0;
% i4_4 = 0;
% v1_3 + v1_4 + v4_1 + v4_2 = 0;
% i1_1 + i1_2 + i1_3 + i1_4 = 0;


