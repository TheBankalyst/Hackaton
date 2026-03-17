-- db/init/02_seed.sql
-- Datos sintéticos fieles a la estructura real de TheBankalyst
-- El grafo oculto: persona → empresa → empresa está en los JSONB de filings_guarantor

-- ─────────────────────────────────────────────────────────
-- BANKS
-- ─────────────────────────────────────────────────────────

INSERT INTO bank (bank_uuid, name) VALUES
('a1000000-0000-0000-0000-000000000001', 'Sunrise Community Bank'),
('a1000000-0000-0000-0000-000000000002', 'Gulf Coast Capital'),
('a1000000-0000-0000-0000-000000000003', 'Heritage Trust Bank');

-- ─────────────────────────────────────────────────────────
-- ROLES
-- ─────────────────────────────────────────────────────────

INSERT INTO user_rol (role_uuid, name, description) VALUES
('e1000000-0000-0000-0000-000000000001', 'admin',        'Bank administrator'),
('e1000000-0000-0000-0000-000000000002', 'loan_officer', 'Loan officer'),
('e1000000-0000-0000-0000-000000000003', 'client',       'Bank client / borrower');

-- ─────────────────────────────────────────────────────────
-- CLIENTS  (15 borrowers)
-- ─────────────────────────────────────────────────────────

INSERT INTO client (id_bank, ssn, name, address, city, company, phone_number) VALUES
(1, '591-62-5001', 'Robert M. Harrington',  '142 Oak Lane',          'Miami',    'Harrington Holdings LLC',     '305-555-0101'),
(1, '591-62-5002', 'Sandra L. Vega',        '88 Coral Way',          'Miami',    NULL,                          '305-555-0102'),
(1, '591-62-5003', 'Carlos A. Reyes',       '301 Brickell Ave #12',  'Miami',    'Reyes Commercial Group',      '786-555-0103'),
(2, '591-62-5004', 'Jennifer K. Whitmore',  '55 Peachtree Rd',       'Atlanta',  'Whitmore Properties LLC',     '404-555-0104'),
(2, '591-62-5005', 'David T. Nguyen',       '900 Midtown Blvd',      'Atlanta',  NULL,                          '404-555-0105'),
(2, '591-62-5006', 'Patricia G. O''Brien',  '7 Magnolia Drive',      'Savannah', 'O''Brien Retail Inc',         '912-555-0106'),
(3, '591-62-5007', 'Michael J. Torres',     '1400 Congress Ave',     'Austin',   'Torres & Sons Realty',        '512-555-0107'),
(3, '591-62-5008', 'Linda R. Patel',        '22 Lamar Blvd',         'Austin',   NULL,                          '512-555-0108'),
(3, '591-62-5009', 'Brian W. Fontaine',     '67 Riverside Dr',       'Houston',  'Fontaine Capital LLC',        '713-555-0109'),
(1, '591-62-5010', 'Maria E. Santos',       '200 Flagler St',        'Miami',    'Santos Medical Group',        '305-555-0110'),
(2, '591-62-5011', 'Kevin D. Marsh',        '14 Perimeter Ctr',      'Atlanta',  'Marsh Industrial LLC',        '404-555-0111'),
(3, '591-62-5012', 'Angela C. Zhou',        '530 West 6th St',       'Austin',   NULL,                          '512-555-0112'),
(1, '591-62-5013', 'Thomas P. Kaplan',      '3300 Tigertail Ave',    'Miami',    'Kaplan Development Corp',     '305-555-0113'),
(2, '591-62-5014', 'Rosa N. Delgado',       '11 Sweet Auburn Ave',   'Atlanta',  'Delgado Foods Inc',           '404-555-0114'),
(3, '591-62-5015', 'Steven A. Webb',        '800 E 6th St',          'Austin',   'Webb Tech Ventures',          '512-555-0115');

-- ─────────────────────────────────────────────────────────
-- USERS
-- ─────────────────────────────────────────────────────────

