import os
from dotenv import load_dotenv
import psycopg2
import psycopg2.extras
from neo4j import GraphDatabase

load_dotenv()

pg = psycopg2.connect(
    host=os.getenv("PG_HOST"),
    port=os.getenv("PG_PORT"),
    dbname=os.getenv("PG_DB"),
    user=os.getenv("PG_USER"),
    password=os.getenv("PG_PASSWORD")
)
cur = pg.cursor(cursor_factory=psycopg2.extras.RealDictCursor)

driver = GraphDatabase.driver(
    os.getenv("NEO4J_URI"),
    auth=(os.getenv("NEO4J_USER"), os.getenv("NEO4J_PASSWORD"))
)

def run(query, params={}):
    with driver.session() as s:
        s.run(query, params)

def migrate_clients():
    cur.execute("""
        SELECT c.id_client, c.name, c.address, c.city, c.phone_number,
               u.user_uuid, u.email, u.username
        FROM client c
        JOIN users u ON u.id_client = c.id_client
    """)
    for row in cur.fetchall():
        run("""
            MERGE (c:Client {id: $id})
            SET c.name      = $name,
                c.address   = $address,
                c.city      = $city,
                c.phone     = $phone,
                c.user_uuid = $user_uuid,
                c.email     = $email,
                c.username  = $username
        """, {
            "id":        str(row["id_client"]),
            "name":      row["name"],
            "address":   row["address"],
            "city":      row["city"],
            "phone":     row["phone_number"],
            "user_uuid": str(row["user_uuid"]),
            "email":     row["email"],
            "username":  row["username"]
        })
    print("✓ Clients")

def migrate_companies():
    cur.execute("SELECT id_company, name, ein, client_uuid FROM companies")
    for row in cur.fetchall():
        run("""
            MERGE (co:Company {id: $id})
            SET co.name = $name, co.ein = $ein
        """, {"id": str(row["id_company"]), "name": row["name"], "ein": row["ein"]})
        run("""
            MATCH (c:Client {user_uuid: $user_uuid})
            MATCH (co:Company {id: $company_id})
            MERGE (c)-[:CONTROLS]->(co)
        """, {"user_uuid": str(row["client_uuid"]), "company_id": str(row["id_company"])})
    print("✓ Companies")

def migrate_loans():
    cur.execute("""
        SELECT id, loan_amount, status, user_uuid,
               property_address, property_use, transaction_type
        FROM loan_applications
    """)
    for row in cur.fetchall():
        run("""
            MERGE (l:LoanApplication {id: $id})
            SET l.amount           = $amount,
                l.status           = $status,
                l.property_address = $address,
                l.property_use     = $use,
                l.transaction_type = $type
        """, {
            "id":      str(row["id"]),
            "amount":  float(row["loan_amount"]) if row["loan_amount"] else 0,
            "status":  row["status"],
            "address": row["property_address"],
            "use":     row["property_use"],
            "type":    row["transaction_type"]
        })
        run("""
            MATCH (c:Client {user_uuid: $user_uuid})
            MATCH (l:LoanApplication {id: $loan_id})
            MERGE (c)-[:IS_BORROWER_IN]->(l)
        """, {"user_uuid": str(row["user_uuid"]), "loan_id": str(row["id"])})
    print("✓ Loans")

def migrate_guarantors():
    cur.execute("SELECT client_uuid, score, status FROM guarantors")
    for row in cur.fetchall():
        run("""
            MATCH (c:Client {user_uuid: $user_uuid})
            SET c.guarantor_score  = $score,
                c.guarantor_status = $status
        """, {
            "user_uuid": str(row["client_uuid"]),
            "score":     float(row["score"]) if row["score"] else None,
            "status":    row["status"]
        })
    print("✓ Guarantors")

def migrate_schedule_e():
    cur.execute("""
        SELECT fg.client_uuid,
               entity ->> 'name' AS company_name,
               entity ->> 'ein'  AS ein
        FROM filings_guarantor fg,
        LATERAL jsonb_array_elements(
            fg.data -> 'forms' -> 'schedule_e' -> 'entities'
        ) AS entity
    """)
    for row in cur.fetchall():
        if not row["ein"]:
            continue
        run("""
            MERGE (co:Company {ein: $ein})
            ON CREATE SET co.name = $name
        """, {"ein": row["ein"], "name": row["company_name"]})
        run("""
            MATCH (c:Client {user_uuid: $user_uuid})
            MATCH (co:Company {ein: $ein})
            MERGE (c)-[:HAS_SCHEDULE_E_INCOME_FROM]->(co)
        """, {"user_uuid": str(row["client_uuid"]), "ein": row["ein"]})
    print("✓ Schedule E")

def migrate_loan_participants():
    cur.execute("""
        SELECT application_id, display_name, role, is_entity
        FROM loan_participants
    """)
    for row in cur.fetchall():
        loan_id   = str(row["application_id"])
        name      = row["display_name"]
        role      = row["role"]
        is_entity = row["is_entity"]
        rel       = "IS_GUARANTOR_IN" if role == "guarantor" else "IS_BORROWER_IN"

        if is_entity:
            run(f"""
                MATCH (co:Company)
                WHERE toLower(co.name) = toLower($name)
                MATCH (l:LoanApplication {{id: $loan_id}})
                MERGE (co)-[:{rel}]->(l)
            """, {"name": name, "loan_id": loan_id})
        else:
            run(f"""
                MATCH (c:Client)
                WHERE toLower(c.name) = toLower($name)
                MATCH (l:LoanApplication {{id: $loan_id}})
                MERGE (c)-[:{rel}]->(l)
            """, {"name": name, "loan_id": loan_id})
    print("✓ Loan Participants")

if __name__ == "__main__":
    print("🚀 Iniciando migración PostgreSQL → Neo4j...")
    migrate_clients()
    migrate_companies()
    migrate_loans()
    migrate_guarantors()
    migrate_schedule_e()
    migrate_loan_participants()
    print("\n✅ Migración completa.")
    cur.close()
    pg.close()
    driver.close()
