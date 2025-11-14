# Todo App (FastAPI + PostgreSQL)

A TODO app using FastAPI with PostgreSQL database and SQLAlchemy ORM.

## Files

- `main.py` - FastAPI application with database endpoints
- `models.py` - SQLAlchemy Todo model
- `schemas.py` - Pydantic request/response schemas
- `database.py` - Database connection and session management
- `requirements.txt` - pip dependencies
- `environment.yml` - Conda environment file

## Prerequisites

- PostgreSQL running locally or remotely
- Python 3.11+

## Database Setup

Create a PostgreSQL database and user:

```sql
CREATE USER todouser WITH PASSWORD 'todopassword';
CREATE DATABASE todoapp OWNER todouser;
```

## Environment Setup

Set the database URL (PowerShell):

```powershell
$env:DATABASE_URL="postgresql://todouser:todopassword@localhost/todoapp"
```

Or create a `.env` file in the project root:

```
DATABASE_URL=postgresql://todouser:todopassword@localhost/todoapp
```

## Create environment & install (Conda)

```powershell
conda env create -f environment.yml
conda activate todo-app
pip install -r requirements.txt
```

## Create environment & install (venv)

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

## Run the server

```powershell
python -m uvicorn main:app --reload --host 127.0.0.1 --port 8000
```

Then open http://127.0.0.1:8000/docs for the interactive API docs (Swagger UI).

## Endpoints

- `GET /todos` - list all todos
- `POST /todos` - create a todo (JSON body: `title`, optional `description`)
- `GET /todos/{id}` - get todo by id
- `PUT /todos/{id}` - update a todo (body: `title`, optional `description`, optional `completed` query)
- `DELETE /todos/{id}` - delete todo

## Examples (curl/PowerShell)

Create:

```powershell
curl -X POST "http://127.0.0.1:8000/todos" -H "Content-Type: application/json" -d '{"title": "Buy milk", "description": "2 liters"}'
```

List all:

```powershell
curl http://127.0.0.1:8000/todos
```

Get by ID:

```powershell
curl http://127.0.0.1:8000/todos/1
```

Update (partial):

```powershell
curl -X PUT "http://127.0.0.1:8000/todos/1" -H "Content-Type: application/json" -d '{"completed": true}'
```

Delete:

```powershell
curl -X DELETE http://127.0.0.1:8000/todos/1
```
