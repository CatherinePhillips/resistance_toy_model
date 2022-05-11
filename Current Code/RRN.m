classdef RRN < handle
    properties
        % Voltage and current matrices are of the form [4 m n], where the
        % four entries proceed clockwise from left to upper to right to
        % lower.
        
        % Voltage matrix.
        V
        % Current matrix.
        I
        % Number of rows.
        m
        % Number of columns.
        n
        % Applied voltage.
        Vapp
        % Compact vector form.
        vi_vec
    end
    
    methods
        function rrn = RRN(vi_vec, m, n)
            rrn.V = reshape(vi_vec(1: end/2), [4 n m]);
            rrn.I = reshape(vi_vec(end/2+1: end), [4 n m]);
            rrn.V = permute(rrn.V, [1 3 2]);
            rrn.I = permute(rrn.I, [1 3 2]);
            rrn.m = m;
            rrn.n = n;
            rrn.vi_vec = vi_vec;
        end
        
        function I = rightCurrent(rrn, n)
            I = sum(rrn.I(3,:,n));
        end
    end
end