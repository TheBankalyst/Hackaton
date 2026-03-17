-- db/init/01_schema.sql
-- Bankalyst Innovation Summit 2026 — Hackathon Reto #1
-- Schema unificado de los 6 microservicios de TheBankalyst

-- ─────────────────────────────────────────────────────────
-- CORE: BANKS · ROLES · CLIENTS · USERS
-- ─────────────────────────────────────────────────────────

CREATE TABLE bank (
    id_bank   SERIAL PRIMARY KEY,
    bank_uuid UUID   UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    name      VARCHAR NOT NULL UNIQUE
);

CREATE TABLE user_rol (
    id_user_rol SERIAL PRIMARY KEY,
    role_uuid   UUID   UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    name        VARCHAR(50)  NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE client (
    id_client    SERIAL PRIMARY KEY,
    id_bank      INTEGER REFERENCES bank(id_bank),
    ssn          VARCHAR UNIQUE,
    name         VARCHAR NOT NULL,
    address      VARCHAR NOT NULL,
    city         VARCHAR NOT NULL,
    company      VARCHAR,
    phone_number VARCHAR
);

CREATE TABLE users (
    id              SERIAL PRIMARY KEY,
    user_uuid       UUID    UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    username        VARCHAR UNIQUE NOT NULL,
    email           VARCHAR UNIQUE NOT NULL,
    hashed_password VARCHAR NOT NULL,
    full_name       VARCHAR,
    is_active       INTEGER DEFAULT 1,
    id_user_rol     INTEGER NOT NULL REFERENCES user_rol(id_user_rol),
    id_client       INTEGER REFERENCES client(id_client)
);

CREATE TABLE user_bank_role (
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    bank_id     INTEGER NOT NULL REFERENCES bank(id_bank) ON DELETE CASCADE,
    id_user_rol INTEGER NOT NULL REFERENCES user_rol(id_user_rol) ON DELETE CASCADE,
    is_active   BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE (user_id, bank_id)
);

CREATE TABLE user_role_assignment (
    id          SERIAL PRIMARY KEY,
    id_user     INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    id_user_rol INTEGER NOT NULL REFERENCES user_rol(id_user_rol) ON DELETE CASCADE,
    client_scope JSONB,
    doc_scope    JSONB,
    created_at  TIMESTAMP DEFAULT NOW(),
    UNIQUE (id_user, id_user_rol)
);

-- ─────────────────────────────────────────────────────────
-- COMPANIES & TAX FILINGS  (CompanyService)
-- form_versions.data contiene el JSON completo del formulario
-- ─────────────────────────────────────────────────────────

CREATE TABLE companies (
    id_company  SERIAL PRIMARY KEY,
    client_uuid UUID    NOT NULL,
    name        VARCHAR NOT NULL,
    ein         VARCHAR,
    created_at  TIMESTAMP DEFAULT NOW(),
    updated_at  TIMESTAMP DEFAULT NOW(),
    UNIQUE (client_uuid, name)
);

CREATE TABLE filings (
    id_filing  SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES companies(id_company) ON DELETE CASCADE,
    form_type  VARCHAR NOT NULL,
    year       INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE (company_id, form_type, year)
);

CREATE TABLE form_versions (
    id_version SERIAL PRIMARY KEY,
    filing_id  INTEGER NOT NULL REFERENCES filings(id_filing) ON DELETE CASCADE,
    company_id INTEGER NOT NULL REFERENCES companies(id_company) ON DELETE CASCADE,
    form_type  VARCHAR NOT NULL,
    year       INTEGER NOT NULL,
    version    INTEGER NOT NULL DEFAULT 1,
    data       JSONB   NOT NULL DEFAULT '{}',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE (company_id, form_type, year, version)
);

-- ─────────────────────────────────────────────────────────
-- GUARANTORS  (GuarantorService)
-- filings_guarantor.data contiene el JSON del tax return personal
-- ─────────────────────────────────────────────────────────

CREATE TABLE guarantors (
    id          SERIAL PRIMARY KEY,
    client_uuid UUID    NOT NULL,
    status      VARCHAR NOT NULL DEFAULT 'pending',
    score       FLOAT,
    year        INTEGER,
    version     INTEGER DEFAULT 1,
    updated_at  TIMESTAMP DEFAULT NOW()
);

CREATE TABLE filings_guarantor (
    id          VARCHAR PRIMARY KEY,
    client_uuid VARCHAR NOT NULL,
    form_type   VARCHAR NOT NULL,
    year        INTEGER NOT NULL,
    data        JSONB   NOT NULL,
    version     INTEGER DEFAULT 1,
    created_at  TIMESTAMP DEFAULT NOW(),
    updated_at  TIMESTAMP DEFAULT NOW()
);

-- ─────────────────────────────────────────────────────────
-- LOAN APPLICATIONS  (LoanApplicationService)
-- ─────────────────────────────────────────────────────────

CREATE TABLE loan_applications (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_uuid             UUID NOT NULL,
    transaction_type      VARCHAR,
    loan_amount           FLOAT,
    purchase_price        FLOAT,
    mortgage_to_refinance FLOAT,
    mortgage_to_pay       FLOAT,
    cash_out_amount       FLOAT,
    cash_out_purpose      VARCHAR,
    property_folio        VARCHAR,
    property_address      VARCHAR,
    property_county       VARCHAR,
    property_use          VARCHAR,
    property_occupancy    VARCHAR,
    current_step          VARCHAR NOT NULL DEFAULT 'transaction_type',
    completion_percentage FLOAT   NOT NULL DEFAULT 0.0,
    status                VARCHAR NOT NULL DEFAULT 'draft',
    created_at            TIMESTAMP DEFAULT NOW(),
    updated_at            TIMESTAMP DEFAULT NOW()
);

CREATE TABLE loan_participants (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    application_id UUID    NOT NULL REFERENCES loan_applications(id) ON DELETE CASCADE,
    display_name   VARCHAR NOT NULL,
    raw_name       VARCHAR,
    role           VARCHAR,
    is_entity      BOOLEAN NOT NULL DEFAULT FALSE,
    is_spouse      BOOLEAN NOT NULL DEFAULT FALSE,
    spouse_of      VARCHAR,
    created_at     TIMESTAMP DEFAULT NOW()
);

CREATE TABLE loan_documents (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    application_id UUID    NOT NULL REFERENCES loan_applications(id) ON DELETE CASCADE,
    participant_id UUID    REFERENCES loan_participants(id) ON DELETE CASCADE,
    document_key   VARCHAR NOT NULL,
    document_name  VARCHAR NOT NULL,
    years          JSONB,
    is_optional    BOOLEAN NOT NULL DEFAULT FALSE,
    is_received    BOOLEAN NOT NULL DEFAULT FALSE,
    received_at    TIMESTAMP,
    blob_url       VARCHAR,
    created_at     TIMESTAMP DEFAULT NOW(),
    updated_at     TIMESTAMP DEFAULT NOW()
);

-- ─────────────────────────────────────────────────────────
-- PERSONAL FINANCIAL STATEMENTS  (PFSService)
-- ─────────────────────────────────────────────────────────

CREATE TABLE pfs_statement (
    id                     VARCHAR PRIMARY KEY,
    user_uuid              VARCHAR(36) NOT NULL,
    client_ssn             VARCHAR(20) NOT NULL,
    client_name            VARCHAR(255) NOT NULL,
    business_phone         VARCHAR(20),
    home_phone             VARCHAR(20),
    business_name          VARCHAR(255),
    business_address_line1 VARCHAR(255),
    business_address_city  VARCHAR(100),
    business_address_state VARCHAR(2),
    business_address_zip   VARCHAR(20),
    business_type          VARCHAR(50),
    wosb_applicant_married BOOLEAN DEFAULT FALSE,
    information_date       DATE NOT NULL,
    status                 VARCHAR NOT NULL DEFAULT 'draft',
    submitted_at           TIMESTAMP,
    reviewed_at            TIMESTAMP,
    reviewed_by            VARCHAR(36),
    approval_notes         TEXT,
    rejection_reason       TEXT,
    is_locked              BOOLEAN DEFAULT FALSE,
    locked_at              TIMESTAMP,
    locked_by              VARCHAR(36),
    created_at             TIMESTAMP DEFAULT NOW(),
    updated_at             TIMESTAMP DEFAULT NOW()
);

CREATE TABLE assets (
    id                        VARCHAR PRIMARY KEY,
    statement_id              VARCHAR NOT NULL REFERENCES pfs_statement(id),
    cash_on_hand              NUMERIC(15,2) DEFAULT 0,
    savings_accounts          NUMERIC(15,2) DEFAULT 0,
    ira_retirement            NUMERIC(15,2) DEFAULT 0,
    accounts_receivable       NUMERIC(15,2) DEFAULT 0,
    life_insurance_cash_value NUMERIC(15,2) DEFAULT 0,
    stocks_bonds              NUMERIC(15,2) DEFAULT 0,
    real_estate               NUMERIC(15,2) DEFAULT 0,
    automobiles               NUMERIC(15,2) DEFAULT 0,
    other_personal_property   NUMERIC(15,2) DEFAULT 0,
    other_assets              NUMERIC(15,2) DEFAULT 0,
    total_assets              NUMERIC(15,2) DEFAULT 0
);

CREATE TABLE liabilities (
    id                           VARCHAR PRIMARY KEY,
    statement_id                 VARCHAR NOT NULL REFERENCES pfs_statement(id),
    accounts_payable             NUMERIC(15,2) DEFAULT 0,
    notes_payable                NUMERIC(15,2) DEFAULT 0,
    installment_account_auto     NUMERIC(15,2) DEFAULT 0,
    monthly_payments_auto        NUMERIC(15,2) DEFAULT 0,
    installment_account_other    NUMERIC(15,2) DEFAULT 0,
    monthly_payments_other       NUMERIC(15,2) DEFAULT 0,
    loans_against_life_insurance NUMERIC(15,2) DEFAULT 0,
    mortgages_on_real_estate     NUMERIC(15,2) DEFAULT 0,
    unpaid_taxes                 NUMERIC(15,2) DEFAULT 0,
    other_liabilities            NUMERIC(15,2) DEFAULT 0,
    total_liabilities            NUMERIC(15,2) DEFAULT 0,
    net_worth                    NUMERIC(15,2) DEFAULT 0,
    total                        NUMERIC(15,2) DEFAULT 0
);

CREATE TABLE income (
    id                                VARCHAR PRIMARY KEY,
    statement_id                      VARCHAR NOT NULL REFERENCES pfs_statement(id),
    line_1_wages                      NUMERIC(15,2) DEFAULT 0,
    line_2_tax_exempt_interest        NUMERIC(15,2) DEFAULT 0,
    line_3_dividends                  NUMERIC(15,2) DEFAULT 0,
    line_4_ira_distributions          NUMERIC(15,2) DEFAULT 0,
    line_5_pensions_annuities         NUMERIC(15,2) DEFAULT 0,
    line_6_social_security            NUMERIC(15,2) DEFAULT 0,
    line_7_capital_gains              NUMERIC(15,2) DEFAULT 0,
    line_8_other_income               NUMERIC(15,2) DEFAULT 0,
    line_9_total_income               NUMERIC(15,2) DEFAULT 0,
    schedule_1_line_3_business_income NUMERIC(15,2) DEFAULT 0,
    schedule_1_line_5_rental_income   NUMERIC(15,2) DEFAULT 0,
    other_income_description          TEXT
);

CREATE TABLE contingent_liabilities (
    id                           VARCHAR PRIMARY KEY,
    statement_id                 VARCHAR NOT NULL REFERENCES pfs_statement(id),
    as_endorser_comaker          NUMERIC(15,2) DEFAULT 0,
    legal_claims_judgments       TEXT,
    legal_claims_amount          NUMERIC(15,2) DEFAULT 0,
    provision_federal_income_tax NUMERIC(15,2) DEFAULT 0,
    other_special_debt           TEXT,
    other_special_debt_amount    NUMERIC(15,2) DEFAULT 0,
    total_contingent             NUMERIC(15,2) DEFAULT 0
);

CREATE TABLE notes_payable (
    id                 VARCHAR PRIMARY KEY,
    statement_id       VARCHAR NOT NULL REFERENCES pfs_statement(id),
    noteholder_name    VARCHAR(255) NOT NULL,
    noteholder_address TEXT,
    original_balance   NUMERIC(15,2),
    current_balance    NUMERIC(15,2),
    payment_amount     NUMERIC(15,2),
    frequency          VARCHAR(20) DEFAULT 'monthly',
    collateral_type    TEXT
);

CREATE TABLE stocks_bonds (
    id                     VARCHAR PRIMARY KEY,
    statement_id           VARCHAR NOT NULL REFERENCES pfs_statement(id),
    security_name          VARCHAR(255) NOT NULL,
    number_of_shares       NUMERIC(15,4),
    cost                   NUMERIC(15,2),
    market_value_per_share NUMERIC(15,4),
    quotation_date         DATE,
    total_value            NUMERIC(15,2)
);

CREATE TABLE real_estate (
    id                      VARCHAR PRIMARY KEY,
    statement_id            VARCHAR NOT NULL REFERENCES pfs_statement(id),
    property_label          VARCHAR(10),
    property_type           VARCHAR(100),
    address_line1           VARCHAR(255),
    address_city            VARCHAR(100),
    address_state           VARCHAR(2),
    address_zip             VARCHAR(20),
    date_purchased          DATE,
    original_cost           NUMERIC(15,2),
    present_market_value    NUMERIC(15,2),
    assessed_value          NUMERIC(15,2),
    mortgage_holder_name    VARCHAR(255),
    mortgage_holder_address TEXT,
    mortgage_account_number VARCHAR(100),
    mortgage_balance        NUMERIC(15,2),
    payment_per_month       NUMERIC(15,2),
    payment_per_year        NUMERIC(15,2),
    mortgage_status         VARCHAR(50) DEFAULT 'current'
);

CREATE TABLE other_assets (
    id                      VARCHAR PRIMARY KEY,
    statement_id            VARCHAR NOT NULL REFERENCES pfs_statement(id),
    asset_description       TEXT    NOT NULL,
    estimated_value         NUMERIC(15,2),
    is_pledged_security     BOOLEAN DEFAULT FALSE,
    lien_holder_name        VARCHAR(255),
    lien_holder_address     TEXT,
    lien_amount             NUMERIC(15,2) DEFAULT 0,
    payment_terms           TEXT,
    is_delinquent           BOOLEAN DEFAULT FALSE,
    delinquency_description TEXT
);

CREATE TABLE unpaid_taxes (
    id                   VARCHAR PRIMARY KEY,
    statement_id         VARCHAR NOT NULL REFERENCES pfs_statement(id),
    tax_type             VARCHAR(100) NOT NULL,
    payable_to           VARCHAR(255) NOT NULL,
    due_date             DATE,
    amount_owed          NUMERIC(15,2) NOT NULL,
    penalty_interest     NUMERIC(15,2) DEFAULT 0,
    property_affected    TEXT,
    lien_attached        VARCHAR DEFAULT 'No',
    lien_details         TEXT,
    payment_plan         VARCHAR DEFAULT 'No',
    payment_plan_details TEXT
);

CREATE TABLE other_liabilities (
    id                    VARCHAR PRIMARY KEY,
    statement_id          VARCHAR NOT NULL REFERENCES pfs_statement(id),
    liability_description TEXT    NOT NULL,
    creditor_name         VARCHAR(255),
    creditor_address      TEXT,
    amount_owed           NUMERIC(15,2) NOT NULL,
    original_amount       NUMERIC(15,2),
    due_date              DATE,
    payment_terms         TEXT,
    interest_rate         NUMERIC(5,2),
    is_secured            VARCHAR DEFAULT 'No',
    collateral_description TEXT,
    is_current            VARCHAR DEFAULT 'Yes',
    delinquency_details   TEXT
);

CREATE TABLE life_insurance (
    id                       VARCHAR PRIMARY KEY,
    statement_id             VARCHAR NOT NULL REFERENCES pfs_statement(id),
    insurance_company        VARCHAR(255) NOT NULL,
    policy_number            VARCHAR(100),
    policy_type              VARCHAR(50),
    face_amount              NUMERIC(15,2),
    cash_surrender_value     NUMERIC(15,2),
    annual_premium           NUMERIC(15,2),
    primary_beneficiaries    TEXT,
    contingent_beneficiaries TEXT,
    policy_owner             VARCHAR(255),
    insured_person           VARCHAR(255),
    issue_date               DATE,
    maturity_date            DATE,
    loan_against_policy      NUMERIC(15,2) DEFAULT 0,
    loan_interest_rate       NUMERIC(5,2)
);

-- ─────────────────────────────────────────────────────────
-- RENT ROLL  (RentRollService)
-- ─────────────────────────────────────────────────────────

CREATE TABLE rentroll_extractions (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_uuid        UUID NOT NULL,
    suite            VARCHAR,
    tenant_name      VARCHAR,
    landlord_name    VARCHAR,
    sf               FLOAT,
    start_date       VARCHAR,
    end_date         VARCHAR,
    base_rent        FLOAT,
    security_deposit FLOAT,
    lease_type       VARCHAR,
    escalation       VARCHAR,
    utilities        JSONB,
    notes            JSONB,
    blob_url         VARCHAR,
    created_at       TIMESTAMP DEFAULT NOW()
);

-- ─────────────────────────────────────────────────────────
-- INDEXES
-- ─────────────────────────────────────────────────────────

CREATE INDEX idx_companies_client_uuid      ON companies(client_uuid);
CREATE INDEX idx_companies_ein              ON companies(ein);
CREATE INDEX idx_form_versions_data         ON form_versions USING GIN(data);
CREATE INDEX idx_filings_guarantor_data     ON filings_guarantor USING GIN(data);
CREATE INDEX idx_guarantors_client_uuid     ON guarantors(client_uuid);
CREATE INDEX idx_loan_apps_user_uuid        ON loan_applications(user_uuid);
CREATE INDEX idx_loan_apps_status           ON loan_applications(status);
CREATE INDEX idx_pfs_user_uuid              ON pfs_statement(user_uuid);
CREATE INDEX idx_rentroll_user_uuid         ON rentroll_extractions(user_uuid);