INSERT INTO users (user_uuid, username, email, hashed_password, full_name, is_active, id_user_rol, id_client) VALUES
('a0000001-0000-0000-0000-000000000001', 'r.harrington', 'r.harrington@sunrise.demo', '$2b$12$placeholder01', 'Robert M. Harrington',  1, 3,  1),
('a0000001-0000-0000-0000-000000000002', 's.vega',        's.vega@sunrise.demo',       '$2b$12$placeholder02', 'Sandra L. Vega',         1, 3,  2),
('a0000001-0000-0000-0000-000000000003', 'c.reyes',       'c.reyes@sunrise.demo',      '$2b$12$placeholder03', 'Carlos A. Reyes',        1, 3,  3),
('a0000001-0000-0000-0000-000000000004', 'j.whitmore',    'j.whitmore@gulf.demo',      '$2b$12$placeholder04', 'Jennifer K. Whitmore',   1, 3,  4),
('a0000001-0000-0000-0000-000000000005', 'd.nguyen',      'd.nguyen@gulf.demo',        '$2b$12$placeholder05', 'David T. Nguyen',        1, 3,  5),
('a0000001-0000-0000-0000-000000000006', 'p.obrien',      'p.obrien@gulf.demo',        '$2b$12$placeholder06', 'Patricia G. O''Brien',   1, 3,  6),
('a0000001-0000-0000-0000-000000000007', 'm.torres',      'm.torres@heritage.demo',    '$2b$12$placeholder07', 'Michael J. Torres',      1, 3,  7),
('a0000001-0000-0000-0000-000000000008', 'l.patel',       'l.patel@heritage.demo',     '$2b$12$placeholder08', 'Linda R. Patel',         1, 3,  8),
('a0000001-0000-0000-0000-000000000009', 'b.fontaine',    'b.fontaine@heritage.demo',  '$2b$12$placeholder09', 'Brian W. Fontaine',      1, 3,  9),
('a0000001-0000-0000-0000-000000000010', 'm.santos',      'm.santos@sunrise.demo',     '$2b$12$placeholder10', 'Maria E. Santos',        1, 3, 10),
('a0000001-0000-0000-0000-000000000011', 'k.marsh',       'k.marsh@gulf.demo',         '$2b$12$placeholder11', 'Kevin D. Marsh',         1, 3, 11),
('a0000001-0000-0000-0000-000000000012', 'a.zhou',        'a.zhou@heritage.demo',      '$2b$12$placeholder12', 'Angela C. Zhou',         1, 3, 12),
('a0000001-0000-0000-0000-000000000013', 't.kaplan',      't.kaplan@sunrise.demo',     '$2b$12$placeholder13', 'Thomas P. Kaplan',       1, 3, 13),
('a0000001-0000-0000-0000-000000000014', 'r.delgado',     'r.delgado@gulf.demo',       '$2b$12$placeholder14', 'Rosa N. Delgado',        1, 3, 14),
('a0000001-0000-0000-0000-000000000015', 's.webb',        's.webb@heritage.demo',      '$2b$12$placeholder15', 'Steven A. Webb',         1, 3, 15),
('b9000000-0000-0000-0000-000000000001', 'lo.sunrise',    'officer@sunrise.demo',      '$2b$12$placeholderof1', 'James R. Callahan',     1, 2, NULL),
('b9000000-0000-0000-0000-000000000002', 'lo.gulf',       'officer@gulf.demo',         '$2b$12$placeholderof2', 'Diane P. Eckhart',      1, 2, NULL),
('b9000000-0000-0000-0000-000000000003', 'admin.sys',     'admin@bankalyst.demo',      '$2b$12$placeholderadm', 'System Admin',          1, 1, NULL);

-- ─────────────────────────────────────────────────────────
-- COMPANIES
-- Algunos clientes tienen 2 empresas — clave para el grafo
-- ─────────────────────────────────────────────────────────

INSERT INTO companies (client_uuid, name, ein) VALUES
-- Harrington: 2 empresas
('a0000001-0000-0000-0000-000000000001', 'Harrington Holdings LLC',     '45-7001001'),
('a0000001-0000-0000-0000-000000000001', 'Harrington Realty Trust',     '45-7001002'),
-- Reyes: 2 empresas
('a0000001-0000-0000-0000-000000000003', 'Reyes Commercial Group',      '45-7003001'),
('a0000001-0000-0000-0000-000000000003', 'Reyes Property Management',   '45-7003002'),
-- Resto: 1 empresa cada uno
('a0000001-0000-0000-0000-000000000004', 'Whitmore Properties LLC',     '45-7004001'),
('a0000001-0000-0000-0000-000000000006', 'O''Brien Retail Inc',         '45-7006001'),
('a0000001-0000-0000-0000-000000000007', 'Torres & Sons Realty',        '45-7007001'),
-- Fontaine: 2 empresas (aparecen en su Schedule E)
('a0000001-0000-0000-0000-000000000009', 'Fontaine Capital LLC',        '84-2308423'),
('a0000001-0000-0000-0000-000000000009', 'B & B Interior Services Inc', '45-5379058'),
('a0000001-0000-0000-0000-000000000010', 'Santos Medical Group',        '45-7010001'),
('a0000001-0000-0000-0000-000000000011', 'Marsh Industrial LLC',        '45-7011001'),
('a0000001-0000-0000-0000-000000000013', 'Kaplan Development Corp',     '45-7013001'),
('a0000001-0000-0000-0000-000000000014', 'Delgado Foods Inc',           '45-7014001'),
('a0000001-0000-0000-0000-000000000015', 'Webb Tech Ventures',          '45-7015001');

-- ─────────────────────────────────────────────────────────
-- FILINGS  (tax filings por empresa)
-- ─────────────────────────────────────────────────────────

