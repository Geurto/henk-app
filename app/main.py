from fastapi import FastAPI
import uvicorn
import threading
import os


from core.models.database import Database

app = FastAPI()
if 'DB_HOST' in os.environ:
    db_host = os.environ.get('DB_HOST', '127.0.0.1')
else:
    db_host = '127.0.0.1'
db = Database(host=db_host)

db_interval_jobs_thread = threading.Thread(target=db.run_interval_jobs)
db_interval_jobs_thread.start()


@app.on_event("startup")
async def startup_event():
    db.redis.flushall()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/status/database")
def status_database():
    return {"Status": str(db.redis.ping())}


@app.get("/status/internet")
def status_internet():
    results = [int(p) for p in db.redis.lrange("internet-up", 0, -1)]
    percentage = 100 * sum(results) / len(results)
    return {"percentage_up": round(percentage, 2),
            "measurement_time":  len(results) * 1,
            "failures": len(results) - sum(results)}


if __name__ == '__main__':
    uvicorn.run("main:app", host='0.0.0.0', port=80, reload=True)
