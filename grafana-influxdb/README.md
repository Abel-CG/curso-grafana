
# 🌦️ Dashboard de Meteorología con InfluxDB y Grafana

Este proyecto crea un **dashboard atractivo** usando datos meteorológicos y la base de datos **InfluxDB** como fuente.

---

## 🚀 Paso 1: Levantar InfluxDB y Grafana

```bash
docker-compose -f docker-compose-influxdb.yml up
```

### Verifica que están corriendo:

- Grafana: [http://localhost:3000](http://localhost:3000)
- InfluxDB: [http://localhost:8086](http://localhost:8086)

---

## 🐍 Paso 2: Preparar el contenedor de Python

Construye la imagen:

```bash
docker build --pull --tag python/ch5 .
```

Verifica que el script funciona:

```bash
docker run python/ch5 weather.py --help
```

---

## 🌍 Paso 3: Obtener datos meteorológicos

Ejecuta el script para obtener datos de estaciones:

```bash
docker run --rm -v "$(pwd):/usr/src/app" python/ch5 weather.py --output wx.txt --stations KSFO,KDEN,KSTL,KJFK
```

---

## 🛠️ Paso 4: Configurar InfluxDB

1. Accede a InfluxDB y configura:
   - Usuario
   - Contraseña
   - Organización
   - **Bucket** (repositorio de datos)

2. Genera un **API Token** y guárdalo en lugar seguro.

> Ejemplo de token:
```
Token J0nv4GnIMJk5IO7YADS913jS-X1V51KU9DJxH67XISLfkNi2wlYhryagURSrbT17R5q7IFmKOartZo65VtRr0A==
```

---

## 📥 Paso 5: Insertar los datos en InfluxDB

Ejecuta el script para cargar los datos:

```bash
docker run --rm --network host -v $(pwd):/usr/src/app python/ch5 weather.py --input wx.txt --db weather --token <API_TOKEN>
```

---

## 📊 Paso 6: Configurar InfluxDB como DataSource en Grafana

1. Ve a Grafana > Configuration > Data Sources > Add data source
2. Selecciona **InfluxDB**
3. Usa los siguientes parámetros:
   - URL: `http://localhost:8086`
   - Token: `Token <API_TOKEN>`
   - Org: Tu organización
   - Bucket: `weather`

> 🔐 En custom header:
```
Authorization: Token <API_TOKEN>
```

---

## 💡 TIP

Si deseas volver a cargar datos o añadir nuevas estaciones:

1. Borra el bucket en InfluxDB.
2. Ejecuta nuevamente el proceso desde el Paso 3.

---

¡Y listo! Ya tienes tus datos meteorológicos visualizados en Grafana 🎉