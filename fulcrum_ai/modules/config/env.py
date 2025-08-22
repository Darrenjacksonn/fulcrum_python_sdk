from enum import Enum

class EnvironmentType(str, Enum):
    DEV = "dev"
    PROD = "prod"

ENVIRONMENT: EnvironmentType = EnvironmentType.PROD