INSERT INTO filings (company_id, form_type, year) VALUES
(1,  '1065',  2022), (1,  '1065',  2023),
(2,  '1065',  2023),
(3,  '1120S', 2022), (3,  '1120S', 2023),
(4,  '1120S', 2023),
(5,  '1065',  2023),
(7,  '1120S', 2023),
(8,  '1120S', 2022), (8,  '1120S', 2023),   -- Fontaine Capital
(9,  '1120S', 2022), (9,  '1120S', 2023),   -- B&B Interior (también en Schedule E de Fontaine)
(10, '1120S', 2023),
(11, '1120',  2023),
(12, '1120S', 2023),
(13, '1120',  2022), (13, '1120',  2023);

-- ─────────────────────────────────────────────────────────
-- FORM VERSIONS  (data JSONB fiel a la estructura real)
-- ─────────────────────────────────────────────────────────

INSERT INTO form_versions (filing_id, company_id, form_type, year, version, data) VALUES

-- Fontaine Capital LLC — 1120S 2023
(9, 8, '1120S', 2023, 1, '{
  "ein": "84-2308423",
  "year": 2023,
  "assets": "312,450.",
  "income": {
    "EBITDA": 38200.0,
    "Gross profit": 96400.0,
    "Total income": 96400.0,
    "Total deductions": 58200.0,
    "Balance (1a - 1b)": 96400.0,
    "Ordinary business income": 38200.0
  },
  "address": {
    "zip": "77002",
    "city": "HOUSTON",
    "state": "TX",
    "street": "67 RIVERSIDE DR"
  },
  "business_name": "FONTAINE CAPITAL LLC",
  "date_incorporated": "03/15/2015"
}'),

-- B & B Interior Services Inc — 1120S 2023
(11, 9, '1120S', 2023, 1, '{
  "ein": "45-5379058",
  "year": 2023,
  "assets": "205,802.",
  "income": {
    "Rents": 6620.0,
    "EBITDA": 74043.0,
    "Depreciation": 2075.0,
    "Gross profit": 191365.0,
    "Other income": 1040.0,
    "Total income": 192405.0,
    "Total deductions": 71968.0,
    "Balance (1a - 1b)": 289480.0,
    "Cost of goods sold": 98115.0,
    "Repairs and maintenance": 195.0,
    "Ordinary business income": 80858.0
  },
  "address": {
    "zip": "77002",
    "city": "HOUSTON",
    "state": "TX",
    "street": "67 RIVERSIDE DR SUITE 200"
  },
  "business_name": "B & B INTERIOR SERVICES INC",
  "date_incorporated": "02/10/2009"
}'),

-- B & B Interior Services Inc — 1120S 2022
(10, 9, '1120S', 2022, 1, '{
  "ein": "45-5379058",
  "year": 2022,
  "assets": "189,340.",
  "income": {
    "EBITDA": 61200.0,
    "Gross profit": 174800.0,
    "Total income": 174800.0,
    "Total deductions": 63400.0,
    "Ordinary business income": 61200.0
  },
  "address": {
    "zip": "77002",
    "city": "HOUSTON",
    "state": "TX",
    "street": "67 RIVERSIDE DR SUITE 200"
  },
  "business_name": "B & B INTERIOR SERVICES INC",
  "date_incorporated": "02/10/2009"
}'),

-- Harrington Holdings — 1065 2023
(2, 1, '1065', 2023, 1, '{
  "ein": "45-7001001",
  "year": 2023,
  "assets": "1,840,000.",
  "income": {
    "EBITDA": 185000.0,
    "Gross profit": 310000.0,
    "Total income": 310000.0,
    "Total deductions": 125000.0,
    "Ordinary business income": 185000.0
  },
  "address": {
    "zip": "33130",
    "city": "MIAMI",
    "state": "FL",
    "street": "142 OAK LANE"
  },
  "business_name": "HARRINGTON HOLDINGS LLC",
  "date_incorporated": "06/01/2010"
}'),

-- Reyes Commercial Group — 1120S 2023
(5, 3, '1120S', 2023, 1, '{
  "ein": "45-7003001",
  "year": 2023,
  "assets": "1,120,000.",
  "income": {
    "EBITDA": 142000.0,
    "Gross profit": 240000.0,
    "Total income": 240000.0,
    "Total deductions": 98000.0,
    "Ordinary business income": 142000.0
  },
  "address": {
    "zip": "33131",
    "city": "MIAMI",
    "state": "FL",
    "street": "301 BRICKELL AVE STE 12"
  },
  "business_name": "REYES COMMERCIAL GROUP",
  "date_incorporated": "11/20/2012"
}'),

-- Kaplan Development Corp — 1120 2023
(16, 13, '1120', 2023, 1, '{
  "ein": "45-7013001",
  "year": 2023,
  "assets": "6,200,000.",
  "income": {
    "EBITDA": 920000.0,
    "Gross profit": 1850000.0,
    "Total income": 1850000.0,
    "Total deductions": 930000.0,
    "Ordinary business income": 920000.0
  },
  "address": {
    "zip": "33133",
    "city": "MIAMI",
    "state": "FL",
    "street": "3300 TIGERTAIL AVE"
  },
  "business_name": "KAPLAN DEVELOPMENT CORP",
  "date_incorporated": "04/01/2005"
}');

