# setup
pip install dbt-bigquery
# (or install via pipx / homebrew depending on setup)


# initialize project (if not created)
cd teamBA-dw-project
# place your CSVs into BigQuery or use dbt seed (if you converted to csv seeds)


# run dbt
dbt debug
dbt run --select staging+
dbt test
dbt run --select marts+