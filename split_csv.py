import pandas as pd
import numpy as np
import os

# Specify the path to the input CSV file
input_csv_file = 'output_data.csv'

# Specify the number of smaller pieces you want
num_pieces = 10

# Specify the path to the output directory
output_directory = 'output_pieces/'

# Create the output directory if it doesn't exist
os.makedirs(output_directory, exist_ok=True)

# Read the CSV file into a DataFrame
df = pd.read_csv(input_csv_file)

# Shuffle the DataFrame randomly
df = df.sample(frac=1, random_state=42).reset_index(drop=True)

# Calculate the number of rows in each piece
rows_per_piece = len(df) // num_pieces

# Split the DataFrame into smaller pieces
for i in range(num_pieces):
    start_idx = i * rows_per_piece
    end_idx = (i + 1) * rows_per_piece if i < num_pieces - 1 else None
    piece_df = df.iloc[start_idx:end_idx]
    
    # Save each piece to a separate CSV file
    piece_csv_file = os.path.join(output_directory, f'piece_{i+1}.csv')
    piece_df.to_csv(piece_csv_file, index=False)

print(f'{num_pieces} pieces with randomized content have been saved to {output_directory}')
