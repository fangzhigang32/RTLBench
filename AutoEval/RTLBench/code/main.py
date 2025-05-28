#################################################################################################
# Main function for automated evaluation
#################################################################################################

import sim_and_lint
import re_sim_and_lint
import os
import shutil
import glob
from dotenv import load_dotenv
load_dotenv()

os.makedirs("../log", exist_ok=True)

# Performing automated evaluation steps
def autoEval():

    # 1.Generate Verilog code for the first time
    # nl2verilog.main()

    # 2.执行验Perform validation and linting证和Lint
    sim_and_lint.main()

    # 3.Feedback log to LLM to optimize code
    # log2verilog.main()

    # 4.Perform validation and linting on optimized code
    re_sim_and_lint.main()


# Save the experimental results
def saveResult():

    experiment_model_name = (os.getenv("chat_model_name")).split('/')[-1]
    experiment_result = os.path.join("../experiment", experiment_model_name)

    # Create experiment result directory inside experiment_result
    os.makedirs(experiment_result, exist_ok=True)

    # Move nl2verilog folder to experiment result directory
    if os.path.exists("../nl2verilog"):
        shutil.move("../nl2verilog", os.path.join(experiment_result, "nl2verilog"))

    # Move log2verilog folder to experiment result directory
    if os.path.exists("../log2verilog"):
        shutil.move("../log2verilog", os.path.join(experiment_result, "log2verilog"))

    # Move log folder to experiment result directory
    if os.path.exists("../log"):
        shutil.move("../log", os.path.join(experiment_result, "log"))


def main():
    
    # Performing automated evaluation steps
    autoEval()

    # Save the experimental results
    saveResult()


if __name__ == "__main__":
    main()
    

    
   

