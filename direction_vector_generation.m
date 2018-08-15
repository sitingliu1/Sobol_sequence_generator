function [ dir_rom ] = direction_vector_generation( BL, dim )
%   This code uses reverse engineering to calculate the direction vectors
%   for Sobol sequence generator in [1].
%   [1] S. Liu and J. Han, "Toward Energy-Efficient Stochastic Circuits Using 
%   Parallel Sobol Sequences," in IEEE Transactions on Very Large Scale Integration (VLSI) Systems, 
%   vol. 26, no. 7, pp. 1326-1339, July 2017.
%
%   Statistics and Machine Learning Toolbox with function "sobolset" should be installed to run the
%   code. Otherwise, download the Sobol generation program from https://people.smp.uq.edu.au/DirkKroese/montecarlohandbook/quasimc/
%   and use function sobol() to replace sobolset(). Please also cite "D.P. Kroese, T. Taimre, Z.I. Botev (2011). Handbook of Monte Carlo Methods, 
%   Wiley Series in Probability and Statistics, John Wiley and Sons, New
%   York." if you use their code.
%
%   BL is the bit width of your Sobol sequence generator, and dim is the
%   number of uncorrelated Sobol sequences (dimension) that are required by your
%   application. dir_rom is in cell format, and each cell stores the
%   direction vectors in "char" format for generating one Sobol sequence. Each row represents a
%   direction vector.

    L=2^BL; % maximum non-repeating sequence length when a bit width of BL is used
    P = sobolset(dim);
    sobol_seq = net(P,L)*L; % generate dim-dimentional Sobol sequence and normalize by 2^BL
    dir_rom=cell(dim,1);    % initilize the direction vector cells
    for i=1:dim
        s_seq=de2bi(sobol_seq(:,i));
        dir_rom{i}=zeros(BL,BL);
        for j=1:BL
            dir_rom{i}(j,:)=fliplr(xor(s_seq(2^(j-1),:),s_seq(2^(j-1)+1,:)));
        end
        dir_rom{i}=fliplr(dec2bin(bi2de(dir_rom{i})));
    end

end

