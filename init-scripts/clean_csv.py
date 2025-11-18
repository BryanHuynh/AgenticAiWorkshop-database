#!/usr/bin/env python3

import csv
import sys
from datetime import datetime

def clean_csv(input_file, output_file):
    try:
        with open(input_file, 'r') as infile:
            with open(output_file, 'w', newline='') as outfile:
                reader = csv.reader(infile)
                writer = csv.writer(outfile)
                
                date_index = 2
                column_max_length = 7
                
                for (idx, row) in enumerate(reader):
                    cleaned_row = [field.strip() for field in row]
                    cleaned_row.insert(0, idx)
                    while cleaned_row and cleaned_row[-1] == '':
                        cleaned_row.pop()
                        
                    try:
                        parsed_date = datetime.strptime(cleaned_row[date_index], "%d/%m/%Y")
                        cleaned_row[date_index] = parsed_date.strftime("%Y-%m-%d")
                    except ValueError:
                        print(f"Warning: Invalid date format '{cleaned_row[date_index]}'", file=sys.stderr)

                    
                    if len(cleaned_row) == column_max_length:
                        writer.writerow(cleaned_row)
                    elif len(cleaned_row) > column_max_length:
                        writer.writerow(cleaned_row[:column_max_length])
                    else:
                        print(f"Warning: Skipping row with {len(cleaned_row)} fields", file=sys.stderr)
        
        return 0
    except Exception as e:
        return 1

if __name__ == "__main__":
    input_file = '/tmp/dataset.csv'
    output_file = '/tmp/dataset_clean.csv'
    
    exit_code = clean_csv(input_file, output_file)
    sys.exit(exit_code)