# Standard library imports
import json
import logging
import time

# Third-party imports
from fastapi import APIRouter,Request
from pydantic import ValidationError
from typing import List

from pydantic import BaseModel
from models.blog_models import BlogTitles


# Local imports
from services import llm_api as llm, prompts as pr

logger = logging.getLogger("AppLogger")
logger.setLevel(logging.DEBUG)  # Set the log level to DEBUG

# Create a console handler and set its log level
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.INFO)

# Create a file handler to log messages to a file
file_handler = logging.FileHandler("app.log")

# Create a formatter
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

# Set the formatter for both handlers
console_handler.setFormatter(formatter)
file_handler.setFormatter(formatter)

# Add the handlers to the logger
logger.addHandler(console_handler)
logger.addHandler(file_handler)

router = APIRouter()




@router.get("/blog/generate-titles")
async def generate_blog_titles(user_topic: str,request: Request):
    start_time = time.time()
    max_retries = 5

    for retry_count in range(max_retries):
        try:
            if await llm.is_text_flagged(user_topic):
                return {
                    "success": False,
                    "message": "Input Not Allowed",
                    "result": None
                }

            prompt = pr.generate_blog_titles.format(topic=user_topic)
            result : BlogTitles = await llm.generate_with_response_model(prompt,1,BlogTitles)
          
      
            success_result = True
            return {
                "success": True,
                "message": "Generated Titles Successfully",
                "result": result.titles
            }

        except (json.JSONDecodeError, ValidationError) as e:
            logger.warning(
                f"Failed during JSON decoding or validation. Retry count: {retry_count + 1}."
            )
            
        except KeyError as e:
            logger.warning(f"Missing key in JSON: {e}")
            
        except Exception as e:
            logger.error(e)
            continue
        finally:
            elapsed_time = time.time() - start_time
            #do soemthing with the elapsed time

    return {
        "success": False,
        "message": f"Failed to generate titles",
        "result": None
    }

@router.get("/tool/hello")
async def tool_hello():
    try:
        return {"Hello": "You Called Me!"}
    except Exception as e:
        logger.error(f"Error in /tool/hello: {e}", exc_info=True)
        raise

@router.get("/tool/name")
async def print_name(name: str):
    return "My Name is: " + name

@router.get("/")
async def read_root():
    return {"message": "Welcome to the root path!"}

