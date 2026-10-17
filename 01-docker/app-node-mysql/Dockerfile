# Especificar la imagen
FROM node:22

# Especificar el nombre del directorio de trabajo
WORKDIR /app

# Copiar el archivo package.json
# COPY package.json / app
COPY package.json .

# Instalar las dependencias establecidas
RUN  npm install

# Exponer el puerto
EXPOSE 3000

# Copiar todos los archivos y carpetas que requiera la aplicacion
COPY . .

# Ejecuta la aplicacion
CMD npm start