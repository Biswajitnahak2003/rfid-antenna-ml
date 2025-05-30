import pandas as pd
import glob

# Path to your folder containing all batch CSVs
folder_path = 'C:/Users/biswa/rfid_project/'  # Change if your path is different

# Use glob to find all batch CSV files
all_files = glob.glob(folder_path + "antenna_results_batch_*.csv")

# List to hold DataFrames
df_list = []

for file in all_files:
    df = pd.read_csv(file)
    df_list.append(df)

# Concatenate all DataFrames into one
full_df = pd.concat(df_list, ignore_index=True)

# Optional: remove duplicate rows if any
full_df = full_df.drop_duplicates()

# Save merged CSV
full_df.to_csv(folder_path + 'antenna_dataset_full.csv', index=False)

print(f'Merged {len(all_files)} files with total {len(full_df)} rows saved as antenna_dataset_full.csv')
