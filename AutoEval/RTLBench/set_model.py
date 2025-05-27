#################################################################################################
# Initializing the Large Language Model (from api.txt)
#################################################################################################

import os
from langchain.chat_models import init_chat_model

# Function to load API settings from api.txt
def load_api_config(filepath):
    config = {}
    with open(filepath, "r") as f:
        for line in f:
            line = line.strip()
            if line and "=" in line:
                key, value = line.split("=", 1)
                config[key.strip()] = value.strip()
    return config

# Load configuration from api.txt
config = load_api_config("api.txt")

# Chat Model
chatModel = init_chat_model(
    openai_api_key = config.get("chat_api_key"),
    openai_api_base = config.get("chat_api_base"),
    model_provider = config.get("chat_model_provider"),
    model = config.get("chat_model_name"),
    temperature = config.get("chat_temperature")
)

# LLM-as-judge Model
judgeModel = init_chat_model(
    openai_api_key = config.get("judge_api_key"),
    openai_api_base = config.get("judge_api_base"),
    model_provider = config.get("judge_model_provider"),
    model = config.get("judge_model_name"),
    temperature = config.get("judge_temperature")
)
