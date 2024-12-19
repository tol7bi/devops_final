from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import jwt
import datetime
from confluent_kafka import Producer, KafkaException
import psycopg2
from psycopg2.extras import RealDictCursor
import json

SECRET_KEY = '2e398ac8a4e549cc5928d00f6ff3484f38c0e2c6c214cd7998d3e5922c84b56f6'

app = FastAPI()

DB_CONFIG = {
    "dbname": "auth_db",
    "user": "auth_user",
    "password": "auth_password",
    "host": "127.0.0.1",
    "port": "5432"
}

KAFKA_CONFIG = {
    "bootstrap.servers": "localhost:9092",
    "security.protocol": "SASL_PLAINTEXT",
    "sasl.mechanism": "PLAIN",
    "sasl.username": "admin",
    "sasl.password": "admin-secret"
}

class AuthRequest(BaseModel):
    username: str
    password: str

class KafkaMessage(BaseModel):
    jwt_token: str
    message: str

def create_jwt_token(username: str):
    payload = {
        "username": username,
        "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=1)
    }
    return jwt.encode(payload, SECRET_KEY, algorithm="HS256")

def decode_jwt_token(token: str):
    try:
        return jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token expired")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Invalid token")

def get_secret_from_db(username: str):
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.execute("SELECT secret FROM secrets WHERE username = %s", (username,))
        result = cursor.fetchone()
        return result["secret"] if result else None
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
    finally:
        if conn:
            conn.close()

@app.post("/auth")
async def authenticate_user(auth_request: AuthRequest):
    username = auth_request.username
    password = auth_request.password

    stored_password = get_secret_from_db(username)
    if stored_password and stored_password == password:
        token = create_jwt_token(username)
        return {"token": token}
    raise HTTPException(status_code=401, detail="Invalid credentials")

@app.post("/send_message_to_kafka")
async def send_message_to_kafka(request: KafkaMessage):
    jwt_payload = decode_jwt_token(request.jwt_token)
    username = jwt_payload["username"]

    def delivery_report(err, msg):
        """Delivery report callback for Kafka."""
        if err is not None:
            raise HTTPException(status_code=500, detail=f"Message delivery failed: {err}")
        print(f"Message delivered to {msg.topic()} [{msg.partition()}]")

    try:
    
        sasl_password = get_secret_from_db(username)


        producer_config = {
            "bootstrap.servers": KAFKA_CONFIG["bootstrap.servers"],
            "security.protocol": KAFKA_CONFIG["security.protocol"],
            "sasl.mechanism": KAFKA_CONFIG["sasl.mechanism"],
            "sasl.username": username,
            "sasl.password": sasl_password,
        }


        producer = Producer(producer_config)

        message = {"user": username, "message": request.message}
        producer.produce("test", key=username, value=json.dumps(message), callback=delivery_report)
        producer.flush()

        return {"status": "Message sent successfully"}
    except KafkaException as e:
        raise HTTPException(status_code=500, detail=f"Kafka error: {str(e)}")
