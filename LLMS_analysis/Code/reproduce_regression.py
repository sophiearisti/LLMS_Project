"""
Reproduce Ederer & Schneider regression and compare with LLM-coded predictions.

Regression: numrolls ~ communication + is_promise if role, cluster(session)
Expected result: is_promise p-value = 0.043
"""

import pandas as pd
import numpy as np
import os
import warnings
warnings.filterwarnings('ignore')

# Setup paths
project_root = r"C:\Users\danie\Dropbox\Javeriana\Proyecto LLMS text\LLMS_Project"
data_path = os.path.join(project_root, "Papers", "Trust and Promises", "datapaper_anonymized.csv")
results_root = os.path.join(project_root, "LLMS_analysis", "Results")

print("=" * 80)
print("STEP 1: LOAD AND EXPLORE DATA")
print("=" * 80)

# Load data
df = pd.read_csv(data_path)
print(f"\nData shape: {df.shape}")
print(f"\nColumn names:\n{df.columns.tolist()}")
print(f"\nFirst few rows:")
print(df.head())

# Subset to trustees and communication condition
df_subset = df[(df['role'] == 1)].copy()
print(f"\nAfter filtering to role==1 (trustees): n={len(df_subset)}")

print(f"\nVariables of interest:")
print(f"  numrolls: min={df_subset['numrolls'].min()}, max={df_subset['numrolls'].max()}, mean={df_subset['numrolls'].mean():.3f}")
print(f"  communication: {df_subset['communication'].value_counts().to_dict()}")
print(f"  is_promise: {df_subset['is_promise'].value_counts().to_dict()}")
print(f"  session: {df_subset['session'].nunique()} unique sessions")

# Check for missing values
print(f"\nMissing values in key variables:")
print(df_subset[['numrolls', 'communication', 'is_promise', 'session']].isnull().sum())

print("\n" + "=" * 80)
print("STEP 2: REPRODUCE BASELINE REGRESSION (HUMAN CODING)")
print("=" * 80)

# Prepare data for regression
reg_data = df_subset[['numrolls', 'communication', 'is_promise', 'session']].dropna().copy()
print(f"\nData for regression: n={len(reg_data)}")

# Use statsmodels with clustered standard errors
try:
    import statsmodels.api as sm
    from statsmodels.formula.api import ols
    from statsmodels.stats.outliers_influence import variance_inflation_factor
    
    # Add constant
    X = reg_data[['communication', 'is_promise']].copy()
    X = sm.add_constant(X)
    y = reg_data['numrolls'].copy()
    clusters = reg_data['session'].values
    
    # Fit OLS with clustered standard errors
    model = sm.OLS(y, X).fit(cov_type='cluster', cov_kwds={'groups': clusters})
    
    print("\n" + model.summary().as_text())
    print("\n" + "=" * 80)
    print("BASELINE RESULTS SUMMARY")
    print("=" * 80)
    
    # Extract key results
    print(f"\nIntercept: {model.params['const']:.4f} (p={model.pvalues['const']:.4f})")
    print(f"Communication: {model.params['communication']:.4f} (p={model.pvalues['communication']:.4f})")
    print(f"is_promise: {model.params['is_promise']:.4f} (p={model.pvalues['is_promise']:.4f})")
    print(f"\nR-squared: {model.rsquared:.4f}")
    print(f"Adj R-squared: {model.rsquared_adj:.4f}")
    print(f"N: {model.nobs}")
    
    # Store baseline results
    baseline_results = {
        'model': 'human_coding',
        'intercept': model.params['const'],
        'communication_coef': model.params['communication'],
        'communication_pval': model.pvalues['communication'],
        'is_promise_coef': model.params['is_promise'],
        'is_promise_pval': model.pvalues['is_promise'],
        'rsquared': model.rsquared,
        'n': model.nobs
    }
    
    # Verify against expected result
    expected_p = 0.043
    actual_p = model.pvalues['is_promise']
    tolerance = 0.01  # Allow 0.01 tolerance for rounding/data differences
    
    print(f"\n{'✓ MATCH' if abs(actual_p - expected_p) < tolerance else '✗ MISMATCH'}: Expected is_promise p={expected_p:.4f}, Got p={actual_p:.4f}")
    
except ImportError:
    print("ERROR: statsmodels not installed. Please install: pip install statsmodels")
    baseline_results = None

print("\n" + "=" * 80)
print("STEP 3: EXPLORE LLM RESULTS STRUCTURE")
print("=" * 80)

# List available LLM results for trust_promises_Ederer_Schneider
llm_models = ['claude', 'gemini', 'gpt']
for llm in llm_models:
    llm_path = os.path.join(results_root, llm)
    if os.path.exists(llm_path):
        paper_path = os.path.join(llm_path, 'trust_promises_Ederer_Schneider')
        if os.path.exists(paper_path):
            print(f"\n{llm.upper()} results found at: {paper_path}")
            # List subdirectories
            subdirs = [d for d in os.listdir(paper_path) if os.path.isdir(os.path.join(paper_path, d))]
            print(f"  Prompt styles: {subdirs}")
            for subdir in subdirs[:1]:  # Show first one in detail
                files = os.listdir(os.path.join(paper_path, subdir))
                print(f"  Files in {subdir}: {files[:3]}")  # Show first 3 files

print("\nDone with exploration. Ready to extract and compare LLM predictions.")
