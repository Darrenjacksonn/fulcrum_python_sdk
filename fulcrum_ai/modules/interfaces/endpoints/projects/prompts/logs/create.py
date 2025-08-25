from pydantic import (
    BaseModel,
    Field
)
from typing import Optional

from fulcrum_ai.modules.interfaces.endpoints.types import (
    LLMMessage,
    TokenDetails
)

class CreateLogRequest(BaseModel):
    prompt_id:str = Field(...)
    version_id:str = Field(...)

    messages:list[LLMMessage] = Field(
        ...,
        description="""
            The conversation that emerged
        """
    )

    token_details:TokenDetails = Field(
        ...,
        description="""
            The token details for the operation.
        """
    )

    extra_info:Optional[dict] = Field(
        default=None,
        description="""
            Any extra info that the user        
            wishes to provide about the log.
        """
    )