from enum import Enum

class EnvironmentType(str, Enum):
    DEV = "dev"
    PROD = "prod"

ENVIRONMENT: EnvironmentType = EnvironmentType.DEV

if ENVIRONMENT == EnvironmentType.DEV:
    BASE_URL: str = "http://localhost:8000/base/api"
else:
    BASE_URL: str = "https://fulcrum-backend-base.onrender.com/base/api"