function PF = GeneratePF(Problem,ft,nt,maxgen,preEvolution)
% Generate true PF according various problems
% There are problems including:
% FDA1-7, DMOP1-3 JY1 2 5 9  UDF1 4 7

    switch Problem
        case 'FDA1'
            PF = FDA1.PF(ft,nt,maxgen);
        case 'FDA2'
            PF = FDA2.PF(ft,nt,maxgen,preEvolution);
        case 'FDA3'
            PF = FDA3.PF(ft,nt,maxgen,preEvolution);
        case 'FDA4'
            PF = FDA4.PF(ft,nt,maxgen);
        case 'FDA5'
            PF = FDA5.PF(ft,nt,maxgen,preEvolution);
        case 'DMOP1'
            PF = DMOP1.PF(ft,nt,maxgen,preEvolution);
        case 'DMOP2'
            PF = DMOP2.PF(ft,nt,maxgen,preEvolution);
        case 'DMOP3'
            PF = DMOP3.PF(ft,nt,maxgen);
        case 'DF1'
            PF = DF1.PF(ft,nt,maxgen,preEvolution);
        case 'DF2'
            PF = DF2.PF(ft,nt,maxgen,preEvolution);
        case 'DF3'
            PF = DF3.PF(ft,nt,maxgen,preEvolution);
        case 'DF4'
            PF = DF4.PF(ft,nt,maxgen,preEvolution);
        case 'DF5'
            PF = DF5.PF(ft,nt,maxgen,preEvolution);
        case 'DF6'
            PF = DF6.PF(ft,nt,maxgen,preEvolution);
        case 'DF7'
            PF = DF7.PF(ft,nt,maxgen,preEvolution);
        case 'DF8'
            PF = DF8.PF(ft,nt,maxgen,preEvolution);
        case 'DF9'
            PF = DF9.PF(ft,nt,maxgen,preEvolution);
        case 'DF10'
            PF = DF10.PF(ft,nt,maxgen,preEvolution);
        case 'DF11'
            PF = DF11.PF(ft,nt,maxgen,preEvolution);
        case 'DF12'
            PF = DF12.PF(ft,nt,maxgen,preEvolution);
        case 'DF13'
            PF = DF13.PF(ft,nt,maxgen,preEvolution);
        case 'DF14'
            PF = DF14.PF(ft,nt,maxgen,preEvolution);
    end
end