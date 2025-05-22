@startuml
skinparam rectangleLineWidth 1
skinparam noteFontSize 10

' Сущности
entity "employees" {
    * id : INT <<PK>>
    name : VARCHAR(100)
    surname : VARCHAR(100)
    position_id : INT <<FK>> 
    department : VARCHAR(100)
    start_date : DATE
    end_date : DATE NULL
    created_at : TIMESTAMP
    updated_at : TIMESTAMP
}

entity "positions" {
    * id : INT <<PK>>
    name : VARCHAR(100)
    salary_min : DECIMAL(10,2)
    salary_max : DECIMAL(10,2)
    responsibilities : JSONB
    created_at : TIMESTAMP
    updated_at : TIMESTAMP
}

entity "payroll" {
    * id : INT <<PK>>
    month : DATE
    total_amount : DECIMAL(10,2)
    employee_id : INT <<FK>>
    amount : DECIMAL(10,2)
    created_at : TIMESTAMP
}

entity "invoices" {
    * id : INT <<PK>>
    client_id : INT <<FK>> ' Ссылка на микросервис аутентификации
    amount : DECIMAL(10,2)
    due_date : DATE
    status : ENUM('ожидает', 'оплачен', 'отменён')
    created_at : TIMESTAMP
    updated_at : TIMESTAMP
}

entity "tax_rules" {
    * id : INT <<PK>>
    name : VARCHAR(100)
    rate : DECIMAL(10,2)
    description : TEXT
    created_at : TIMESTAMP
    updated_at : TIMESTAMP
}

entity "tax_calculations" {
    * id : INT <<PK>>
    tax_id : INT <<FK>>
    invoice_id : INT <<FK>>
    amount : DECIMAL(10,2)
    created_at : TIMESTAMP
}

entity "financial_reports" {
    * id : INT <<PK>>
    start_date : DATE
    end_date : DATE
    report_type : ENUM('ежемесячный', 'ежеквартальный', 'годовой')
    income : DECIMAL(10,2)
    expenses : DECIMAL(10,2)
    profit : DECIMAL(10,2)
    details : JSONB
    created_at : TIMESTAMP
}

entity "employee_tax_deductions" {
    * employee_id : INT <<FK>>
    * tax_id : INT <<FK>>
    deduction_rate : DECIMAL(5,2)
    effective_from : DATE
    effective_to : DATE NULL
}

' Связи
employees ||--o{ payroll : "employee_id"
employees ||--o{ employee_tax_deductions : "employee_id"
positions ||--o{ employees : "position_id"
tax_rules ||--o{ employee_tax_deductions : "tax_id"
tax_rules ||--o{ tax_calculations : "tax_id"
invoices ||--o{ tax_calculations : "invoice_id"
invoices ||--o{ financial_reports : "invoice_id"
@enduml