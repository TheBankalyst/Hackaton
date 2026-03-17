# Bankalyst Innovation Summit 2026 — Hackathon Reto #1
## Ontology Database: Reimaginando el Core de TheBankalyst

---

## Inicio rápido

Requisitos: [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado.

```bash
git clone https://github.com/bankalyst/hackathon-2026-reto1
cd hackathon-2026-reto1
docker compose up -d
```

La base de datos estará lista en ~20 segundos. Verifica con:

```bash
docker compose ps
# bankalyst_demo debe estar "healthy"
```

### Conexión a la BD demo

| Parámetro | Valor |
|---|---|
| Host | `localhost` |
| Puerto | `5432` |
| Base de datos | `bankalyst_demo` |
| Usuario (lectura) | `demo_reader` |
| Password | `readonlybk2026` |

String de conexión:
```
postgresql://demo_reader:readonlybk2026@localhost:5432/bankalyst_demo
```

**pgAdmin** (UI web): [http://localhost:5050](http://localhost:5050)
- Email: `admin@bankalyst.demo`  
- Password: `bankalyst2026`

---

## El sistema que estás viendo

Esta BD es una versión unificada del sistema real de **TheBankalyst**, una plataforma
de originación de préstamos comerciales inmobiliarios. En producción los datos viven
en 6 microservicios independientes. Aquí los tienes en una sola PostgreSQL.

### Mapa de tablas

```
IDENTIDAD
  bank                   → Los 3 bancos del sistema
  user_rol               → Roles: admin, loan_officer, client
  client                 → 15 borrowers / clientes
  users                  → Cuentas de acceso de cada persona
  user_bank_role         → Qué rol tiene cada usuario en cada banco

EMPRESAS Y TAXES
  companies              → Empresas vinculadas a los clientes
  filings                → Declaraciones fiscales por empresa (1065, 1120S, 1120)
  form_versions          → Data completa del tax return en JSONB

GARANTÍAS
  guarantors             → Score y status de garantía de cada cliente
  filings_guarantor      → Tax return personal (Form 1040) con Schedule E en JSONB

SOLICITUDES DE PRÉSTAMO
  loan_applications      → 10 solicitudes con status y datos del inmueble
  loan_participants      → Borrowers y guarantors de cada solicitud
  loan_documents         → Documentos requeridos / recibidos

ESTADO FINANCIERO PERSONAL (PFS)
  pfs_statement          → SBA Personal Financial Statement header
  assets                 → Activos totales del PFS
  liabilities            → Pasivos totales del PFS
  income                 → Ingresos (Form 1040 lines)
  real_estate            → Propiedades detalladas
  stocks_bonds           → Portafolio de inversiones
  notes_payable          → Pagarés
  life_insurance         → Seguros de vida
  other_assets           → Otros activos
  unpaid_taxes           → Impuestos atrasados
  other_liabilities      → Otros pasivos
  contingent_liabilities → Pasivos contingentes

RENTAS
  rentroll_extractions   → Inquilinos, rentas y fechas de contratos
```

---

## El grafo oculto

Hay información crítica **enterrada en los JSONB** de `filings_guarantor.data`
que en una BD relacional es invisible para el banco:

```sql
-- ¿Qué empresas controla Brian Fontaine?
SELECT
    fg.data -> 'forms' -> 'schedule_e' -> 'entities' AS empresas_vinculadas
FROM filings_guarantor fg
WHERE fg.client_uuid = 'c1000001-0000-0000-0000-000000000009';
```

El resultado muestra que Fontaine es socio de **dos S-Corps**:
- `45-5379058` → B & B Interior Services Inc (también en `companies`)
- `84-2308423` → Fontaine Capital LLC (también en `companies`)

Ahora la pregunta que SQL no puede responder fácilmente:

> El banco tiene un préstamo rechazado de Fontaine (score 44.1).
> Fontaine controla dos empresas que tienen sus propios filings en el sistema.
> ¿Cuál es la exposición **real** del banco al grupo económico Fontaine?
> ¿Esas mismas empresas aparecen como garantors en otros préstamos?

**En SQL**: múltiples queries, joins manuales entre JSONB y tablas relacionales,
lógica de deduplicación ad-hoc, sin garantía de completitud.

**En un grafo**: una sola query de 3 saltos.

---

## Tu reto

1. **Importa los datos** de esta BD a la Ontology/Graph Database de tu elección
   (Neo4j, TypeDB, Amazon Neptune, TerminusDB, o cualquier otra)

2. **Modela el grafo** — define qué son nodos y qué son relaciones en tu dominio.
   Ejemplo mínimo:
   ```
   (Client)-[:CONTROLS]->(Company)
   (Client)-[:IS_BORROWER_IN]->(LoanApplication)
   (Company)-[:IS_GUARANTOR_IN]->(LoanApplication)
   (Client)-[:HAS_SCHEDULE_E_INCOME_FROM]->(Company)
   ```

3. **Implementa al menos una función** que demuestre una ventaja real sobre SQL.
   Ejemplos de funciones válidas:
   - Calcular la exposición total del banco a un grupo económico (n saltos)
   - Detectar garantías cruzadas entre clientes del mismo banco
   - Trazar la red de control efectivo de una empresa
   - Identificar concentración de riesgo por sector o geografía

4. **Demuéstralo en vivo** — 5 minutos ante el jurado con código corriendo contra
   la base de datos real (no mockups, no slides de arquitectura sin demo)

---

## Queries de calentamiento

Familiarízate con los datos antes de empezar a modelar:

```sql
-- Clientes con más de una empresa
SELECT c.name, COUNT(co.id_company) AS num_companies
FROM client c
JOIN users u ON u.id_client = c.id_client
JOIN companies co ON co.client_uuid = u.user_uuid
GROUP BY c.name HAVING COUNT(co.id_company) > 1;

-- Estado de préstamos con score del guarantor
SELECT c.name, la.loan_amount, la.status, g.score, g.status AS guarantor_status
FROM loan_applications la
JOIN users u ON u.user_uuid = la.user_uuid
JOIN client c ON c.id_client = u.id_client
LEFT JOIN guarantors g ON g.client_uuid = la.user_uuid
ORDER BY la.loan_amount DESC;

-- Extraer las empresas del Schedule E de cada garantor
SELECT
    c.name AS guarantor,
    entity ->> 'name' AS empresa_vinculada,
    entity ->> 'ein'  AS ein
FROM filings_guarantor fg
JOIN users u ON u.user_uuid::text = fg.client_uuid
JOIN client c ON c.id_client = u.id_client,
LATERAL jsonb_array_elements(
    fg.data -> 'forms' -> 'schedule_e' -> 'entities'
) AS entity;

-- Rent roll: ingreso mensual por landlord
SELECT landlord_name, COUNT(*) AS units,
       SUM(sf) AS total_sf, SUM(base_rent) AS monthly_income
FROM rentroll_extractions
GROUP BY landlord_name ORDER BY monthly_income DESC;
```

---

## Cómo entregar

1. Crea una rama con el nombre de tu equipo:
   ```bash
   git checkout -b team/nombre-del-equipo
   ```

2. Trabaja en tu rama. Haz commits frecuentes — el jurado puede ver tu proceso.

3. Antes del **freeze de código (15:00)**, haz push:
   ```bash
   git push origin team/nombre-del-equipo
   ```

4. Tu rama debe incluir:
   - El código de importación / migración de datos al grafo
   - Las queries o funciones que implementaste
   - Un `README.md` en tu carpeta explicando cómo correr tu solución
   - El output de tu demo (screenshot, log, o video corto)

---

## Recursos

| Herramienta | Link |
|---|---|
| Neo4j AuraDB (free) | https://neo4j.com/cloud/aura-free/ |
| Neo4j Cypher cheat sheet | https://neo4j.com/docs/cypher-cheat-sheet/ |
| TypeDB Cloud | https://cloud.typedb.com |
| TypeQL overview | https://typedb.com/docs/typeql/overview |
| Amazon Neptune Serverless | https://aws.amazon.com/neptune/ |
| TerminusDB (local) | https://terminusdb.com/docs/ |
| py2neo (Neo4j + Python) | https://py2neo.org/ |
| neo4j driver (Node.js) | https://neo4j.com/docs/javascript-manual/current/ |