-- ─────────────────────────────────────────────────────────
-- GUARANTORS
-- ─────────────────────────────────────────────────────────

INSERT INTO guarantors (client_uuid, status, score, year, version) VALUES
('a0000001-0000-0000-0000-000000000001', 'approved',  78.5, 2023, 1),
('a0000001-0000-0000-0000-000000000002', 'approved',  65.2, 2023, 1),
('a0000001-0000-0000-0000-000000000003', 'approved',  82.1, 2023, 2),
('a0000001-0000-0000-0000-000000000004', 'approved',  91.0, 2023, 1),
('a0000001-0000-0000-0000-000000000005', 'pending',   NULL, 2023, 1),
('a0000001-0000-0000-0000-000000000006', 'approved',  70.3, 2023, 1),
('a0000001-0000-0000-0000-000000000007', 'approved',  88.7, 2023, 1),
('a0000001-0000-0000-0000-000000000009', 'rejected',  44.1, 2023, 1),
('a0000001-0000-0000-0000-000000000010', 'approved',  76.9, 2023, 1),
('a0000001-0000-0000-0000-000000000011', 'pending',   NULL, 2023, 1),
('a0000001-0000-0000-0000-000000000013', 'approved',  55.0, 2023, 1),
('a0000001-0000-0000-0000-000000000014', 'approved',  83.4, 2023, 1);

-- ─────────────────────────────────────────────────────────
-- FILINGS_GUARANTOR
-- Aquí está el grafo oculto: schedule_e → entities
-- Fontaine aparece como socio de 2 S-Corps que TAMBIÉN
-- tienen sus propios filings en la tabla companies/form_versions
-- ─────────────────────────────────────────────────────────

INSERT INTO filings_guarantor (id, client_uuid, form_type, year, data, version) VALUES

-- Brian W. Fontaine — Form 1040 2023
-- Su Schedule E revela que es socio de:
--   45-5379058 = B & B Interior Services Inc  (empresa en companies)
--   84-2308423 = Fontaine Capital LLC         (empresa en companies)
-- En SQL esto es invisible. En un grafo es una relación directa.
('fg-fontaine-2023',
 'a0000001-0000-0000-0000-000000000009',
 'form_1040', 2023,
 '{
   "forms": {
     "form_1040": {
       "ssn": "591-62-5009",
       "year": 2023,
       "income": {
         "8.- Other income": 48516.0,
         "9.- Total income": 48516.0,
         "11.- Your adjusted gross income": 48516.0
       },
       "address": {
         "zip": "77002",
         "city": "HOUSTON",
         "state": "TX",
         "street": "67 RIVERSIDE DR"
       },
       "full_name": "BRIAN W. FONTAINE"
     },
     "schedule_1": {
       "income": {
         "8b.- Gambling winnings": 0.0,
         "9.- Total other income": 119021.0,
         "10.- Total additional income": 48516.0,
         "3.- Business income (Schedule C)": -6687.0,
         "5.- Rental, royalties, etc. (Schedule E)": 125708.0
       },
       "required_forms": [
         "Schedule E: Supplemental Income and Loss"
       ]
     },
     "schedule_e": {
       "totals": {
         "30.- Add columns (h) and (k) of line 29a": 80858.0,
         "31.- Add columns (g), (i), and (j) of line 29b": -6650.0,
         "32.- Total partnership and S corporation income or (loss)": 74208.0,
         "41.- Total income or (loss)": 74208.0
       },
       "entities": [
         {
           "ein": "45-5379058",
           "name": "B & B INTERIOR SERVICES INC",
           "type": "S",
           "nonpassive_income (k)": 80858.0
         },
         {
           "ein": "84-2308423",
           "name": "FONTAINE CAPITAL LLC",
           "type": "S",
           "nonpassive_loss (i)": 6650.0
         }
       ],
       "required_forms": [
         "Schedule K-1 required for B & B INTERIOR SERVICES INC",
         "Schedule K-1 required for FONTAINE CAPITAL LLC"
       ]
     }
   },
   "extracted_at": "2025-11-15T10:22:14.000000",
   "required_forms": [
     "Schedule K-1 required for B & B INTERIOR SERVICES INC",
     "Schedule K-1 required for FONTAINE CAPITAL LLC"
   ]
 }',
 1),

