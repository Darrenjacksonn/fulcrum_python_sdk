import aiohttp

from fulcrum_ai.modules.config.constants import BASE_URL

from fulcrum_ai.modules.interfaces.endpoints import (
    CreateLogRequest
)


class AsyncPromptLogsClient:

    def __init__(
        self,
        headers:dict
    ):
        self.headers = headers

    async def create_log(
        self,
        body:CreateLogRequest
    ):
        async with aiohttp.ClientSession() as session:
            async with session.post(
                f"{BASE_URL}/projects/prompts/logs/create/",
                headers=self.headers,
                json=body.model_dump()
            ) as response:
                if response.status != 200:
                    detail = await response.text()
                    raise Exception(
                        f"Error creating log: {response.status} {detail}"
                    )