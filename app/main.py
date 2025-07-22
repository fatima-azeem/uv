from fastapi import FastAPI
import uvicorn

app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/v1")
def read_api():
    return {"message": "Hello from API version 1"}

@app.get("/v1/health")
def read_health():
    return {"status": "healthy"}

def main():
    uvicorn.run(app, host="0.0.0.0", port=8001)

if __name__ == "__main__":
    main()