-- Robert M. Harrington — Form 1040 2023
-- Schedule E: socio de Harrington Holdings + Harrington Realty Trust
('fg-harrington-2023',
 'a0000001-0000-0000-0000-000000000001',
 'form_1040', 2023,
 '{
   "forms": {
     "form_1040": {
       "ssn": "591-62-5001",
       "year": 2023,
       "income": {
         "8.- Other income": 285000.0,
         "9.- Total income": 380000.0,
         "1.- Wages": 95000.0,
         "11.- Your adjusted gross income": 362000.0
       },
       "address": {
         "zip": "33130",
         "city": "MIAMI",
         "state": "FL",
         "street": "142 OAK LANE"
       },
       "full_name": "ROBERT M. HARRINGTON"
     },
     "schedule_1": {
       "income": {
         "9.- Total other income": 285000.0,
         "3.- Business income (Schedule C)": 0.0,
         "5.- Rental, royalties, etc. (Schedule E)": 285000.0
       },
       "required_forms": [
         "Schedule E: Supplemental Income and Loss"
       ]
     },
     "schedule_e": {
       "totals": {
         "32.- Total partnership and S corporation income": 285000.0,
         "41.- Total income or (loss)": 285000.0
       },
       "entities": [
         {
           "ein": "45-7001001",
           "name": "HARRINGTON HOLDINGS LLC",
           "type": "P",
           "nonpassive_income (k)": 185000.0
         },
         {
           "ein": "45-7001002",
           "name": "HARRINGTON REALTY TRUST",
           "type": "P",
           "nonpassive_income (k)": 100000.0
         }
       ],
       "required_forms": [
         "Schedule K-1 required for HARRINGTON HOLDINGS LLC",
         "Schedule K-1 required for HARRINGTON REALTY TRUST"
       ]
     }
   },
   "extracted_at": "2025-11-20T09:10:00.000000",
   "required_forms": [
     "Schedule K-1 required for HARRINGTON HOLDINGS LLC",
     "Schedule K-1 required for HARRINGTON REALTY TRUST"
   ]
 }',
 1),

-- Carlos A. Reyes — Form 1040 2023
-- Schedule E: socio de Reyes Commercial + Reyes Property Mgmt
('fg-reyes-2023',
 'a0000001-0000-0000-0000-000000000003',
 'form_1040', 2023,
 '{
   "forms": {
     "form_1040": {
       "ssn": "591-62-5003",
       "year": 2023,
       "income": {
         "8.- Other income": 210000.0,
         "9.- Total income": 282000.0,
         "1.- Wages": 72000.0,
         "11.- Your adjusted gross income": 268000.0
       },
       "address": {
         "zip": "33131",
         "city": "MIAMI",
         "state": "FL",
         "street": "301 BRICKELL AVE #12"
       },
       "full_name": "CARLOS A. REYES"
     },
     "schedule_e": {
       "totals": {
         "32.- Total partnership and S corporation income": 210000.0,
         "41.- Total income or (loss)": 210000.0
       },
       "entities": [
         {
           "ein": "45-7003001",
           "name": "REYES COMMERCIAL GROUP",
           "type": "S",
           "nonpassive_income (k)": 142000.0
         },
         {
           "ein": "45-7003002",
           "name": "REYES PROPERTY MANAGEMENT",
           "type": "S",
           "nonpassive_income (k)": 68000.0
         }
       ],
       "required_forms": [
         "Schedule K-1 required for REYES COMMERCIAL GROUP",
         "Schedule K-1 required for REYES PROPERTY MANAGEMENT"
       ]
     }
   },
   "extracted_at": "2025-11-22T11:30:00.000000",
   "required_forms": [
     "Schedule K-1 required for REYES COMMERCIAL GROUP",
     "Schedule K-1 required for REYES PROPERTY MANAGEMENT"
   ]
 }',
 1),

-- Thomas P. Kaplan — Form 1040 2023
('fg-kaplan-2023',
 'a0000001-0000-0000-0000-000000000013',
 'form_1040', 2023,
 '{
   "forms": {
     "form_1040": {
       "ssn": "591-62-5013",
       "year": 2023,
       "income": {
         "8.- Other income": 920000.0,
         "9.- Total income": 1020000.0,
         "1.- Wages": 100000.0,
         "11.- Your adjusted gross income": 980000.0
       },
       "address": {
         "zip": "33133",
         "city": "MIAMI",
         "state": "FL",
         "street": "3300 TIGERTAIL AVE"
       },
       "full_name": "THOMAS P. KAPLAN"
     },
     "schedule_e": {
       "totals": {
         "32.- Total partnership and S corporation income": 920000.0,
         "41.- Total income or (loss)": 920000.0
       },
       "entities": [
         {
           "ein": "45-7013001",
           "name": "KAPLAN DEVELOPMENT CORP",
           "type": "C",
           "nonpassive_income (k)": 920000.0
         }
       ],
       "required_forms": [
         "Schedule K-1 required for KAPLAN DEVELOPMENT CORP"
       ]
     }
   },
   "extracted_at": "2025-12-01T08:00:00.000000",
   "required_forms": [
     "Schedule K-1 required for KAPLAN DEVELOPMENT CORP"
   ]
 }',
 1);

-- ─────────────────────────────────────────────────────────
-- LOAN APPLICATIONS
-- ─────────────────────────────────────────────────────────

