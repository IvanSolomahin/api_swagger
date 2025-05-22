@startuml
skinparam rectangleLineWidth 1
skinparam noteFontSize 10

' Сущности
entity "users" {
    * id : UUID <<PK>>
    email : VARCHAR(255) <<UNIQUE>>
    first_name : VARCHAR(100)
    last_name : VARCHAR(100)
    role : ENUM('USER', 'ADMIN')
    created_at : TIMESTAMP
}

entity "payments" {
    * id : UUID <<PK>>
    user_id : UUID <<FK>>
    amount : DECIMAL(10,2)
    service_type : ENUM('WORKSPACE', 'PARKING', 'CLEANING', 'CATERING', 'OTHER')
    status : ENUM('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED', 'CANCELLED')
    created_at : TIMESTAMP
    updated_at : TIMESTAMP
}

entity "payment_methods" {
    * id : UUID <<PK>>
    user_id : UUID <<FK>>
    type : ENUM('CARD', 'WALLET', 'BANK_TRANSFER')
    details : JSONB
    is_default : BOOLEAN DEFAULT FALSE
    created_at : TIMESTAMP
}

entity "transactions" {
    * id : UUID <<PK>>
    payment_id : UUID <<FK>>
    bank_transaction_id : VARCHAR(100)
    provider : VARCHAR(50)
    status : ENUM('SUCCESS', 'FAILED', 'PENDING')
    amount : DECIMAL(10,2)
    response : JSONB
    created_at : TIMESTAMP
}

entity "discounts" {
    * id : UUID <<PK>>
    code : VARCHAR(50) <<UNIQUE>>
    discount_type : ENUM('PERCENT', 'FIXED')
    value : DECIMAL(10,2)
    valid_from : TIMESTAMP
    valid_to : TIMESTAMP
    usage_limit : INT
    used_count : INT DEFAULT 0
    created_at : TIMESTAMP
}

entity "payment_discounts" {
    * payment_id : UUID <<FK>>
    * discount_id : UUID <<FK>>
}

entity "reports" {
    * id : UUID <<PK>>
    name : VARCHAR(100)
    time_range_from : TIMESTAMP
    time_range_to : TIMESTAMP
    generated_by : UUID <<FK>>
    url : TEXT
    created_at : TIMESTAMP
}

entity "bank_webhooks" {
    * id : UUID <<PK>>
    transaction_id : VARCHAR(100) <<UNIQUE>>
    payload : JSONB
    processed : BOOLEAN DEFAULT FALSE
    created_at : TIMESTAMP
}

' Связи
users ||--o{ payments : "user_id"
payments ||--o{ transactions : "payment_id"
payments ||--o{ payment_discounts : "payment_id"
discounts ||--o{ payment_discounts : "discount_id"
users ||--o{ reports : "generated_by"
users ||--o{ payment_methods : "user_id"



@enduml