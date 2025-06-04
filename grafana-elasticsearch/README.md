# Visualización de llamadas de emergencia en San Francisco

Este proyecto utiliza datos reales de la ciudad de **San Francisco (EE. UU.)** para construir un cuadro de mando informativo con tecnologías como **Elasticsearch**, **Logstash** y **Grafana**.

## 📁 Paso 1: Descargar los datos

Creamos el directorio `downloads` y descargamos el archivo CSV con las llamadas:

```bash
mkdir downloads
cd downloads
wget https://data.sfgov.org/resource/iy63-pi3t.csv
cd ..
```

## 📊 Objetivo

Se nos solicita crear un **cuadro de mando lo más informativo posible** basado en las **1.000 primeras llamadas** del dataset (mes actual).

---

## 🚀 Paso 2: Iniciar la infraestructura

### 1. Crear almacenamiento para Elasticsearch

```bash
mkdir elasticsearch-storage
```

Levantar el contenedor de Elasticsearch:

```bash
docker-compose up --pull missing -d elasticsearch
```

### 2. Crear almacenamiento para Grafana

```bash
mkdir grafana-storage
```

Levantar el contenedor de Grafana:

```bash
docker-compose up --pull missing -d grafana
```

### 3. Preparar y lanzar Logstash

Creamos el directorio `data`:

```bash
mkdir data
```

Ejecutamos Logstash para cargar el CSV en Elasticsearch:

```bash
docker-compose up --no-TTY logstash < downloads/iy63-pi3t.csv
```

---

## ✅ Verificar funcionamiento

Accede a la siguiente URL para comprobar que Elasticsearch está funcionando correctamente:

[http://localhost:9200/_stats](http://localhost:9200/_stats)

---

## 📈 Configurar Grafana

1. Accede a Grafana en tu navegador.
2. Añade **Elasticsearch como Data Source**.
3. Crea tus paneles de visualización.

