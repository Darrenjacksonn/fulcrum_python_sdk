from typing import Optional
import requests

from ...modules.config.constants import BASE_URL

class AsyncPromptClient:

    async def get_prompt(
        self,
        prompt_id: str,
        # If no version id is provided, the
        # production prompt will be returned
        version_id: Optional[str] = None,
    ) -> str:

        response = requests.request(
            method="POST",
            url=f"{BASE_URL}/projects/prompts/get/",
            json={
                "prompt_id": prompt_id,
                "version_id": version_id
            },
        )

        print("Response recieved from api")

        return response.json()
        

        

