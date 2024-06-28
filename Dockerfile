FROM python:3.10-alpine

WORKDIR /app

# Copia solo los archivos necesarios
COPY requirements.txt .

# Instala las dependencias
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

# Define el comando de inicio
CMD ["python", "app.py"]