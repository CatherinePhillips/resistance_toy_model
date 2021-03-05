clear all;
syms H mu V;
syms v i [4 4];
syms r_in [1 4];
r_in = [1, 1, 1, 1];
syms Z [4 4 4];
syms Y [4 4];
Y = [0, -1,  0,  1;
     1,  0, -1,  0;
     0,  1,  0, -1;
    -1,  0,  1,  0];
Z = r_in * (eye(4) + sym(1/2) * H * mu * Y);

v1_1 = V;
v2_1 = V; 
v1_2 = 0;
v2_2 = 0;
v3_4 = 0;
v4_4 = 0;
