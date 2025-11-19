# 📊 Grocery Sales Dashboard - Build Guide

## Core Business Questions & Models

| Question | Model | Chart Type | Chart # |
|----------|-------|------------|---------|
| Which categories generate most revenue monthly? | `monthly_category_revenue` | **Stacked Area Chart** or **Line Chart** | Chart 1 |
| What is the sales trend by region? | `sales_trend_by_region` | **Line Chart** or **Geo Map** | Chart 2 |
| Who are the top 10 customers? | `top_customers` | **Horizontal Bar Chart** | Chart 3 |
| Are there seasonal spikes? | `seasonal_sales` | **Column Chart** (Vertical Bar) | Chart 4 |

## Additional Insights & Models

| Insight | Model | Chart Type | Chart # |
|---------|-------|------------|---------|
| Daily KPIs & growth rates | `business_kpis` | **KPI Scorecards** (4 cards) | KPI Cards |
| Customer segments (RFM) | `customer_segmentation` | **Pie Chart** or **Donut Chart** | Chart 5 |
| Product performance & rankings | `product_performance` | **Table** with conditional formatting | Chart 6 |
| Sales team performance | `sales_team_performance` | **Horizontal Bar Chart** or **Table** | Chart 7 |
| Monthly growth tracking | `monthly_growth_metrics` | **Combo Chart** (Bar + Line) | Chart 8 |
| Discount effectiveness | `discount_impact_analysis` | **Grouped Bar Chart** | Chart 9 |
| Geographic performance | `geography_performance` | **Geo Map** or **Table** | Optional |

---

## Dashboard Layout

```
┌────────────────────────────────────────────────────────────┐
│  FILTERS: Date Range | Category | Region                    │
├────────────────────────────────────────────────────────────┤
│  KPI CARDS: Total Revenue | Customers | AOV | Growth %     │
│  Chart Type: Scorecards | Data: business_kpis              │
├────────────────────────────────────────────────────────────┤
│  Chart 1: Monthly Revenue by Category                      │
│  Chart Type: Stacked Area/Line | Data: monthly_category_revenue │
├────────────────────────────────────────────────────────────┤
│  Chart 2: Sales Trend by Region                            │
│  Chart Type: Line Chart/Geo Map | Data: sales_trend_by_region │
├───────────────────────────┬────────────────────────────────┤
│ Chart 3: Top 10 Customers │ Chart 4: Seasonal Pattern      │
│ Chart Type: Horizontal Bar│ Chart Type: Column Chart       │
│ Data: top_customers       │ Data: seasonal_sales           │
├───────────────────────────┴────────────────────────────────┤
│  Chart 5: Customer Segments                                │
│  Chart Type: Pie/Donut Chart | Data: customer_segmentation │
├───────────────────────────┬────────────────────────────────┤
│ Chart 6: Product           │ Chart 7: Sales Team           │
│ Performance                │ Leaderboard                   │
│ Chart Type: Table          │ Chart Type: Horizontal Bar    │
│ Data: product_performance  │ Data: sales_team_performance  │
├───────────────────────────┴────────────────────────────────┤
│  Chart 8: Monthly Growth Trends                           │
│  Chart Type: Combo (Bar + Line) | Data: monthly_growth_metrics │
├────────────────────────────────────────────────────────────┤
│  Chart 9: Discount Impact                                  │
│  Chart Type: Grouped Bar Chart | Data: discount_impact_analysis │
└────────────────────────────────────────────────────────────┘
```

---

## Setup: Connect to BigQuery

1. Go to https://lookerstudio.google.com/
2. **Create** → **Data Source** → **BigQuery**
3. Project: `grocery-sales-478511`
4. Dataset: `dbt_dev_marts`
5. Select all tables needed
6. **Connect** → **Create Report**

---

## KPI Cards (Top of Dashboard)

**Chart Type:** Scorecards (4 cards)  
**Data Source:** `business_kpis`

| Card | Metric | Aggregation | Format | Filter |
|------|--------|-------------|--------|--------|
| Total Revenue | `total_revenue` | SUM | Currency | Latest date |
| Active Customers | `unique_customers` | SUM | Number | Latest date |
| Average Order Value | `avg_transaction_value` | AVERAGE | Currency | All dates |
| Growth Rate | `week_over_week_growth` | AVERAGE | Percent | Latest date |

**Styling:** Use conditional formatting for Growth Rate (Green if positive, Red if negative)

---

## Chart 1: Monthly Revenue by Category

