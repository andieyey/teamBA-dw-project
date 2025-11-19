# Grocery Sales dbt Project

### Quick Start

```bash
# Activate environment
source venv/bin/activate

# Run models
dbt run

# Run tests
dbt test

# View documentation & lineage (opens in browser)
dbt docs generate
dbt docs serve
```

### Models

**Staging** (7 models): stg_sales, stg_customers, stg_products, stg_employees, stg_categories, stg_cities, stg_countries

**Marts** (4 models): top_customers, monthly_category_revenue, sales_trend_by_region, seasonal_sales

### Configuration

- **Project**: grocery-sales-478511
- **Location**: asia-southeast1
- **Dataset**: dbt_dev (staging), dbt_dev_marts (marts)
- **Service Account**: grocery-sales-478511-b357eadc8ffe.json

---

**View lineage and docs: `dbt docs serve`
