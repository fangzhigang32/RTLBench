#################################################################################################
# Initializing the Large Language Model
#################################################################################################


import os
from dotenv import load_dotenv
from langchain.chat_models import init_chat_model
load_dotenv()


# Chat Model
chatModel = init_chat_model(
    openai_api_key = os.getenv("chat_api_key"),
    openai_api_base = os.getenv("chat_api_base"),
    model_provider = os.getenv("chat_model_provider"),
    model = os.getenv("chat_model_name"),
    temperature = os.getenv("chat_temperature")
)


# LLM-as-judge Model
judgeModel = init_chat_model(
    openai_api_key = os.getenv("judge_api_key"),
    openai_api_base = os.getenv("judge_api_base"),
    model_provider = os.getenv("judge_model_provider"),
    model = os.getenv("judge_model_name"),
    temperature = os.getenv("judge_temperature")
)
