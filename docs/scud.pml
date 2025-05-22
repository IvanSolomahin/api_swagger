@startuml
left to right direction
' Сущности
entity "users" {
    * id : UUID <<PK>>
    email : VARCHAR(255) <<UNIQUE>>
    first_name : VARCHAR(100)
    last_name : VARCHAR(100)
    role : ENUM('USER', 'ADMIN')
    created_at : TIMESTAMP
}

entity "devices" {
    * id : UUID <<PK>>
    name : VARCHAR(100)
    type : ENUM('DOOR_CONTROLLER', 'CAMERA', 'TURNTABLE')
    location : VARCHAR(255)
    status : ENUM('ONLINE', 'OFFLINE', 'MAINTENANCE')
    last_heartbeat : TIMESTAMP
}

entity "access_rules" {
    * id : UUID <<PK>>
    name : VARCHAR(100)
    description : TEXT
    start_time : TIMESTAMP
    end_time : TIMESTAMP
}

entity "access_rule_users" {
    * rule_id : UUID <<FK>>
    * user_id : UUID <<FK>>
}

entity "access_rule_devices" {
    * rule_id : UUID <<FK>>
    * device_id : UUID <<FK>>
}

entity "access_logs" {
    * id : UUID <<PK>>
    user_id : UUID <<FK>>
    device_id : UUID <<FK>>
    access_type : ENUM('RFID', 'FACE_RECOGNITION', 'PIN_CODE')
    status : ENUM('ALLOWED', 'DENIED')
    timestamp : TIMESTAMP
}

entity "security_events" {
    * id : UUID <<PK>>
    event_type : ENUM('UNAUTHORIZED_ACCESS', 'DEVICE_FAILURE', 'ALARM_TRIGGERED')
    description : TEXT
    device_id : UUID <<FK>>
    user_id : UUID <<FK>> NULL
    timestamp : TIMESTAMP
}

entity "video_streams" {
    * camera_id : UUID <<PK>>
    stream_url : TEXT
    archive_url : TEXT
    is_active : BOOLEAN DEFAULT TRUE
}

entity "access_methods" {
    * id : UUID <<PK>>
    method_type : ENUM('RFID', 'FACE_RECOGNITION', 'PIN_CODE')
    details : JSONB
    user_id : UUID <<FK>>
    is_active : BOOLEAN DEFAULT TRUE
}

entity "sensor_webhooks" {
    * id : UUID <<PK>>
    sensor_id : VARCHAR(100)
    event_type : ENUM('DOOR_OPENED', 'UNAUTHORIZED_ACCESS', 'FIRE_ALARM')
    message : TEXT
    processed : BOOLEAN DEFAULT FALSE
    created_at : TIMESTAMP
}

' Связи
users ||--o{ access_rule_users : "user_id"
access_rules ||--o{ access_rule_users : "rule_id"

users ||--o{ access_rule_devices : "user_id"
access_rules ||--o{ access_rule_devices : "rule_id"

users ||--o{ access_logs : "user_id"
devices ||--o{ access_logs : "device_id"

devices ||--o{ security_events : "device_id"
users }o--o{ security_events : "user_id"

devices ||--o{ video_streams : "camera_id"
users ||--o{ access_methods : "user_id"
devices ||--o{ sensor_webhooks : "sensor_id"

@enduml