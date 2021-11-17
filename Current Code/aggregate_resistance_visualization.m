function aggregate_resistance_visualization(M, N, mu, phi, V, n_max, x_top, x_bottom, min, max, step, randtrue, temptrue, longtrue)
tic
B_vals = zeros(1, (max - min)/step);
V_vals = zeros(1, (max - min)/step);
V_vals1 = zeros(1, (max - min)/step);
V_vals2 = zeros(1, (max - min)/step);
V_vals3 = zeros(1, (max - min)/step);

if(randtrue)
    runs = 20;
    rmsMatrix = zeros(runs, (max-min)/step);
    figure 
    hold on
    for r = 1:runs
        for a = 1:(max-min)/step
            rando = random('Normal', 1, a-1, M,N);
            rando( rando < 0) = 0.001;
            x_output = expanded_resistance_function(M, N, 0, mu, phi, V, n_max, rando);
            V_vals(a) = -x_output((x_top(1) - 1)*4 + 2) + x_output(N*(M-1)*4 + x_bottom(1)*4);
            %R_vals(a) =-x_output((x_top - 1)*4 + 2) + x_output(N*(M-1)*4 + x_bottom*4)/Itot;
            B_vals(a) = (a-1)*step + min;
        end
        plot(B_vals, V_vals, 'Color', '#00A5E5')
        rmsMatrix(r, 1:(max-min)/step) = V_vals;
        line(xlim(), [0,0], 'LineWidth', 0.5, 'Color', 'k');
        grid on;
    end
    plot(B_vals, 5*var(rmsMatrix, 0, 1), 'Color', '#FFBF65', 'LineWidth', 1)
    xlabel('Standard Deviation')
    ylabel('Transverse Voltage (Volts)')
    ylim([-1,1])
      
    hold off 
end

if(temptrue)
    rando = random('Normal', 1, 0.0, M,N);
    rando( rando < 0) = 0.1;

    Tco1 = random('Normal', 1, 0, M,N);
    Tco1(Tco1 < 0) = 0.001;
    
    Tco2 = random('Normal', 1, 0.15, M,N);
    Tco2(Tco2 < 0) = 0.001;
    
    Tco3 = random('Normal', 1, 0.3, M,N);
    Tco3(Tco3 < 0) = 0.001;
    
    for a = 1:(max-min)/step
        rando1 = rando;
        rando2 = rando;
        rando3 = rando;
        rando1(Tco1 > (a-1)*step + min) = 0.001;
        rando2(Tco2 > (a-1)*step + min) = 0.001;
        rando3(Tco3 > (a-1)*step + min) = 0.001;
        x_output1 = expanded_resistance_function(M, N, 0, mu, phi, V, n_max, rando1);
        x_output2 = expanded_resistance_function(M, N, 0, mu, phi, V, n_max, rando2);
        x_output3 = expanded_resistance_function(M, N, 0, mu, phi, V, n_max, rando3);
        %V_vals(a) = -x_output((x_top - 1)*4 + 2) + x_output(N*(M-1) + x_bottom*4);
        %V_vals(a) = -x_output((x_top - 1)*N*4 + 1) + x_output(x_bottom*N*4 - 2);
        
        if(longtrue)
            Itot1 = sum(x_output1(4*N*(M+1)-1:N*4:end));
            Itot2 = sum(x_output2(4*N*(M+1)-1:N*4:end));
            Itot3 = sum(x_output3(4*N*(M+1)-1:N*4:end));
            %V_vals1(a) =(-x_output1((x_top - 1)*4*M + 1) + x_output1(x_bottom*M*4 -1))/Itot1;
            %V_vals2(a) =(-x_output2((x_top - 1)*4*M + 1) + x_output1(x_bottom*M*4 -1))/Itot2;
            %V_vals3(a) =(-x_output3((x_top - 1)*4*M + 1) + x_output1(x_bottom*M*4 -1))/Itot3;
            V_vals1(a) =-1/Itot1;
            V_vals2(a) =-1/Itot2;
            V_vals3(a) =-1/Itot3;
        else
            Itot1 = sum(x_output1(1:N*4:end));
            Itot2 = sum(x_output2(1:N*4:end));
            Itot3 = sum(x_output3(1:N*4:end));
            V_vals1(a) = -x_output1((x_top - 1)*4 + 2) + x_output1(N*(M-1)*4 + x_bottom*4)/Itot1;
            V_vals2(a) = -x_output2((x_top - 1)*4 + 2) + x_output2(N*(M-1)*4 + x_bottom*4)/Itot2;
            V_vals3(a) = -x_output3((x_top - 1)*4 + 2) + x_output3(N*(M-1)*4 + x_bottom*4)/Itot3; 
        end
            B_vals(a) = (a-1)*step + min;
    end
    figure
    plot(B_vals, V_vals1, 'Color', '#00A5E5')
    hold on
    plot(B_vals, V_vals2, 'Color', '#FFBF65')
    plot(B_vals, V_vals3,'Color', '#FF96C5')
    xlabel('Temperature (Kelvin)')
    ylabel('Longitudinal Resistance (Ohms)')
    ylim([-1,1])
    legend("delta Tc = 0", "delta Tc = 0.15", "delta Tc = 0.3", 'Location', 'southeast')
    hold off
end

toc
end