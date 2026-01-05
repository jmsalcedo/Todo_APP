# Stage 1: Build
# Usamos 3.14-slim ya que tu pyproject.toml especifica >=3.14
FROM python:3.14-slim AS builder

# Instalar uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Variable para que uv no cree un entorno virtual separado si ya estamos en un contenedor (opcional pero recomendado)
ENV UV_COMPILE_BYTECODE=1

# Copiar archivos de dependencias
COPY pyproject.toml uv.lock ./

# Sincronizar dependencias (sin instalar el proyecto ni dependencias de dev)
# Esto crea la carpeta /app/.venv
RUN uv sync --frozen --no-install-project --no-dev

# Stage 2: Final
FROM python:3.14-slim

WORKDIR /app

# Variables de entorno para Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Añadimos el .venv al PATH para que 'uvicorn' sea reconocido directamente
ENV PATH="/app/.venv/bin:$PATH"

# Copiamos el entorno virtual completo desde el builder
COPY --from=builder /app/.venv /app/.venv

# Copiamos el código de la aplicación
COPY . .

# Exponer puertos
EXPOSE 8000

# Usuario no-root por seguridad
RUN addgroup --system appgroup && adduser --system --group appuser
USER appuser

# Healthcheck usando python
HEALTHCHECK --interval=30s --timeout=3s \
  CMD python3 -c 'import urllib.request; urllib.request.urlopen("http://localhost:8000/")' || exit 1

# Cambiamos la forma de ejecución a python -m uvicorn 
# Es más robusto que llamar al script directo si hay problemas de path
CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]