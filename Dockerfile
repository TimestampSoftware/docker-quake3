FROM alpine:3.10

# Instalar las dependencias de base para compilar
# el servidor IO Quake3
RUN apk add --no-cache curl git make unzip build-base

# Agregar el grupo, usuario y home ioquake3
RUN addgroup ioquake3 && \
	adduser -h /ioquake3 -s /bin/false -G ioquake3 -D ioquake3 && \
	chown -R ioquake3:ioquake3 /ioquake3

# Instalar bash para ejecutar los scripts para compilar y partir el servidor
RUN apk add --no-cache bash


# Cambiarse al usuario ioquake3. Esto aplica a todos los comandos que siguen
# y todas las instancias de la imagen que se corran.
USER ioquake3

# Bajar el script para compilar el servidor.
RUN curl https://raw.githubusercontent.com/ioquake/ioq3/master/misc/linux/server_compile.sh \
	-o /ioquake3/server_compile.sh

# Compilar el servidor. Hay que ejecutar yes y mandar su salida
# al script de compilacion para confirmar los dialogos que manda.
RUN cd /ioquake3/ && chmod +x ./server_compile.sh && \
	yes | ./server_compile.sh

# Copiar los archivos del juego.
COPY ./baseq3 /ioquake3/ioquake3/baseq3

# Copiar el script y los archivos de configuracion
COPY start_server.sh /ioquake3/start_server.sh
COPY server.cfg /ioquake3/server.cfg
COPY levels.cfg /ioquake3/levels.cfg

# Dejar el script para ejecutar el servidor como ejecutable.
RUN chmod +x /ioquake3/start_server.sh

# Dejar el punto de entrada por defecto de la imagen como el script
# para ejecutar el servidor.
ENTRYPOINT ["/ioquake3/start_server.sh"]
