import numpy as np
import pandas as pd

def transform_column(df, target_column):
    """
    Pivots the dataframe for a specific column and returns the result.
    """
    pivoted_df = df.pivot(index=['ATCo', 'Display'], columns='Scenario', values=target_column)
    
    pivoted_df = pivoted_df.reset_index()
    pivoted_df.columns.name = None 
    pivoted_df = pivoted_df.rename(columns={'ATCo': 'Participant Number'})
    
    return pivoted_df

def create_separate_csvs(input_file='DATA2026.xls'):
    """
    Loops through the columns and saves a separate CSV for each.
    """
    df = pd.read_csv(input_file, sep=None, engine='python')

    for col in standard_columns:
        if col in df.columns:
            result = transform_column(df, col)
            
            output_filename = f"{col}.csv"
            result.to_csv(output_filename, index=False)
            
            print(f"Success! Created {output_filename}")
        else:
            print(f"Warning: Column '{col}' not found in the input file.")
    
    for new_name, cols_to_sum in sum_columns.items():
        existing_cols = [c for c in cols_to_sum if c in df.columns]
        if existing_cols:
            df[new_name] = df[existing_cols].sum(axis=1, min_count=1)
            
            result = transform_column(df, new_name)
            result.to_csv(f"{new_name}.csv", index=False)
            print(f"Success! Created {new_name}.csv")
        else:
            print(f"Skipping {new_name}: Source columns not found.")
    
    for new_name, cols_to_substract in difference_columns.items():
        if all(c in df.columns for c in cols_to_substract):
            df[new_name] = df[cols_to_substract[0]] - df[cols_to_substract[1]]
            
            result = transform_column(df, new_name)
            result.to_csv(f"{new_name}.csv", index=False)
            print(f"Success! Created {new_name}.csv")
        else:
            print(f"Skipping {new_name}: Source columns not found.")
    
    for new_name, cols_to_divide in ratio_columns.items():
        if all(c in df.columns for c in cols_to_divide):
            df[new_name] = df[cols_to_divide[0]] / df[cols_to_divide[1]]
            
            result = transform_column(df, new_name)
            result.to_csv(f"{new_name}.csv", index=False)
            print(f"Success! Created {new_name}.csv")
        else:
            print(f"Skipping {new_name}: Source columns not found.")

standard_columns = ['ConflictDetectionTime_s',  'nrHDGClearancesConflict', 'nrSPDClearancesConflict', 
                       'STCAdurationPrimary_s', 'STCAdurationSecondary_s', 'LosPrimary', 'LosSecondary',
                       'nrHDGClearances', 'nrSPDClearances', 'timeClearanceMenu_s', 'nrLabelDrags', 'nrDisplayTriggers','rsmeWorkload']
sum_columns = {'TotalMaxHorDeviation_NM': ['maxHorDeviationA_NM', 'maxHorDeviationB_NM'], 'TotalClearancesConflict': ['nrHDGClearancesConflict', 'nrSPDClearancesConflict'],
               'TotalHDGClearances': ['nrHDGClearancesConflict', 'nrHDGClearances'], 'TotalSPDClearances': ['nrSPDClearancesConflict', 'nrSPDClearances'],
               'TotalClearances': ['nrHDGClearancesConflict', 'nrHDGClearances', 'nrSPDClearancesConflict', 'nrSPDClearances'],
               'TotalDisplayChanges': ['nrLabelDrags', 'nrDisplayTriggers']}
difference_columns = {'ConflictResolutionTime_s': ['ConflictResolutionTime_s', 'ConflictDetectionTime_s']}
ratio_columns = {'LateAssumeRatio': ['nrAssumeInsideSector', 'nrAssume'], 'LateTransferRatio': ['nrTransferOutsideSector', 'nrTransfer']}

if __name__ == "__main__":
    create_separate_csvs('DATA2026.xls')