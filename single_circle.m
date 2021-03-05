%initializing variables 
%H is magnetic field strength
%mu is carrier mobility
%V is the voltage we're applying 
syms H mu;
%v_a goes clockwise starting at the left, so it goes left, up, right, down
%i_a is analogous
syms v i [4 1];
%r_in is the resistivity of the disk
syms r_in;
%Z is our impedence matrix that relates v and i
syms Z [4 4];
%this matrix is blatantly stolen from Hu, Parish, et al.
syms Y [4 4];
Y = [0, -1,  0,  1;
     1,  0, -1,  0;
     0,  1,  0, -1;
    -1,  0,  1,  0];

%create our impedence matrix 
%follows formula in Hu, Parish, et al.
Z = r_in * (eye(4) + sym(1/2) * H * mu * Y);
%Just Ohm's law
v = Z * i;
%We can get all the voltages in terms of the currents
v