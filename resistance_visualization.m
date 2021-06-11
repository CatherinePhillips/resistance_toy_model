function resistance_visualization(M, N, x, r, Tc, vtrue, itrue, rtrue, tctrue)
tic
%initialize values

v_val = zeros(2*M*N+M+N,1);
v_row = zeros(2*M*N+M+N,1);
v_col  = zeros(2*M*N+M+N,1);

i_u = zeros(2*M*N+M+N,1);
i_v = zeros(2*M*N+M+N,1);
i_row = zeros(2*M*N+M+N,1);
i_col  = zeros(2*M*N+M+N,1);

%start with the values in position 1 of every node
v_val(1:M*N, 1) = x(1:4:4*M*N);
%set row values
for a = 1:M
    v_row(((N)*(a-1)+1):(N)*a, 1) = 2*a;
end
%set column values 
for a = 1:N
    v_col(a:(N):M*N) = 1 + 2*(a-1);
end

%now position 2
v_val((M*N+1):2*M*N, 1) = x(2:4:4*M*N);
%set row values
for a = 1:M
    v_row((M*N+(N)*(a-1)+1):(M*N+(N)*a), 1) =  1 + 2*(a-1);
end
%set column values 
for a = 1:N
    v_col(M*N+a:(N):2*M*N) = 2*a;
end

%edge case position 3
v_val((2*M*N+1):(2*M*N + M), 1) = x((4*N-1):4*N:4*M*N);
%set row values
for a = 1:M
    v_row((2*M*N+a), 1) =  2*a;
end
%set column values 
v_col(2*M*N+1:2*M*N+M) = 2*N+1;

%edge case position 4
v_val((2*M*N+M+1):(2*M*N + M + N), 1) = x((4*(M-1)*N)+4:4:4*M*N);
%set row values
v_row(2*M*N+M+1:2*M*N+M+N) = 2*M+1;
%set column values 
for a = 1:N
    v_col((2*M*N+M+a), 1) =  2*a;
end


%start with the values in position 1 of every node
i_u(1:M*N, 1) = x(4*M*N + 1:4:8*M*N);
%set row values
for a = 1:M
    i_row(((N)*(a-1)+1):(N)*a, 1) = 2*a;
end
%set column values 
for a = 1:N
    i_col(a:(N):M*N) = 1 + 2*(a-1);
end

%now position 2
i_v((M*N+1):2*M*N, 1) = x(4*M*N + 2:4:8*M*N);
%set row values
for a = 1:M
    i_row((M*N+(N)*(a-1)+1):(M*N+(N)*a), 1) =  1 + 2*(a-1);
end
%set column values 
for a = 1:N
    i_col(M*N+a:(N):2*M*N) = 2*a;
end

%edge case position 3
i_u((2*M*N+1):(2*M*N + M), 1) = -x(4*N*M+(4*N-1):4*N:8*M*N);
%set row values
for a = 1:M
    i_row((2*M*N+a), 1) =  2*a;
end
%set column values 
i_col(2*M*N+1:2*M*N+M) = 2*N+1;

%edge case position 4
i_v((2*M*N+M+1):(2*M*N + M + N), 1) = -x((4*N*M+4*(M-1)*N)+4:4:8*M*N);
%set row values
i_row(2*M*N+M+1:2*M*N+M+N) = 2*M+1;
%set column values 
for a = 1:N
    i_col((2*M*N+M+a), 1) =  2*a;
end


%interpolate the voltage values onto a proper grid
[xq,yq] = meshgrid(1:1:2*M+2, 1:1:2*N+2);
vq = griddata(v_row,v_col,v_val,xq,yq);

if vtrue == 1
%create a figure for voltage
 figure 
 %pad with zeros to make pcolor give vertex values 
 pcolor([vq.', zeros(size(vq.',1), 1); zeros(1, size(vq.',2)+1)]);
 colorbar;
 hold on
 if itrue == 1
    quiver(i_col + 0.5, i_row + 0.5, i_u, i_v, 'k', 'LineWidth', 3);
 end
 xlim([0 2*M+2])
 ylim([0 2*N+2])
 for a = 1:M
     for b = 1:N
         circle(2*b + 0.5, 2*a + 0.5, 1);
     end
 end
end
 %create a figure for resistances
 if rtrue == 1
 figure 
 hold on
 xlim([0 M + 1])
 ylim([0 N + 2])
 %pad with zeros to make pcolor give vertex values 
 pcolor([r.', zeros(size(r,1), 1); zeros(1, size(r,2)+1)])
 colorbar;
 for a = 1:M
     for b = 1:N
         circle(b + 0.5,  a+ 0.5, 0.5);
     end
 end
 end 
 
 if tctrue == 1
 figure 
 hold on
 xlim([0 M + 1])
 ylim([0 N + 2])
 %pad with zeros to make pcolor give vertex values 
 pcolor([Tc.', zeros(size(r,1), 1); zeros(1, size(r,2)+1)])
 colorbar;
 for a = 1:M
     for b = 1:N
         circle(b + 0.5,  a+ 0.5, 0.5);
     end
 end
 end 
 
toc 
end
%helper function for drawing circles
function circle(x,y,r)
hold on
pos = [x-r y-r 2*r 2*r]; 
rectangle('Position',pos,'Curvature',[1 1], 'EdgeColor', 'k')
axis equal
hold off
end