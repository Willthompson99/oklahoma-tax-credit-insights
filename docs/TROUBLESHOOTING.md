# Troubleshooting Guide

This guide helps resolve common issues encountered when setting up and running the Oklahoma Tax Credit Insights project.

## Table of Contents
- [Environment Setup Issues](#environment-setup-issues)
- [Snowflake Connection Problems](#snowflake-connection-problems)
- [dbt Runtime Errors](#dbt-runtime-errors)
- [Power BI Issues](#power-bi-issues)
- [Python Script Errors](#python-script-errors)
- [Performance Issues](#performance-issues)
- [Data Quality Issues](#data-quality-issues)

---

## Environment Setup Issues

### Virtual Environment Problems

**Issue**: `pip: command not found` or `python: command not found`
```bash
# Error message
bash: pip: command not found
```

**Solution**:
1. Ensure Python is installed and in PATH
2. Verify pip is installed with Python
3. On Windows, use `py -m pip` instead of `pip`

```bash
# Check Python installation
python --version
python -m pip --version

# Alternative commands
py --version        # Windows
python3 --version   # Linux/Mac
```

**Issue**: Virtual environment not activating
```bash
# Error on Windows
'venv\Scripts\activate' is not recognized as an internal or external command
```

**Solution**:
```bash
# Windows - try different activation methods
venv\Scripts\activate.bat
venv\Scripts\Activate.ps1  # PowerShell

# Linux/Mac
source venv/bin/activate

# Verify activation
which python  # Should show venv path
```

### Dependency Installation Issues

**Issue**: Package installation fails with permission errors
```bash
# Error message
ERROR: Could not install packages due to an EnvironmentError: [Errno 13] Permission denied
```

**Solution**:
```bash
# Use --user flag or virtual environment
pip install --user -r requirements.txt

# Or ensure virtual environment is activated
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows
pip install -r requirements.txt
```

---

## Snowflake Connection Problems

### Authentication Errors

**Issue**: Invalid credentials error
```bash
# Error message
250001 (08001): Failed to connect to DB: your_account.snowflakecomputing.com:443
```

**Solution**:
1. Verify credentials in `.env` file
2. Check account identifier format
3. Ensure user has necessary permissions

```bash
# Check .env file format
SF_ACCOUNT=abc12345.us-east-1.snowflakecomputing.com
SF_USER=your_username
SF_PASSWORD=your_password
```

**Issue**: Account identifier format problems
```bash
# Error message
Cannot connect to Snowflake: Invalid account identifier
```

**Solution**:
```bash
# Correct formats:
SF_ACCOUNT=abc12345.us-east-1.snowflakecomputing.com  # Full format
SF_ACCOUNT=abc12345.us-east-1                         # Short format
SF_ACCOUNT=abc12345                                   # Legacy format

# Check Snowflake documentation for your region
```

### Permission Errors

**Issue**: Object does not exist or not authorized
```sql
-- Error message
SQL compilation error: Object 'WILLTHOMPSON.PUBLIC.TAX_CREDITS_2023' does not exist or not authorized
```

**Solution**:
1. Verify database and schema exist
2. Check user permissions
3. Ensure table is created and accessible

```sql
-- Check permissions
SHOW GRANTS TO USER your_username;
SHOW GRANTS TO ROLE your_role;

-- Verify objects exist
SHOW DATABASES;
SHOW SCHEMAS IN DATABASE WILLTHOMPSON;
SHOW TABLES IN SCHEMA WILLTHOMPSON.PUBLIC;
```

### Network Issues

**Issue**: Connection timeout
```bash
# Error message
Read timed out
```

**Solution**:
1. Check firewall settings
2. Verify internet connectivity
3. Try different network/VPN

```bash
# Test connectivity
ping your_account.snowflakecomputing.com
telnet your_account.snowflakecomputing.com 443
```

---

## dbt Runtime Errors

### Model Compilation Errors

**Issue**: dbt compilation error
```bash
# Error message
Compilation Error in model 'stg_tax_credits'
  column "AMOUNT" must appear in the GROUP BY clause or be used in an aggregate function
```

**Solution**:
1. Check SQL syntax in model files
2. Ensure all columns in SELECT are in GROUP BY
3. Verify source table exists

```bash
# Debug compilation
dbt compile --select stg_tax_credits
dbt run --select stg_tax_credits --debug
```

**Issue**: Source table not found
```bash
# Error message
Database Error in model 'stg_tax_credits'
  Object 'WILLTHOMPSON.PUBLIC.TAX_CREDITS_2023' does not exist
```

**Solution**:
1. Verify source table exists in Snowflake
2. Check sources.yml configuration
3. Ensure correct database/schema names

```yaml
# Check sources.yml
sources:
  - name: willthompson
    database: WILLTHOMPSON  # Verify this matches Snowflake
    schema: PUBLIC          # Verify this matches Snowflake
```

### dbt Connection Issues

**Issue**: dbt profile not found
```bash
# Error message
Profile 'default' not found
```

**Solution**:
1. Ensure profiles.yml exists in ~/.dbt/
2. Check profile name in dbt_project.yml
3. Verify YAML syntax

```bash
# Check profile location
ls ~/.dbt/profiles.yml

# Test profile
dbt debug
```

### Model Dependency Issues

**Issue**: Model dependency errors
```bash
# Error message
Dependency 'ref("stg_tax_credits")' not found
```

**Solution**:
1. Ensure referenced model exists
2. Check model file names match references
3. Verify model paths

```bash
# Check model dependencies
dbt deps
dbt compile --select +mart_credit_summary
```

---

## Power BI Issues

### Connection Problems

**Issue**: Cannot connect to Snowflake from Power BI
```
Error: Couldn't connect to Snowflake
```

**Solution**:
1. Install Snowflake ODBC driver
2. Verify credentials
3. Check firewall settings

```bash
# Download Snowflake ODBC driver from:
# https://docs.snowflake.com/en/user-guide/odbc-download.html
```

**Issue**: Data refresh fails
```
Error: Unable to refresh data source
```

**Solution**:
1. Check if Snowflake warehouse is running
2. Verify table permissions
3. Update connection credentials

### Data Loading Issues

**Issue**: Tables not visible in Power BI
```
No tables found in the selected database
```

**Solution**:
1. Ensure dbt models have been run
2. Check schema/database selection
3. Verify table permissions

```bash
# Verify tables exist
dbt run
dbt test

# Check in Snowflake
SHOW TABLES IN SCHEMA WILLTHOMPSON.PUBLIC;
```

---

## Python Script Errors

### Import Errors

**Issue**: Module not found
```python
# Error message
ModuleNotFoundError: No module named 'snowflake'
```

**Solution**:
```bash
# Ensure virtual environment is activated
source venv/bin/activate

# Install missing dependencies
pip install snowflake-connector-python
pip install -r requirements.txt
```

### Environment Variable Issues

**Issue**: Environment variables not loading
```python
# Error message
TypeError: 'NoneType' object is not callable
```

**Solution**:
1. Verify .env file exists
2. Check environment variable names
3. Ensure python-dotenv is installed

```python
# Debug environment variables
import os
from dotenv import load_dotenv

load_dotenv()
print(os.getenv('SF_ACCOUNT'))  # Should not be None
```

### Export Script Issues

**Issue**: Export fails with permission error
```python
# Error message
PermissionError: [Errno 13] Permission denied: 'data/marts_exports'
```

**Solution**:
```bash
# Create directory manually
mkdir -p data/marts_exports

# Check permissions
chmod 755 data/marts_exports
```

---

## Performance Issues

### Slow Query Performance

**Issue**: dbt models taking too long to run
```bash
# Models running for >10 minutes
```

**Solution**:
1. Optimize Snowflake warehouse size
2. Add appropriate clustering keys
3. Consider incremental models

```sql
-- Increase warehouse size temporarily
ALTER WAREHOUSE COMPUTE_WH SET WAREHOUSE_SIZE = 'MEDIUM';

-- Check query performance
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY 
WHERE QUERY_TEXT LIKE '%tax_credits%'
ORDER BY START_TIME DESC;
```

### Memory Issues

**Issue**: Python script running out of memory
```python
# Error message
MemoryError: Unable to allocate array
```

**Solution**:
1. Process data in chunks
2. Use pandas chunking
3. Optimize data types

```python
# Process in chunks
chunk_size = 10000
for chunk in pd.read_sql(query, conn, chunksize=chunk_size):
    # Process chunk
    pass
```

---

## Data Quality Issues

### Missing Data

**Issue**: Null values in amount field
```sql
-- Many NULL amounts in results
```

**Solution**:
1. Check source data quality
2. Update staging model logic
3. Add data validation tests

```sql
-- Check for null amounts
SELECT COUNT(*) FROM WILLTHOMPSON.PUBLIC.TAX_CREDITS_2023 
WHERE AMOUNT IS NULL OR AMOUNT = '';

-- Update staging model
CASE 
  WHEN AMOUNT IS NULL OR AMOUNT = '' THEN 0
  ELSE TRY_CAST(REPLACE(AMOUNT, ',', '') AS DECIMAL(15,2))
END AS amount
```

### Data Type Issues

**Issue**: Cannot convert amount to numeric
```sql
-- Error message
Numeric value 'N/A' is not recognized
```

**Solution**:
1. Use TRY_CAST instead of CAST
2. Add additional cleaning logic
3. Identify and handle edge cases

```sql
-- Robust amount conversion
CASE 
  WHEN AMOUNT IS NULL OR AMOUNT = '' OR AMOUNT = 'N/A' THEN 0
  WHEN AMOUNT LIKE '%-%' THEN 0  -- Handle negative indicators
  ELSE TRY_CAST(REGEXP_REPLACE(AMOUNT, '[^0-9.]', '') AS DECIMAL(15,2))
END AS amount
```

---

## Getting Additional Help

### Diagnostic Commands

Run these commands to gather diagnostic information:

```bash
# Environment diagnostics
python --version
pip --version
dbt --version

# Check project configuration
dbt debug
dbt compile --select stg_tax_credits

# Check Snowflake connection
python -c "
import snowflake.connector
from dotenv import load_dotenv
import os
load_dotenv()
conn = snowflake.connector.connect(
    user=os.getenv('SF_USER'),
    password=os.getenv('SF_PASSWORD'),
    account=os.getenv('SF_ACCOUNT')
)
print('Connection successful')
"
```

### Log Files

Check these locations for detailed error logs:
- dbt logs: `logs/dbt.log`
- Python logs: Check console output
- Snowflake logs: Query history in Snowflake web interface

### Support Resources

1. **Project Issues**: Create a GitHub issue with:
   - Error message
   - Steps to reproduce
   - Environment details
   - Relevant log files

2. **Community Support**:
   - dbt Community: https://discourse.getdbt.com/
   - Snowflake Community: https://community.snowflake.com/
   - Power BI Community: https://community.powerbi.com/

3. **Documentation**:
   - dbt Documentation: https://docs.getdbt.com/
   - Snowflake Documentation: https://docs.snowflake.com/
   - Power BI Documentation: https://docs.microsoft.com/power-bi/

---

## Prevention Tips

### Best Practices
1. Always use virtual environments
2. Keep dependencies up to date
3. Test changes incrementally
4. Use version control for all code
5. Document environment setup
6. Monitor query performance
7. Implement data quality tests
8. Regular credential rotation

### Monitoring
1. Set up alerts for failed dbt runs
2. Monitor Snowflake costs and usage
3. Track Power BI refresh success rates
4. Log all data pipeline activities

Remember: When in doubt, start with the simplest solution and work your way up to more complex fixes.