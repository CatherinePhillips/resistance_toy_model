%this makes a movie either of resistance or voltage over an
%increasing temperature span
%output: three video files written to the places specified by videoWriter
%output: a graph of R vs T for the same resistance patterns in video 
function temperature_resistance_movie(M, N, mu, phi, V, n_max, x_top, x_bottom, min, max, step, longtrue)
tic
%initialize our matrices to zeros
B_vals = zeros(1, (max - min)/step);
V_vals1 = zeros(1, (max - min)/step);
V_vals2 = zeros(1, (max - min)/step);
V_vals3 = zeros(1, (max - min)/step);

%set up our three video writers
writerObj1 = VideoWriter('temp_movie_1_res.avi');
writerObj1.FrameRate = 10;
open(writerObj1)
writerObj2 = VideoWriter('temp_movie_2_res.avi');
writerObj2.FrameRate = 10;
open(writerObj2)
writerObj3 = VideoWriter('temp_movie_3_res.avi');
writerObj3.FrameRate = 10;
open(writerObj3)

    %build our random values for Tc, all based on the same resistance 
    rando = random('Normal', 1, 0.0, M,N);
    rando( rando < 0) = 0.1;

    Tco1 = random('Normal', 1, 0, M,N);
    Tco1(Tco1 < 0) = 0.001;
    
    Tco2 = random('Normal', 1, 0.15, M,N);
    Tco2(Tco2 < 0) = 0.001;
    
    Tco3 = random('Normal', 1, 0.3, M,N);
    Tco3(Tco3 < 0) = 0.001;
    
    %for loop over temperature between max and min with step size step
    for a = 1:(max-min)/step
        %mask each resistance by its corresponding Tc
        rando1 = rando;
        rando2 = rando;
        rando3 = rando;
        rando1(Tco1 > (a-1)*step + min) = 0.001;
        rando2(Tco2 > (a-1)*step + min) = 0.001;
        rando3(Tco3 > (a-1)*step + min) = 0.001;
        %solve the v and i values for each resistance guy 
        x_output1 = expanded_resistance_function(M, N, 0, mu, phi, V, n_max, rando1);
        x_output2 = expanded_resistance_function(M, N, 0, mu, phi, V, n_max, rando2);
        x_output3 = expanded_resistance_function(M, N, 0, mu, phi, V, n_max, rando3);
        %V_vals(a) = -x_output((x_top - 1)*4 + 2) + x_output(N*(M-1) + x_bottom*4);
        %V_vals(a) = -x_output((x_top - 1)*N*4 + 1) + x_output(x_bottom*N*4 - 2);
        
        %setup for the R vs T graph 
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
    
    %write our visualization at this a to the videoWriter object 
    gcf1 = figure('units','pixels','position',[0 0 800 800]);
    resistance_visualization(M, N, x_output1, rando1, Tco1, 1, 0, 0, 0)
    F1 = getframe(gcf1);
    writeVideo(writerObj1,F1);
    
    gcf2 = figure('units','pixels','position',[0 0 800 800]);
    resistance_visualization(M, N, x_output2, rando2, Tco2, 1, 0, 0, 0)
    F2 = getframe(gcf2);
    writeVideo(writerObj2,F2);
    
    gcf3 = figure('units','pixels','position',[0 0 800 800]);
    resistance_visualization(M, N, x_output3, rando3, Tco3, 1, 0, 0, 0)
    F3 = getframe(gcf3);
    writeVideo(writerObj3,F3);
    end
    
    %create the R vs T graph for the same resistance values as movies 
    figure
    plot(B_vals, V_vals1, 'Color', '#00A5E5')
    hold on
    plot(B_vals, V_vals2, 'Color', '#FFBF65')
    plot(B_vals, V_vals3,'Color', '#FF96C5')
    xlabel('Temperature (Kelvin)')
    ylabel('Longitudinal Resistance (Ohms)')
    ylim([-0.05,3])
    legend("delta Tc = 0.0", "delta Tc = 0.15", "delta Tc = 0.3", 'Location', 'southeast')
    hold off
    
    
    close(writerObj1)
    close(writerObj2)
    close(writerObj3)
toc
end