#################################################################################################
# Define the global log output method
#################################################################################################


import sys
import os
import datetime

class TimeLogger:
    def __init__(self,filename):
        self.terminal_stdout = sys.stdout
        self.terminal_stderr = sys.stderr
        self.log = open(filename,'w',buffering=1)

    def write(self,message):
        if message.strip():
            timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            formatted_message = f"[{timestamp}] {message}"
            # self.terminal.write(formatted_message)
            self.log.write(formatted_message)
            self.log.flush()
        else:
            # self.terminal.write(message)
            self.log.write(message)

    def flush(self):
        self.terminal_stdout.flush()
        self.log.flush()
