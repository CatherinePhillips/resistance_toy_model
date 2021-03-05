syms H mu;
syms v i [1 4];
syms r_in;
syms Z [4 4];
syms Y [4 4];
Y = [0, -1,  0,  1;
     1,  0, -1,  0;
     0,  1,  0, -1;
    -1,  0,  1,  0];
Z = r_in * (eye(4) + sym(1/2) * H * mu * Y);


