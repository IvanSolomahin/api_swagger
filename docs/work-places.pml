@startuml
skinparam rectangleLineWidth 1
skinparam noteFontSize 10

' Сущности
entity "workspaces" {
    * id : UUID <<PK>>
    name : VARCHAR(100)
    location : VARCHAR(255)
    status : ENUM('FREE', 'OCCUPIED', 'MAINTENANCE')
    capacity : INT
    price : DECIMAL(10,2)
    features : JSONB
    availability : BOOLEAN DEFAULT TRUE
    created_at : TIMESTAMP
    updated_at : TIMESTAMP
}

entity "bookings" {
    * id : UUID <<PK>>
    workspace_id : UUID <<FK>>
    user_id : UUID <<FK>>  ' Ссылка на микросервис аутентификации
    start_time : TIMESTAMP
    end_time : TIMESTAMP
    status : ENUM('CONFIRMED', 'CANCELLED', 'PENDING')
    created_at : TIMESTAMP
}

entity "workspace_availability" {
    * workspace_id : UUID <<FK>>
    * date : DATE
    occupied_slots : INT
    total_slots : INT
}

entity "workspace_events" {
    * id : UUID <<PK>>
    workspace_id : UUID <<FK>>
    event_type : ENUM('BOOKING_CREATED', 'BOOKING_CANCELLED', 'STATUS_CHANGED')
    description : TEXT
    timestamp : TIMESTAMP
}

entity "workspace_features" {
    * id : SERIAL <<PK>>
    name : VARCHAR(50) <<UNIQUE>>
}

entity "workspace_feature_mapping" {
    * workspace_id : UUID <<FK>>
    * feature_id : INT <<FK>>
}

' Связи
workspaces ||--o{ bookings : "workspace_id"
workspaces ||--o{ workspace_availability : "workspace_id"
workspaces ||--o{ workspace_events : "workspace_id"
workspaces }--|| workspace_feature_mapping : "workspace_id"
workspace_features }--|| workspace_feature_mapping : "feature_id"


@enduml