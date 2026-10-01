"""Load the raw Superstore Excel file into the DuckDB ODS layer (ods.Superstore)."""

from pathlib import Path

import duckdb

PROJECT_ROOT = Path(__file__).resolve().parent.parent

DB_PATH = PROJECT_ROOT / "dbt_project" / "dev.duckdb"
XLSX_PATH = PROJECT_ROOT / "data" / "raw" / "Superstore.xlsx"


def main() -> None:
    con = duckdb.connect(str(DB_PATH))
    try:
        con.execute("CREATE SCHEMA IF NOT EXISTS ods")

        con.execute(f"""
            CREATE OR REPLACE TABLE ods.Superstore AS
            SELECT *
            FROM read_xlsx('{XLSX_PATH}', header=True)
        """)

        count = con.execute("SELECT COUNT(*) FROM ods.Superstore").fetchone()[0]
        print(f"Loaded ods.Superstore: {count} rows")
    finally:
        con.close()

    print("ODS load complete")


if __name__ == "__main__":
    main()
