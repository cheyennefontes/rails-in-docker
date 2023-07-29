FROM ruby:3.1.2 AS myapp-development
# Instalação do Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y --no-install-recommends nodejs yarn

# Diretório padrão
ENV INSTALL_PATH /opt/app
RUN mkdir -p $INSTALL_PATH

# Instalação das gems
WORKDIR $INSTALL_PATH
COPY myapp/ .
RUN rm -rf node_modules vendor
RUN gem install rails bundler
RUN bundle install
RUN yarn install

# Iniciando o servidor
CMD bundle exec unicorn -c config/unicorn.rb