INSERT INTO loan_applications
    (id, user_uuid, transaction_type, loan_amount, purchase_price,
     property_address, property_county, property_use, property_occupancy,
     current_step, completion_percentage, status, created_at)
VALUES
('1a000001-0000-0000-0000-000000000001',
 'a0000001-0000-0000-0000-000000000001',
 'purchase', 1250000, 1600000,
 '2850 NW 7th St, Miami FL 33125', 'Miami-Dade', 'commercial', 'rented',
 'documents', 85.0, 'under_review', '2025-10-01'),

('1a000001-0000-0000-0000-000000000002',
 'a0000001-0000-0000-0000-000000000003',
 'refinance', 900000, NULL,
 '301 Brickell Ave #12, Miami FL', 'Miami-Dade', 'commercial', 'owner_occupied',
 'submitted', 90.0, 'submitted', '2025-10-15'),

('1a000001-0000-0000-0000-000000000003',
 'a0000001-0000-0000-0000-000000000004',
 'purchase', 2100000, 2700000,
 '10 Buckhead Loop, Atlanta GA 30305', 'Fulton', 'commercial', 'rented',
 'documents', 75.0, 'under_review', '2025-11-02'),

('1a000001-0000-0000-0000-000000000004',
 'a0000001-0000-0000-0000-000000000005',
 'purchase', 480000, 600000,
 '400 Ponce de Leon Ave, Atlanta GA', 'DeKalb', 'residential', 'owner_occupied',
 'documents', 60.0, 'draft', '2025-11-20'),

('1a000001-0000-0000-0000-000000000005',
 'a0000001-0000-0000-0000-000000000007',
 'purchase', 3400000, 4200000,
 '1800 S Congress Ave, Austin TX', 'Travis', 'commercial', 'rented',
 'submitted', 95.0, 'approved', '2025-09-10'),

('1a000001-0000-0000-0000-000000000006',
 'a0000001-0000-0000-0000-000000000009',
 'cashout', 650000, NULL,
 '67 Riverside Dr, Houston TX', 'Harris', 'commercial', 'owner_occupied',
 'documents', 50.0, 'rejected', '2025-08-22'),

('1a000001-0000-0000-0000-000000000007',
 'a0000001-0000-0000-0000-000000000010',
 'purchase', 720000, 900000,
 '1000 Brickell Bay Dr, Miami FL', 'Miami-Dade', 'commercial', 'rented',
 'documents', 70.0, 'under_review', '2025-11-05'),

('1a000001-0000-0000-0000-000000000008',
 'a0000001-0000-0000-0000-000000000013',
 'purchase', 5800000, 7200000,
 '3900 N Miami Ave, Miami FL', 'Miami-Dade', 'commercial', 'rented',
 'submitted', 92.0, 'submitted', '2025-12-01'),

('1a000001-0000-0000-0000-000000000009',
 'a0000001-0000-0000-0000-000000000014',
 'refinance', 310000, NULL,
 '90 Edgewood Ave, Atlanta GA', 'Fulton', 'commercial', 'owner_occupied',
 'documents', 65.0, 'under_review', '2025-11-18'),

('1a000001-0000-0000-0000-000000000010',
 'a0000001-0000-0000-0000-000000000002',
 'purchase', 560000, 700000,
 '1200 SW 22nd Ave, Miami FL', 'Miami-Dade', 'residential', 'owner_occupied',
 'transaction_type', 15.0, 'draft', '2025-12-10');

-- ─────────────────────────────────────────────────────────
-- LOAN PARTICIPANTS
-- ─────────────────────────────────────────────────────────

INSERT INTO loan_participants (application_id, display_name, role, is_entity, is_spouse, spouse_of) VALUES
('1a000001-0000-0000-0000-000000000001', 'Robert M. Harrington',     'borrower',  FALSE, FALSE, NULL),
('1a000001-0000-0000-0000-000000000001', 'Harrington Holdings LLC',  'guarantor', TRUE,  FALSE, NULL),
('1a000001-0000-0000-0000-000000000002', 'Carlos A. Reyes',          'borrower',  FALSE, FALSE, NULL),
('1a000001-0000-0000-0000-000000000002', 'Reyes Commercial Group',   'guarantor', TRUE,  FALSE, NULL),
('1a000001-0000-0000-0000-000000000003', 'Jennifer K. Whitmore',     'borrower',  FALSE, FALSE, NULL),
('1a000001-0000-0000-0000-000000000003', 'Whitmore Properties LLC',  'guarantor', TRUE,  FALSE, NULL),
('1a000001-0000-0000-0000-000000000003', 'Mark D. Whitmore',         'guarantor', FALSE, TRUE,  'Jennifer K. Whitmore'),
('1a000001-0000-0000-0000-000000000004', 'David T. Nguyen',          'borrower',  FALSE, FALSE, NULL),
('1a000001-0000-0000-0000-000000000005', 'Michael J. Torres',        'borrower',  FALSE, FALSE, NULL),
('1a000001-0000-0000-0000-000000000005', 'Torres & Sons Realty',     'guarantor', TRUE,  FALSE, NULL),
('1a000001-0000-0000-0000-000000000006', 'Brian W. Fontaine',        'borrower',  FALSE, FALSE, NULL),
('1a000001-0000-0000-0000-000000000006', 'Fontaine Capital LLC',     'guarantor', TRUE,  FALSE, NULL),
('1a000001-0000-0000-0000-000000000007', 'Maria E. Santos',          'borrower',  FALSE, FALSE, NULL),
('1a000001-0000-0000-0000-000000000008', 'Thomas P. Kaplan',         'borrower',  FALSE, FALSE, NULL),
('1a000001-0000-0000-0000-000000000008', 'Kaplan Development Corp',  'guarantor', TRUE,  FALSE, NULL),
('1a000001-0000-0000-0000-000000000009', 'Rosa N. Delgado',          'borrower',  FALSE, FALSE, NULL),
('1a000001-0000-0000-0000-000000000010', 'Sandra L. Vega',           'borrower',  FALSE, FALSE, NULL);

