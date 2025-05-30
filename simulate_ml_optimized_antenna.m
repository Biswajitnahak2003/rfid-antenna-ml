close all
clear
clc

%% Setup the Simulation
physical_constants;
unit = 1e-3; % all length in mm

% patch width in x-direction
patch.width  = 42; % resonant length
% patch length in y-direction
patch.length = 35;

%substrate setup
substrate.epsR   = 4.3;
substrate.kappa  = 1e-3 * 2*pi*2.45e9 * EPS0*substrate.epsR;
substrate.width  = 60;
substrate.length = 60;
substrate.thickness = 2;
substrate.cells = 4;

%setup feeding
feed.pos = -6; %feeding position in x-direction
feed.R = 50;     %feed resistance

% size of the simulation box
SimBox = [200 200 150];

%% Setup FDTD Parameter & Excitation Function
f0 = 2e9; % center frequency
fc = 1e9; % 20 dB corner frequency
FDTD = InitFDTD( 'NrTs', 30000 );
FDTD = SetGaussExcite( FDTD, f0, fc );
BC = {'MUR' 'MUR' 'MUR' 'MUR' 'MUR' 'MUR'}; % boundary conditions
FDTD = SetBoundaryCond( FDTD, BC );

%% Setup CSXCAD Geometry & Mesh
CSX = InitCSX();

%initialize the mesh with the "air-box" dimensions
mesh.x = [-SimBox(1)/2 SimBox(1)/2];
mesh.y = [-SimBox(2)/2 SimBox(2)/2];
mesh.z = [-SimBox(3)/3 SimBox(3)*2/3];

% Create Patch
CSX = AddMetal( CSX, 'patch' );
start = [-patch.width/2 -patch.length/2 substrate.thickness];
stop  = [ patch.width/2  patch.length/2 substrate.thickness];
CSX = AddBox(CSX,'patch',10,start,stop);

% Create Substrate
CSX = AddMaterial( CSX, 'substrate' );
CSX = SetMaterialProperty( CSX, 'substrate', 'Epsilon', substrate.epsR, 'Kappa', substrate.kappa );
start = [-substrate.width/2 -substrate.length/2 0];
stop  = [ substrate.width/2  substrate.length/2 substrate.thickness];
CSX = AddBox( CSX, 'substrate', 0, start, stop );

% add extra cells to discretize the substrate thickness
mesh.z = [linspace(0,substrate.thickness,substrate.cells+1) mesh.z];

% Create Ground
CSX = AddMetal( CSX, 'gnd' );
start(3)=0;
stop(3) =0;
CSX = AddBox(CSX,'gnd',10,start,stop);

% Apply the Excitation & Resist as a Current Source
start = [feed.pos 0 0];
stop  = [feed.pos 0 substrate.thickness];
[CSX port] = AddLumpedPort(CSX, 5 ,1 ,feed.R, start, stop, [0 0 1], true);

% Finalize the Mesh
mesh = DetectEdges(CSX, mesh,'ExcludeProperty','patch');
mesh = DetectEdges(CSX, mesh,'SetProperty','patch','2D_Metal_Edge_Res', c0/(f0+fc)/unit/50);
mesh = SmoothMesh(mesh, c0/(f0+fc)/unit/20);
CSX = DefineRectGrid(CSX, unit, mesh);

CSX = AddDump(CSX,'Hf', 'DumpType', 11, 'Frequency',[2.4e9]);
CSX = AddBox(CSX,'Hf',10,[-substrate.width -substrate.length -10*substrate.thickness],[substrate.width +substrate.length 10*substrate.thickness]);

% Add NF2FF Box
start = [mesh.x(4)     mesh.y(4)     mesh.z(4)];
stop  = [mesh.x(end-3) mesh.y(end-3) mesh.z(end-3)];
[CSX nf2ff] = CreateNF2FFBox(CSX, 'nf2ff', start, stop);

%% Prepare and Run Simulation
Sim_Path = 'sim_ml_optimized';
Sim_CSX = 'ml_patch_ant.xml';

[status, message, messageid] = rmdir( Sim_Path, 's' );
[status, message, messageid] = mkdir( Sim_Path );

WriteOpenEMS( [Sim_Path '/' Sim_CSX], FDTD, CSX );

CSXGeomPlot( [Sim_Path '/' Sim_CSX] );

RunOpenEMS( Sim_Path, Sim_CSX);

%% Postprocessing & Numerical Output Only
freq = linspace( max([1e9,f0-fc]), f0+fc, 501 );
port = calcPort(port, Sim_Path, freq);

% Calculate S11
s11 = port.uf.ref ./ port.uf.inc;
[min_s11_db, f_res_ind] = min(20*log10(abs(s11)));
f_res = freq(f_res_ind);

% Calculate input impedance at resonance
Zin = port.uf.tot ./ port.if.tot;
Zin_res = Zin(f_res_ind);
Zin_real = real(Zin_res);
Zin_imag = imag(Zin_res);

% Calculate VSWR from S11
S11_abs = abs(s11(f_res_ind));
VSWR = (1 + S11_abs) / (1 - S11_abs);

% Calculate far-field
disp('calculating far field at phi=[0 90] deg...');
nf2ff = CalcNF2FF(nf2ff, Sim_Path, f_res, [-180:2:180]*pi/180, [0 90]*pi/180);

% Print results
fprintf('--- Simulation Results at Resonance (%.2f MHz) ---\n', f_res/1e6);
fprintf('S11 (dB): %.2f dB\n', min_s11_db);
fprintf('VSWR: %.2f\n', VSWR);
fprintf('Input Impedance Zin: %.2f + j%.2f Ohm\n', Zin_real, Zin_imag);
fprintf('Maximum Directivity (Dmax in dBi): %.2f dBi\n', 10*log10(nf2ff.Dmax));
fprintf('Efficiency: %.2f %%\n', 100*nf2ff.Prad./port.P_inc(f_res_ind));

% plot reflection coefficient S11
s11 = port.uf.ref ./ port.uf.inc;
figure
plot( freq/1e6, 20*log10(abs(s11)), 'k-', 'Linewidth', 2 );
grid on
title( 'reflection coefficient S_{11}' );
xlabel( 'frequency f / MHz' );
ylabel( 'reflection coefficient |S_{11}|' );






























