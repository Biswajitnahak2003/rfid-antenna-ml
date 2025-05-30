% File: run_patch_batch.m
% Usage: run_patch_batch(batch_number)

function run_patch_batch(batch_number)

  if nargin < 1
    error("Usage: run_patch_batch(batch_number)");
  end

  % Design parameter ranges
  lengths = 25:1:35;        % 11 values
  widths = 35:1:45;         % 11 values
  thicknesses = 1:0.1:2;    % 11 values

  % Generate all combinations
  [L, W, T] = ndgrid(lengths, widths, thicknesses);
  combos = [L(:), W(:), T(:)];  % 1331 rows

  total_simulations = size(combos, 1);
  batch_size = 100;

  % Determine range for this batch
  start_idx = (batch_number - 1) * batch_size + 1;
  end_idx = min(batch_number * batch_size, total_simulations);

  if start_idx > total_simulations
    error("Batch number %d exceeds available simulations.", batch_number);
  end

  % Subset for current batch
  batch_combos = combos(start_idx:end_idx, :);

  % Open output file
  filename = sprintf("antenna_results_batch_%02d.csv", batch_number);
  fid = fopen(filename, "w");
  fprintf(fid, "Length,Width,Thickness,S11_dB,VSWR,Impedance,Directivity_dBi,Efficiency\n");

  for i = 1:size(batch_combos, 1)
    % Extract parameters
    Lp = batch_combos(i,1);
    Wp = batch_combos(i,2);
    h = batch_combos(i,3);

    % --- SIMULATION PLACEHOLDER ---
    % Replace this with your actual openEMS simulation function!
    % Simulate and get results
    S11_dB = -10 + randn();           % placeholder
    VSWR = 1.5 + rand();              % placeholder
    Zin = 50 + randn()*5;             % placeholder
    D = 6 + randn();                  % placeholder
    Eff = 0.85 + 0.05*randn();        % placeholder

    % Write results
    fprintf(fid, "%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n", ...
        Lp, Wp, h, S11_dB, VSWR, Zin, D, Eff);
  end

  fclose(fid);
  printf("✅ Batch %d completed and saved to %s\n", batch_number, filename);
end

