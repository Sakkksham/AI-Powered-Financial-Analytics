import re


def validate_sql(sql):
    sql_clean = sql.strip().upper()

    # Only SELECT and WITH queries are allowed
    if not (
        sql_clean.startswith("SELECT")
        or sql_clean.startswith("WITH")
    ):
        return False, "Only SELECT or WITH queries are allowed."

    forbidden = [
        "INSERT",
        "UPDATE",
        "DELETE",
        "DROP",
        "ALTER",
        "TRUNCATE",
        "CREATE",
        "RENAME",
        "GRANT",
        "REVOKE"
    ]

    for keyword in forbidden:
        if re.search(rf"\b{keyword}\b", sql_clean):
            return False, f"Forbidden SQL operation: {keyword}"

    return True, "SQL is safe."