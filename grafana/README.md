
# 🧭 Módulo: Despliegue de Stack de Monitorización con Grafana

En este módulo desplegaremos un stack completo de monitorización utilizando:

- Un **colector** (`node-exporter`)
- Un **data source** (`Prometheus`)
- **Grafana** como herramienta de visualización

---

## 🔧 Paso 1: Iniciar Grafana

1. Crea el directorio para almacenar los datos de Grafana:

   ```bash
   mkdir grafana-storage
   ```

2. Ejecuta el entorno usando Docker Compose:

   ```bash
   docker-compose up -d --pull missing
   ```

3. Accede a Grafana desde tu navegador en:

   ```
   http://localhost:3000/
   ```

4. ⚠️ **TIP**: Si Grafana no arranca correctamente, puede deberse a permisos del directorio `grafana-storage`.

   Para pruebas, puedes aplicar permisos completos (entorno de laboratorio):

   ```bash
   chmod -R 777 grafana-storage
   ```

5. Inicia sesión con las credenciales por defecto:

   ```
   Usuario: admin
   Contraseña: admin
   ```

6. ¡Y voilà! Ya tienes Grafana funcionando 🟢

---

## 📊 Paso 2: Configurar el Datasource y Dashboard

1. En Grafana, añade el datasource usando el plugin `TestData`.
2. Importa el dashboard desde el archivo `.json` que se encuentra en la carpeta `dashboards/`.

---

## 📡 Paso 3: Añadir un Datasource y un Colector

1. **Detén el stack actual de Grafana:**

   ```bash
   docker-compose down
   ```

2. **Levanta Prometheus y Node Exporter con otro archivo Compose:**

   ```bash
   docker-compose -f docker-compose-prometheus.yml up
   ```

3. **Verifica que ambos servicios están corriendo:**

   - Prometheus: [http://localhost:9090/targets](http://localhost:9090/targets)
   - Node Exporter: [http://localhost:9100/targets](http://localhost:9100/targets)


