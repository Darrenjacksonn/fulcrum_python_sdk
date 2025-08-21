from .projects.prompts import AsyncPromptClient


class AsyncFulcrumClient:


    def __init__(self):
        self.prompts = AsyncPromptClient()