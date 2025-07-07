# Setup Guide

This guide provides detailed instructions for setting up the Oklahoma Tax Credit Insights project from scratch.

## Prerequisites

### System Requirements
- **Operating System**: Windows 10/11, macOS 10.14+, or Linux
- **Python**: Version 3.8 or higher
- **Git**: For version control
- **Internet Connection**: Required for downloading dependencies

### Required Accounts
- **Snowflake Account**: With appropriate permissions
- **Power BI Pro License**: For dashboard deployment (optional for development)

## Step-by-Step Setup

### 1. Environment Setup

#### Install Python
```bash
# Check if Python is installed
python --version

# If not installed, download from https://python.org
# Ensure pip is available
pip --version
```

#### Install Git
```bash
# Check if Git is installed
git --version

# If not installed, download from https://git-scm.com
```

### 2. Project Setup

#### Clone Repository
```bash
git clone https://github.com/Willthompson99/oklahoma-tax-credit-insights.git
cd oklahoma-tax-credit-insights
```

#### Create Virtual Environment
```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate

# On macOS/Linux:
source venv/bin/activate

# Verify activation (should show path to venv)
which python
```

#### Install Dependencies
```bash
# Install Python packages
pip install -r requirements.txt

# Install dbt
pip install dbt-snowflake

# Verify installation
dbt --version
```

### 3. Snowflake Configuration

#### Create Snowflake Objects
```sql
-- Log into Snowflake and run these commands
-- Create database and schema
CREATE DATABASE IF NOT EXISTS WILLTHOMPSON;
CREATE SCHEMA IF NOT EXISTS WILLTHOMPSON.PUBLIC;

-- Create warehouse
CREATE WAREHOUSE IF NOT EXISTS COMPUTE_WH 
WITH WAREHOUSE_SIZE = 'X-SMALL' 
AUTO_SUSPEND = 300 
AUTO_RESUME = TRUE;

-- Grant permissions to your user
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE ACCOUNTADMIN;
GRANT ALL ON DATABASE WILLTHOMPSON TO ROLE ACCOUNTADMIN;
```

#### Configure Environment Variables
```bash
# Copy the example environment file
cp .env.example .env

# Edit .env file with your credentials
# Use your preferred text editor
nano .env
```

Example `.env` file:
```env
SF_ACCOUNT=your_account_identifier
SF_USER=your_username
SF_PASSWORD=your_password
SF_WAREHOUSE=COMPUTE_WH
SF_DATABASE=WILLTHOMPSON
SF_SCHEMA=PUBLIC
SF_ROLE=ACCOUNTADMIN
```

### 4. dbt Configuration

#### Set up dbt Profile
```bash
# Create dbt directory
mkdir -p ~/.dbt

# Copy profile template
cp profiles.yml.example ~/.dbt/profiles.yml

# Edit the profile file
nano ~/.dbt/profiles.yml
```

Example `profiles.yml`:
```yaml
default:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: your_account_identifier
      user: your_username
      password: your_password
      role: ACCOUNTADMIN
      database: WILLTHOMPSON
      warehouse: COMPUTE_WH
      schema: PUBLIC
      threads: 4
      client_session_keep_alive: False
```

#### Test dbt Connection
```bash
# Test connection
dbt debug

# Install dbt packages
dbt deps
```

### 5. Data Loading

#### Load Sample Data
```sql
-- In Snowflake, create and load the tax credits table
CREATE TABLE WILLTHOMPSON.PUBLIC.TAX_CREDITS_2023 (
    FISCAL_YEAR VARCHAR(10),
    TAX_YEAR INTEGER,
    RECIPIENT_NAME VARCHAR(255),
    CREDIT_TYPE VARCHAR(100),
    AMOUNT VARCHAR(50),
    CREDIT_DESCRIPTION TEXT
);

-- Load your data using Snowflake's web interface or SnowSQL
-- Example using COPY command:
COPY INTO WILLTHOMPSON.PUBLIC.TAX_CREDITS_2023
FROM @your_stage/tax_credits_data.csv
FILE_FORMAT = (TYPE = CSV SKIP_HEADER = 1);
```

### 6. Run the Pipeline

#### Execute dbt Models
```bash
# Run all models
dbt run

# Run tests
dbt test

# Generate documentation
dbt docs generate

# Serve documentation locally
dbt docs serve
```

#### Verify Data
```bash
# Check that marts were created
dbt run --select marts

# Run specific model
dbt run --select mart_credit_summary

# Test data quality
dbt test --select mart_credit_summary
```

### 7. Power BI Setup

#### Install Power BI Desktop
1. Download from Microsoft Store or [Power BI website](https://powerbi.microsoft.com/)
2. Install and launch Power BI Desktop

#### Configure Snowflake Connection
1. Open Power BI Desktop
2. Click "Get Data" → "More" → "Snowflake"
3. Enter your Snowflake server details
4. Use your Snowflake credentials to authenticate
5. Select the WILLTHOMPSON database and PUBLIC schema

#### Load the Dashboard
1. Open `powerbi/OK_Tax_Credit_Insights.pbix`
2. Refresh data connections when prompted
3. Verify all visualizations load correctly

### 8. Export Functionality

#### Test CSV Export
```bash
# Run the export script
python export_mart_tables.py

# Check output directory
ls -la data/marts_exports/
```

## Troubleshooting

### Common Issues

#### Connection Errors
- **Error**: "Object does not exist or not authorized"
  - **Solution**: Verify database, schema, and table names are correct
  - Check user permissions in Snowflake

#### dbt Compilation Errors
- **Error**: "dbt compilation error"
  - **Solution**: Run `dbt deps` to install dependencies
  - Check SQL syntax in model files

#### Python Module Not Found
- **Error**: "ModuleNotFoundError"
  - **Solution**: Ensure virtual environment is activated
  - Reinstall requirements: `pip install -r requirements.txt`

### Getting Help

If you encounter issues:
1. Check the error message carefully
2. Review the troubleshooting section
3. Search existing GitHub issues
4. Create a new issue with detailed error information

## Next Steps

After successful setup:
1. Explore the Power BI dashboard
2. Review the generated dbt documentation
3. Experiment with the CSV export functionality
4. Consider customizing models for your specific needs

## Security Notes

- Never commit the `.env` file to version control
- Use strong passwords for Snowflake accounts
- Consider using key-pair authentication for production
- Regularly rotate credentials
- Review and limit user permissions in Snowflake