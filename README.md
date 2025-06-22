# 🏛️ Oklahoma Tax Credit Insights

A data transformation project built with **dbt (data build tool)** and **Snowflake**, designed to model and analyze Oklahoma's public tax credit data. The final outputs power a **Qlik dashboard** for insights into tax credit distribution and trends.

---

## 📁 Project Structure

```

oklahoma-tax-credit-insights/
├── models/
│   ├── staging/
│   │   ├── stg\_tax\_credits.sql         # Initial cleaned and renamed base model
│   │   ├── schema.yml                  # Column-level tests and docs
│   │   └── sources.yml                 # Source table declaration
│   └── marts/
│       ├── mart\_credit\_summary.sql     # Total claims per year/type
│       └── mart\_top\_recipients.sql     # Highest claim recipients
├── macros/                             # (optional) Custom dbt macros
├── tests/                              # (optional) Custom schema or data tests
├── analysis/                           # (optional) Ad hoc queries
├── data/                               # (optional) Seed files
├── dbt\_project.yml                     # dbt project config
├── README.md                           # 📄 You're here!

````

---

## 🔧 Setup

### Requirements
- dbt v1.0+  
- Snowflake account & credentials  
- Qlik (for visualization)

### Snowflake Connection
Update your `profiles.yml`:
```yaml
oklahoma_tax_credit_insights:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <your_account>
      user: <your_username>
      password: <your_password>
      role: ACCOUNTADMIN
      database: WILLTHOMPSON
      warehouse: COMPUTE_WH
      schema: PUBLIC
````

---

## ▶️ Commands

```bash
# Run all models
dbt run

# Run tests
dbt test

# Generate & open documentation
dbt docs generate
dbt docs serve
```

---

## 📊 Dashboards

Qlik is used to visualize:

* Total claimed tax credits by year and type
* Top credit recipients
* County- or entity-level distribution (optional extension)

---

## 🧪 Tests & Documentation

All models include:

* **Not null tests** for key fields
* **Accepted value tests** on fiscal/tax years
* **Descriptions** for each column and model

---

## ✨ Future Ideas

* Add new marts for county-level aggregation
* Integrate demographic overlays (optional)
* Automate Qlik app refresh with dbt Cloud or Airflow

---

## 📬 Author

**William Thompson**
📍 Oklahoma City, OK
🔗 [GitHub](https://github.com/Willthompson99)