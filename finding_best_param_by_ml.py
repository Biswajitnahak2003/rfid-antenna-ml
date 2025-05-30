import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import MinMaxScaler

# Load dataset

folder_path = 'C:/Users/biswa/rfid_project/'
df = pd.read_csv(folder_path + 'antenna_dataset_full.csv')

inputs = ['Length', 'Width', 'Thickness']
outputs = ['Directivity_dBi', 'Efficiency', 'S11_dB', 'VSWR']

# Train individual models for each output
models = {}
for target in outputs:
    model = RandomForestRegressor(n_estimators=100, random_state=42)
    model.fit(df[inputs], df[target])
    models[target] = model

# Generate dense grid of combinations
length_vals = np.arange(25, 35.5, 0.5)
width_vals = np.arange(35, 45.5, 0.5)
thick_vals = np.arange(1.0, 2.1, 0.1)

grid = pd.DataFrame([
    (l, w, t)
    for l in length_vals
    for w in width_vals
    for t in thick_vals
], columns=inputs)

# Predict using trained models
for target in outputs:
    grid[target] = models[target].predict(grid[inputs])

# Normalize outputs and invert S11/VSWR
scaler = MinMaxScaler()
norm_preds = grid[outputs].copy()
norm_preds = scaler.fit_transform(norm_preds)
norm_preds[:, 2] = 1 - norm_preds[:, 2]  # invert S11
norm_preds[:, 3] = 1 - norm_preds[:, 3]  # invert VSWR

# Compute combined score
grid['Score'] = norm_preds.mean(axis=1)

# Find best prediction
best_idx = grid['Score'].idxmax()
best_row = grid.loc[best_idx]

print(" ML-Optimized Parameters:")
print(best_row[inputs])

print("\n Predicted Performance:")
print(best_row[outputs])

print("\n🏆 Composite Score:", round(best_row['Score'], 4))
