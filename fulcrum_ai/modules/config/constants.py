from enum import Enum
from decouple import config

class EnvironmentType(str, Enum):
    DEV = "dev"
    PROD = "prod"

ENVIRONMENT: EnvironmentType = EnvironmentType.PROD

if config("ENVIRONMENT") == EnvironmentType.DEV:
    ENVIRONMENT = EnvironmentType.DEV

print(f"Environment: {ENVIRONMENT}")

if ENVIRONMENT == EnvironmentType.DEV:
    BASE_URL: str = "http://localhost:8000/base/api"
else:
    BASE_URL: str = "https://fulcrum-backend-base.onrender.com/base/api"


