import os
from dotenv import load_dotenv
from neo4j import GraphDatabase

load_dotenv()

driver = GraphDatabase.driver(
    os.getenv("NEO4J_URI"),
    auth=(os.getenv("NEO4J_USER"), os.getenv("NEO4J_PASSWORD"))
)

def run(query, params={}):
    with driver.session() as s:
        result = s.run(query, params)
        return [record.data() for record in result]

def exposicion_grupo_economico(client_name):
    results = run("""
        MATCH (c:Client)
        WHERE toLower(c.name) CONTAINS toLower($name)
        OPTIONAL MATCH (c)-[:CONTROLS|HAS_SCHEDULE_E_INCOME_FROM]->(co:Company)
        OPTIONAL MATCH (c)-[:IS_BORROWER_IN|IS_GUARANTOR_IN]->(l:LoanApplication)
        OPTIONAL MATCH (co)-[:IS_BORROWER_IN|IS_GUARANTOR_IN]->(lco:LoanApplication)
        RETURN
            c.name AS cliente,
            c.guarantor_score AS score,
            collect(DISTINCT co.name) AS empresas,
            collect(DISTINCT l.id) AS prestamos_directos,
            collect(DISTINCT lco.id) AS prestamos_via_empresa,
            sum(DISTINCT l.amount) + sum(DISTINCT lco.amount) AS exposicion_total
    """, {"name": client_name})

    print("\n--- EXPOSICION GRUPO ECONOMICO: " + client_name + " ---")
    for r in results:
        print("Cliente              : " + str(r["cliente"]))
        print("Score                : " + str(r["score"]))
        print("Empresas             : " + str(r["empresas"]))
        print("Prestamos directos   : " + str(r["prestamos_directos"]))
        print("Prestamos via empresa: " + str(r["prestamos_via_empresa"]))
        print("Exposicion total USD : " + str(r["exposicion_total"]))
    return results

if __name__ == "__main__":
    exposicion_grupo_economico(input("Name of the company: "))
    driver.close()