**Chart Type:** **Stacked Area Chart** or **Line Chart** (multi-line)  
**Data Source:** `monthly_category_revenue`

**Configuration:**
- **X-axis:** `sale_month` (Format: Month Year)
- **Breakdown:** `category_name`
- **Y-axis:** `total_revenue` (SUM, Currency format)
- **Sort:** By date ascending

**Styling:** Different color per category, show legend, grid lines on

---

## Chart 2: Sales Trend by Region

**Chart Type:** **Line Chart** (multi-line) or **Geo Map**  
**Data Source:** `sales_trend_by_region`

**For Line Chart:**
- **X-axis:** `sale_month`
- **Breakdown:** `country_name` or `city_name`
- **Y-axis:** `revenue` (SUM, Currency)

**For Geo Map:**
- **Location:** `country_name`
- **Metric:** `revenue` (SUM)
- **Color Scale:** Green gradient (darker = higher)

---

## Chart 3: Top 10 Customers

**Chart Type:** **Horizontal Bar Chart**  
**Data Source:** `top_customers`

**Configuration:**
- **Y-axis:** `customer_name`
- **X-axis:** `total_spent` (SUM, Currency)
- **Sort:** Descending by `total_spent`
- **Limit:** Top 10 rows

**Styling:** Single color bars, show data labels on bars

---

## Chart 4: Seasonal Sales Pattern

**Chart Type:** **Column Chart** (Vertical Bar)  
**Data Source:** `seasonal_sales`

**Configuration:**
- **X-axis:** `month_number` (1-12, label as Jan-Dec)
- **Y-axis:** `avg_monthly_revenue` (Currency)
- **Optional:** Add `max_monthly_revenue` and `min_monthly_revenue` as additional series
- **Sort:** By month number (1-12)

**Styling:** Single color bars, show data labels, horizontal grid lines

---

## Chart 5: Customer Segmentation

**Chart Type:** **Pie Chart** or **Donut Chart**  
**Data Source:** `customer_segmentation`

**Configuration:**
- **Dimension:** `customer_segment`
- **Metric:** Record Count (or `total_monetary_value` SUM)

