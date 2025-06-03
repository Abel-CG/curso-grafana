Vamos a crear un dashboard super chulo basado en influxDB

Primero levantamos grafana e influxdb:
$: docker-compose -f docker-compose-influxdb.yml up

Comprobamos que todo funciona correctamente:
localhost:3000
localhost:8086

Creamos el contenedor de Python
docker build --pull --tag python/ch5 .

Comprobamos que el script funciona bien:
docker run python/ch5 weather.py --help

Y ahora lo ejecutamos para conseguir los datos de San Francisco:
docker run --rm -v "$(pwd):/usr/src/app" python/ch5 weather.py --output wx.txt  --stations KSFO,KDEN,KSTL,KJFK

Ya tenemos los datos!!!! 

Ahora preparamos la base de datos InfluxDB

Configura usuario, password, organización y Bucket (primer repositorio)

Genera un API Token

Lo guardamos en un sitio seguro: J0nv4GnIMJk5IO7YADS913jS-X1V51KU9DJxH67XISLfkNi2wlYhryagURSrbT17R5q7IFmKOartZo65VtRr0A==

Y ejecutamos otra vez el script, pero en este caso indicamos el como origen nuestro fichero:
 docker run --rm --network host -v $(pwd):/usr/src/app python/ch5 weather.py --input wx.txt --db weather --token J0nv4GnIMJk5IO7YADS913jS-X1V51KU9DJxH67XISLfkNi2wlYhryagURSrbT17R5q7IFmKOartZo65VtRr0A==

Ya teneos los datos salvados en Influxdb!!!

Ahora configuramos Influxdb como datasource (Recordad añadir el API token)
Custom header name Authorization value: Token <API_TOKEN>
db: weather

TIP
Si queremos volver a meter los datos, añadir más estaciones metereológicas, se borra el bucket en influxdb y se vuelve a empezar el proceso.