-- ─────────────────────────────────────────────────────────
-- PFS STATEMENTS  (4 clientes con PFS completo)
-- ─────────────────────────────────────────────────────────

INSERT INTO pfs_statement
    (id, user_uuid, client_ssn, client_name, business_phone, home_phone,
     business_name, business_address_line1, business_address_city,
     business_address_state, business_address_zip, business_type,
     information_date, status, is_locked)
VALUES
('pfs-harrington-2023',
 'a0000001-0000-0000-0000-000000000001',
 '591-62-5001', 'Robert M. Harrington',
 '305-555-0101', '305-555-9901',
 'Harrington Holdings LLC', '142 Oak Lane', 'Miami', 'FL', '33130',
 'Real Estate', '2023-12-31', 'approved', TRUE),

('pfs-reyes-2023',
 'a0000001-0000-0000-0000-000000000003',
 '591-62-5003', 'Carlos A. Reyes',
 '786-555-0103', '786-555-9903',
 'Reyes Commercial Group', '301 Brickell Ave #12', 'Miami', 'FL', '33131',
 'Commercial Real Estate', '2023-12-31', 'submitted', FALSE),

('pfs-whitmore-2023',
 'a0000001-0000-0000-0000-000000000004',
 '591-62-5004', 'Jennifer K. Whitmore',
 '404-555-0104', '404-555-9904',
 'Whitmore Properties LLC', '55 Peachtree Rd', 'Atlanta', 'GA', '30309',
 'Real Estate', '2023-12-31', 'approved', TRUE),

('pfs-fontaine-2023',
 'a0000001-0000-0000-0000-000000000009',
 '591-62-5009', 'Brian W. Fontaine',
 '713-555-0109', NULL,
 'Fontaine Capital LLC', '67 Riverside Dr', 'Houston', 'TX', '77002',
 'Investment', '2023-12-31', 'rejected', FALSE);

INSERT INTO assets
    (id, statement_id, cash_on_hand, savings_accounts, ira_retirement,
     accounts_receivable, stocks_bonds, real_estate, automobiles,
     life_insurance_cash_value, total_assets)
VALUES
('ast-harrington-2023', 'pfs-harrington-2023',  85000, 220000, 310000, 45000, 180000, 2400000, 65000,  95000, 3400000),
('ast-reyes-2023',      'pfs-reyes-2023',         42000, 110000, 190000, 28000,  65000, 1800000, 42000,  55000, 2332000),
('ast-whitmore-2023',   'pfs-whitmore-2023',     120000, 350000, 480000, 60000, 290000, 3100000, 85000, 120000, 4605000),
('ast-fontaine-2023',   'pfs-fontaine-2023',      18000,  55000,  80000,  9000,  22000,  640000, 28000,  15000,  867000);

INSERT INTO liabilities
    (id, statement_id, notes_payable, mortgages_on_real_estate,
     installment_account_auto, loans_against_life_insurance,
     total_liabilities, net_worth, total)
VALUES
('lib-harrington-2023', 'pfs-harrington-2023', 320000, 1400000, 28000, 40000, 1788000,  1612000, 3400000),
('lib-reyes-2023',      'pfs-reyes-2023',       180000,  980000, 18000, 22000, 1200000,  1132000, 2332000),
('lib-whitmore-2023',   'pfs-whitmore-2023',    250000, 1650000, 35000, 55000, 1990000,  2615000, 4605000),
('lib-fontaine-2023',   'pfs-fontaine-2023',    410000,  550000, 22000, 12000,  994000,  -127000,  867000);

INSERT INTO income
    (id, statement_id, line_1_wages, line_3_dividends, line_7_capital_gains,
     schedule_1_line_3_business_income, schedule_1_line_5_rental_income,
     line_8_other_income, line_9_total_income)
