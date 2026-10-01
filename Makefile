DBT_DIR   := dbt_project
DBT_FLAGS := --profiles-dir . --target dev

.PHONY: help install load deps build docs airflow-up airflow-down clean

help:          ## Show available commands
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-14s %s\n", $$1, $$2}'

install:       ## Install Python dependencies (dbt + DuckDB)
	pip install -r requirements.txt

load:          ## Load Superstore.xlsx into the DuckDB ODS schema
	python scripts/load_to_ods.py

deps:          ## Install dbt packages
	cd $(DBT_DIR) && dbt deps

build: load deps ## Run the full pipeline locally (load + dbt run + dbt test)
	cd $(DBT_DIR) && dbt build $(DBT_FLAGS)

docs:          ## Generate and serve dbt docs on http://localhost:8081
	cd $(DBT_DIR) && dbt docs generate $(DBT_FLAGS) && dbt docs serve $(DBT_FLAGS) --port 8081

airflow-up:    ## Start Airflow in Docker on http://localhost:8080
	cd airflow && docker compose up -d --build

airflow-down:  ## Stop Airflow
	cd airflow && docker compose down

clean:         ## Remove dbt artifacts and the local DuckDB file
	cd $(DBT_DIR) && dbt clean
	rm -f $(DBT_DIR)/dev.duckdb
