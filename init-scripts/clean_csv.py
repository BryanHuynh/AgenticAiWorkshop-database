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
                
                for row in reader:
                    cleaned_row = [field.strip() for field in row]
                    
                    while cleaned_row and cleaned_row[-1] == '':
                        cleaned_row.pop()
                        
                    if len(cleaned_row) >= 2:
                        try:
                            parsed_date = datetime.strptime(cleaned_row[1], "%d/%m/%Y")
                            cleaned_row[1] = parsed_date.strftime("%Y-%m-%d")
                        except ValueError:
                            print(f"Warning: Invalid date format '{cleaned_row[1]}'", file=sys.stderr)

                    
                    if len(cleaned_row) == 6:
                        writer.writerow(cleaned_row)
                    elif len(cleaned_row) > 6:
                        writer.writerow(cleaned_row[:6])
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