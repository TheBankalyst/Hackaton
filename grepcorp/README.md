# GrepCorp - Bankalyst Innovation Summit 2026

## Reto 1: Ontology Database - Reimaginando el Core de TheBankalyst

## Descripcion

Implementacion de una base de datos de grafos sobre el sistema de originacion
de prestamos comerciales inmobiliarios de TheBankalyst, demostrando ventajas
reales sobre SQL para analisis de riesgo crediticio.

## Stack

- PostgreSQL 16 (fuente de datos)
- Neo4j (base de datos de grafos)
- Python 3.14
- psycopg2-binary
- neo4j driver
- python-dotenv

## Estructura
```
grepcorp/
  migrate.py        migracion de PostgreSQL a Neo4j
  queries.py        consultas de exposicion de riesgo
  requirements.txt  dependencias
  README.md         este archivo
```

## Setup

1. Instalar dependencias:
```
pip install -r requirements.txt
```

2. Crear archivo .env con las credenciales:
```
PG_HOST=localhost
PG_PORT=5432
PG_DB=bankalyst_demo
PG_USER=demo_reader
PG_PASSWORD=readonlybk2026

NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=grepcorp2026
```

3. Correr la migracion:
```
python migrate.py
```

4. Correr las queries:
```
python queries.py
```

## Funcionalidad implementada

### Exposicion total del banco a un grupo economico (n saltos)

Dado el nombre de un cliente, la query recorre el grafo en 3 saltos y retorna:

- Empresas que controla directamente
- Empresas vinculadas via Schedule E (declaracion de impuestos personal)
- Prestamos directos del cliente
- Prestamos de sus empresas
- Exposicion total del banco al grupo economico en dolares

## Ventaja sobre SQL

En SQL: 5 queries separados con joins manuales entre tablas relacionales
y logica adicional para extraer datos de columnas JSONB.

En el grafo: una sola consulta de 3 saltos que escala a n saltos si la red
de control es mas profunda, sin reescribir la logica.
