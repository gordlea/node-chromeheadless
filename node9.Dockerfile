FROM node:9

ENV DEBIAN_FRONTEND=noninteractive
ENV CI=true
# headless chrome
RUN apt-get update && apt-get install -yq libgconf-2-4
RUN apt-get install -y wget --no-install-recommends \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update
RUN apt-get --yes install fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends
RUN apt-get --yes install $(apt-cache depends google-chrome-unstable | grep Depends | sed "s/.*ends:\ //" | tr '\n' ' ')

# It's a good idea to use dumb-init to help prevent zombie chrome processes.
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

RUN yarn global add puppeteer@latest

