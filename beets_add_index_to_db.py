# https://github.com/issues/recent?issue=beetbox%7Cbeets%7C5809

import sqlite3
from pathlib import Path

from beets.library import Library

# Configure your db path
db_path = Path("/home/scp1/var/beets/beets20231124.db")
idx_name = "items_album_id_idx"


def run_sql_exc(path, query):
    conn = sqlite3.connect(path)
    cursor = conn.cursor()
    cursor.execute(query)
    conn.commit()
    conn.close()


if __name__ == "__main__":
    # Load library (to ensure db is valid and accessible)
    lib = Library(db_path.name, str(db_path.resolve().parent))

    # Drop and create index
    run_sql_exc(db_path, f'DROP INDEX IF EXISTS "{idx_name}"')
    print("Dropped existing index if any.")

    run_sql_exc(db_path, f'CREATE INDEX IF NOT EXISTS "{idx_name}" ON items (album_id)')
    print("Created index on items.album_id.")

    print("Done.")
