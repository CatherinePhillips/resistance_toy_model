function transverse_resistance_visualization(M, N, mu, phi, V, n_max, r, x_top, x_bottom, min, max, step, transtrue, longtrue, randtrue)
tic
B_vals = zeros(1, (max - min)/step);
V_vals = zeros(1, (max - min)/step);
V0 = 0;
I0 = 0;
R_vals = zeros(1, (max - min)/step); 
if(transtrue)
    for a = 1:(max-min)/step
        x_output = expanded_resistance_function(M, N, ((a-1)*step + min), mu, phi, V, n_max, r);
        %V_vals(a) = -x_output((x_top - 1)*4 + 2) + x_output(N*(M-1) + x_bottom*4);
        %V_vals(a) = -x_output((x_top - 1)*N*4 + 1) + x_output(x_bottom*N*4 - 2);
        Itot = sum(x_output(1:N*4:end));
        V_vals1(a) = -x_output((x_top(1) - 1)*4 + 2) + x_output(N*(M-1)*4 + x_bottom(1)*4);
        V_vals2(a) = -x_output((x_top(2) - 1)*4 + 2) + x_output(N*(M-1)*4 + x_bottom(2)*4);
        V_vals3(a) = -x_output((x_top(3) - 1)*4 + 2) + x_output(N*(M-1)*4 + x_bottom(3)*4);
        %R_vals(a) =-x_output((x_top - 1)*4 + 2) + x_output(N*(M-1)*4 + x_bottom*4)/Itot;
        B_vals(a) = (a-1)*step + min;
    end
    figure
    plot(B_vals, V_vals1, 'Color', '#00A5E5')
    hold on
    plot(B_vals, V_vals2, 'Color', '#FFBF65')
    plot(B_vals, V_vals3,'Color', '#FF96C5')
    xlabel('Magnetic Field Strength (ostensibly Teslas)')
    ylabel('Transverse Voltage (Volts)')
    ylim([-1,1])
    legend("x = 3", "x = 5", "x = 7", 'Location', 'southeast')
    hold off
    
    figure
    plot(B_vals, 0.5*(V_vals1 + flip(V_vals1)), 'Color', '#00A5E5')
    hold on
    plot(B_vals, 0.5*(V_vals2 + flip(V_vals2)), 'Color', '#FFBF65')
    plot(B_vals, 0.5*(V_vals3 + flip(V_vals3)),'Color', '#FF96C5')
    xlabel('Magnetic Field Strength (ostensibly Teslas)')
    ylabel('Transverse Voltage (Volts)')
    ylim([-1,1])
    legend("x = 3", "x = 5", "x = 7", 'Location', 'southeast')
    hold off
    
        figure
    plot(B_vals, 0.5*(V_vals1 - flip(V_vals1)), 'Color', '#00A5E5')
    hold on
    plot(B_vals, 0.5*(V_vals2 - flip(V_vals2)), 'Color', '#FFBF65')
    plot(B_vals, 0.5*(V_vals3 - flip(V_vals3)),'Color', '#FF96C5')
    xlabel('Magnetic Field Strength (Teslas)')
    ylabel('Transverse Voltage (Volts)')
    ylim([-1,1])
    legend("x = 3", "x = 5", "x = 7", 'Location', 'southeast')
    hold off
end
if(longtrue) 
    for a = 1:(max-min)/step
        x_output = expanded_resistance_function(M, N, ((a-1)*step + min), mu, phi, V, n_max, r);
        %V_vals(a) = -x_output((x_top - 1)*4 + 2) + x_output(N*(M-1) + x_bottom*4);
        %V_vals(a) = -x_output((x_top - 1)*N*4 + 1) + x_output(x_bottom*N*4 - 2);
        
        Itot = sum(x_output(1:N*4:end));
        %V_vals(a) = x_output((x_top - 1)*4 + 2) - x_output((x_bottom-1)*4 + 2);
        R_vals(a) = -V/Itot;
        B_vals(a) = (a-1)*step + min;
        if ((a-1)*step + min == 0)
            for b = 1:M
                I0 = I0 + x_output((b-1)*N*4 + 1);
            end
            R0 = -V/I0;
        end
    end
    %R_vals = (R_vals - R0)/R0;
    figure
    plot(B_vals, R_vals)
    xlabel('Magnetic Field Strength (Teslas)')
    ylabel('Longitudinal Resistance (Ohms)')
end

toc 
end