**Styling:**
- **Colors:** Champions (Green #4CAF50), Loyal Customers (Blue #2196F3), At Risk (Orange #FF9800), Lost (Red #F44336)
- Show percentages and legend

---

## Chart 6: Product Performance

**Chart Type:** **Table** with conditional formatting  
**Data Source:** `product_performance`

**Columns:**
- `product_name`
- `category_name`
- `total_revenue` (Currency)
- `total_units_sold` (Number)
- `times_sold` (Number)
- `product_status` (with color coding)

**Sort:** By `total_revenue` descending  
**Limit:** Top 20 rows

**Conditional Formatting:**
- Star Product: Green highlight
- Slow Mover: Orange highlight
- Never Sold: Red highlight

---

## Chart 7: Sales Team Leaderboard

**Chart Type:** **Horizontal Bar Chart** or **Table**  
**Data Source:** `sales_team_performance`

**For Bar Chart:**
- **Y-axis:** `employee_name`
- **X-axis:** `total_revenue` (Currency)
- **Color by:** `performance_tier`
- **Sort:** Descending by `total_revenue`
- **Limit:** Top 15-20 rows

**Performance Tier Colors:**
- Top Performer: Dark Green
- High Performer: Light Green
- Average: Blue
- Developing: Orange

---

## Chart 8: Monthly Growth Trends

**Chart Type:** **Combo Chart** (Bar + Line)  
**Data Source:** `monthly_growth_metrics`

**Configuration:**
- **X-axis:** `sale_month`
- **Left Y-axis (Bars):** `total_revenue` (Currency)
- **Right Y-axis (Line 1):** `mom_revenue_growth` (Percent)
- **Right Y-axis (Line 2):** `yoy_revenue_growth` (Percent, optional)

**Styling:**
- Bars: Blue
- MoM Line: Green (positive) / Red (negative)
- YoY Line: Purple

---

## Chart 9: Discount Impact Analysis

**Chart Type:** **Grouped Bar Chart**  
**Data Source:** `discount_impact_analysis`

**Configuration:**
- **X-axis:** `discount_tier` (Order: No Discount, 1-10%, 11-20%, 21-30%, 30%+)
- **Y-axis (3 series):**
  - `total_revenue` (Bar 1)
  - `num_transactions` (Bar 2)
  - `avg_transaction_value` (Bar 3)

**Alternative:** Create 3 separate bar charts side by side

---

## Optional Chart: Geographic Performance

**Chart Type:** **Geo Map** or **Table**  
**Data Source:** `geography_performance`

**For Geo Map:**
- **Location:** `country_name` or `city_name`
- **Metric:** `total_revenue` (SUM)
- **Color Scale:** Green gradient

**For Table:**
- **Columns:** `country_name`, `city_name`, `num_customers`, `total_revenue`, `revenue_per_customer`
- **Sort:** By `total_revenue` descending

---

## Dashboard Filters

Add these filter controls at the top:

1. **Date Range Filter**
   - Control type: Date range
   - Apply to: All charts

2. **Category Filter** (optional)
   - Field: `category_name`
   - Control type: Drop-down
   - Apply to: Charts 1, 4, 6

3. **Region Filter** (optional)
   - Field: `country_name`
   - Control type: Drop-down
   - Apply to: Charts 2, 7

---

## Quick Reference: Models & Charts

| Model | Table Name | Primary Chart Type | Chart # |
|-------|------------|-------------------|---------|
| `business_kpis` | `dbt_dev_marts.business_kpis` | Scorecards | KPI Cards |
| `monthly_category_revenue` | `dbt_dev_marts.monthly_category_revenue` | Stacked Area/Line | Chart 1 |
| `sales_trend_by_region` | `dbt_dev_marts.sales_trend_by_region` | Line Chart/Geo Map | Chart 2 |
| `top_customers` | `dbt_dev_marts.top_customers` | Horizontal Bar | Chart 3 |
| `seasonal_sales` | `dbt_dev_marts.seasonal_sales` | Column Chart | Chart 4 |
| `customer_segmentation` | `dbt_dev_marts.customer_segmentation` | Pie/Donut Chart | Chart 5 |
| `product_performance` | `dbt_dev_marts.product_performance` | Table | Chart 6 |
| `sales_team_performance` | `dbt_dev_marts.sales_team_performance` | Horizontal Bar/Table | Chart 7 |
| `monthly_growth_metrics` | `dbt_dev_marts.monthly_growth_metrics` | Combo Chart | Chart 8 |
| `discount_impact_analysis` | `dbt_dev_marts.discount_impact_analysis` | Grouped Bar | Chart 9 |
| `geography_performance` | `dbt_dev_marts.geography_performance` | Geo Map/Table | Optional |

---

## Build Checklist

### Setup
- [ ] Run `dbt run` to build all models
- [ ] Run `dbt test` to verify data quality
- [ ] Verify data in BigQuery dataset `dbt_dev_marts`
- [ ] Connect Looker Studio to BigQuery

### Core Dashboard (4 Core Questions)
- [ ] Add filters: Date Range, Category, Region
- [ ] KPI Cards (4 metrics from `business_kpis`)
- [ ] Chart 1: Category Revenue (Stacked Area/Line)
- [ ] Chart 2: Sales by Region (Line/Geo Map)
- [ ] Chart 3: Top 10 Customers (Horizontal Bar)
- [ ] Chart 4: Seasonal Patterns (Column Chart)

### Extended Dashboard
- [ ] Chart 5: Customer Segmentation (Pie/Donut)
- [ ] Chart 6: Product Performance (Table)
- [ ] Chart 7: Sales Team Leaderboard (Bar/Table)
- [ ] Chart 8: Monthly Growth (Combo Chart)
- [ ] Chart 9: Discount Impact (Grouped Bar)
- [ ] Optional: Geographic Performance (Geo Map/Table)

### Final Touches
- [ ] Consistent colors and fonts
- [ ] Clear chart titles
- [ ] Data labels where helpful
- [ ] Test all filters
- [ ] Publish dashboard

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Charts not loading | Check BigQuery connection and permissions |
| Wrong numbers | Verify aggregation (SUM vs AVG vs COUNT) |
| Slow dashboard | Add date filters, limit rows in tables |
| Can't see data | Confirm dataset: `dbt_dev_marts` |
| Filters not working | Check which charts filters apply to |

**Resources:**
- Looker Studio: https://support.google.com/looker-studio/
- BigQuery Connection: https://support.google.com/looker-studio/answer/6370296

---

## Summary

✅ **11 data models** - 4 core questions + 7 additional insights  
✅ **9 main charts** + KPI cards + optional geographic view  
✅ **All models tested and validated**  
✅ **Clear chart type specifications for each model**

You're ready to build your dashboard! 🚀
