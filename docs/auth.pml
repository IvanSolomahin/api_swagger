@startuml

' Сущности
entity "users" {
    * id : UUID <<PK>>
    email : VARCHAR(255) <<UNIQUE>>
    password_hash : TEXT
    first_name : VARCHAR(100)
    last_name : VARCHAR(100)
    role : ENUM('USER', 'ADMIN')
    is_guest : BOOLEAN DEFAULT FALSE
    created_at : TIMESTAMP
    updated_at : TIMESTAMP
}

entity "roles" {
    * id : SERIAL <<PK>>
    name : VARCHAR(50) <<UNIQUE>>
    permissions : JSONB
}

entity "user_role_mapping" {
    * user_id : UUID <<FK>>
    * role_id : INT <<FK>>
}

' Связи
users ||--o{ user_role_mapping : "user_id"
roles ||--o{ user_role_mapping : "role_id"


@enduml