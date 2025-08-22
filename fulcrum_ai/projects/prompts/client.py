import aiohttp
from typing import Optional

from fulcrum_ai.modules.config.constants import BASE_URL

from fulcrum_ai.modules.interfaces import (
    getPromptResponse
)

class AsyncPromptClient:

    def __init__(
        self,
        headers:dict
    ):
        self.headers = headers
    
    async def get_prompt(
        self,
        prompt_id: str,
        version_id: Optional[str] = None,
    ) -> str:
        
        async with aiohttp.ClientSession() as session:
            async with session.post(
                url=f"{BASE_URL}/projects/prompts/get/",
                json={
                    "prompt_id": prompt_id,
                    "version_id": version_id
                },
                headers=self.headers
            ) as response:
                return getPromptResponse(
                    **(await response.json())
                )
        

        

