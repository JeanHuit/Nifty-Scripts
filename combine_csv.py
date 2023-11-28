import pandas as pd
import glob

# Specify the path to your CSV files
csv_files = glob.glob('URL/*.csv')

# Initialize an empty DataFrame
combined_data = pd.DataFrame()

# Loop through each CSV file and concatenate its data to the DataFrame
for csv_file in csv_files:
    df = pd.read_csv(csv_file)
    combined_data = pd.concat([combined_data, df], ignore_index=True)

# Save the combined DataFrame to a new CSV file
combined_data.to_csv('combined.csv', index=False)
