from fastapi import FastAPI
import uvicorn
app = FastAPI()
@app.get("/tool/hello")
def tool_hello():
    return {"Hello": "You Called Me!"}
@app.get("/tool/name")
def print_name(name: str):
    return "My Name is: " + name
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)