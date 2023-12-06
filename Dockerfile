# Usa una imagen de Ruby como base
FROM ruby:3.0

# Establece el directorio de trabajo
WORKDIR /app

# Instala dependencias
RUN apt-get update -qq && \
    apt-get install -y nodejs postgresql-client && \
    apt-get install -y curl && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && \
    apt-get install -y yarn

# Copia el Gemfile y Gemfile.lock al contenedor
COPY Gemfile Gemfile.lock ./

# Instala las gemas
RUN gem install bundler:2.2.21
RUN bundle install

# Instala paquetes de JavaScript usando Yarn
RUN yarn add bootstrap jquery popper.js roboto-fontface vanilla-nested

# Exponer el puerto 3000 para la aplicación Rails
EXPOSE 3000

# Comando por defecto al ejecutar el contenedor
CMD ["bash","-c", "rm -f tmp/pids/server.pid"]
# CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails s -b '0.0.0.0'"]