VALUES
('inc-harrington-2023', 'pfs-harrington-2023',  95000, 18000, 32000, 285000, 148000, 433000, 578000),
('inc-reyes-2023',      'pfs-reyes-2023',        72000,  8500, 14000, 210000,  96000, 306000, 400500),
('inc-whitmore-2023',   'pfs-whitmore-2023',    110000, 24000, 45000, 380000, 210000, 590000, 769000),
('inc-fontaine-2023',   'pfs-fontaine-2023',     48000,  2000,  5000,  74208,      0,  74208, 129208);

INSERT INTO real_estate
    (id, statement_id, property_label, property_type,
     address_line1, address_city, address_state, address_zip,
     original_cost, present_market_value, mortgage_balance,
     payment_per_month, mortgage_status)
VALUES
('re-harr-01', 'pfs-harrington-2023', 'A', 'Primary Residence',
 '142 Oak Lane', 'Miami', 'FL', '33130', 850000, 1200000, 680000, 5800, 'current'),
('re-harr-02', 'pfs-harrington-2023', 'B', 'Rental Property',
 '2850 NW 7th St', 'Miami', 'FL', '33125', 900000, 1200000, 720000, 6200, 'current'),
('re-reyes-01', 'pfs-reyes-2023', 'A', 'Primary Residence',
 '301 Brickell Ave #12', 'Miami', 'FL', '33131', 620000, 850000, 490000, 4100, 'current'),
('re-reyes-02', 'pfs-reyes-2023', 'B', 'Commercial Property',
 '444 NW 2nd Ave', 'Miami', 'FL', '33128', 750000, 950000, 490000, 4900, 'current'),
('re-whit-01', 'pfs-whitmore-2023', 'A', 'Primary Residence',
 '55 Peachtree Rd', 'Atlanta', 'GA', '30309', 980000, 1400000, 720000, 7100, 'current'),
('re-whit-02', 'pfs-whitmore-2023', 'B', 'Rental Property',
 '10 Buckhead Loop', 'Atlanta', 'GA', '30305', 1200000, 1700000, 930000, 8500, 'current'),
('re-font-01', 'pfs-fontaine-2023', 'A', 'Commercial Property',
 '67 Riverside Dr', 'Houston', 'TX', '77002', 520000, 640000, 550000, 4400, 'delinquent');

-- ─────────────────────────────────────────────────────────
-- RENT ROLLS
-- ─────────────────────────────────────────────────────────

INSERT INTO rentroll_extractions
    (user_uuid, suite, tenant_name, landlord_name, sf,
     start_date, end_date, base_rent, security_deposit, lease_type, escalation)
VALUES
('a0000001-0000-0000-0000-000000000001', '101', 'Bright Dental Studio',     'Harrington Holdings LLC',     1800, '2022-01-01', '2025-12-31',  4500,  9000, 'NNN',          '3% annual'),
('a0000001-0000-0000-0000-000000000001', '102', 'Atlas Insurance Agency',   'Harrington Holdings LLC',     1200, '2023-03-01', '2026-02-28',  3200,  6400, 'NNN',          '2.5% annual'),
('a0000001-0000-0000-0000-000000000001', '103', 'Verde Coffee Bar',          'Harrington Holdings LLC',      900, '2021-06-01', '2024-05-31',  2400,  4800, 'Gross',        'CPI'),
('a0000001-0000-0000-0000-000000000004', '201', 'Whitmore Law Partners',    'Whitmore Properties LLC',     3200, '2020-01-01', '2027-12-31', 11200, 22400, 'NNN',          '3% annual'),
('a0000001-0000-0000-0000-000000000004', '202', 'Peach State Logistics',    'Whitmore Properties LLC',     2400, '2022-07-01', '2025-06-30',  7200, 14400, 'NNN',          'Fixed'),
('a0000001-0000-0000-0000-000000000007', '1A',  'Lone Star Fitness',        'Torres & Sons Realty',        4100, '2021-01-01', '2025-12-31', 10250, 20500, 'NNN',          '3% annual'),
('a0000001-0000-0000-0000-000000000007', '1B',  'Austin Craft Brewing',     'Torres & Sons Realty',        2800, '2023-01-01', '2027-12-31',  8400, 16800, 'Modified Gross','CPI'),
('a0000001-0000-0000-0000-000000000009', '501', 'Gulf Industrial Supply',   'Fontaine Capital LLC',        6200, '2019-06-01', '2024-05-31', 12400, 24800, 'NNN',          '2% annual'),
('a0000001-0000-0000-0000-000000000013', '301', 'Kaplan Offices Tenant A',  'Kaplan Development Corp',     5000, '2022-01-01', '2026-12-31', 18500, 37000, 'NNN',          '3% annual'),
('a0000001-0000-0000-0000-000000000013', '302', 'Kaplan Offices Tenant B',  'Kaplan Development Corp',     3500, '2023-06-01', '2026-05-31', 13500, 27000, 'NNN',          '3% annual');