FROM node:12.14-stretch-slim

MAINTAINER buildmaster@rocket.chat

RUN set -x \
 && apt-get update \
 && apt-get install -y -o Dpkg::Options::="--force-confdef" --no-install-recommends \
    imagemagick \
    fontconfig \
    ca-certificates \
    curl \
    gpg \
    dirmngr \
 && apt-get clean all \
 && npm cache clear --force \
 && groupadd -r rocketchat \
 && useradd -r -g rocketchat rocketchat

# fix for IPv6 build environments https://rvm.io/rvm/security#ipv6-issues
RUN echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf
# gpg: key 4FD08014: public key "Rocket.Chat Buildmaster <buildmaster@rocket.chat>" imported
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 0E163286C20D07B9787EBE9FD7F9D0414FD08104

# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
 && for key in \
      94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
      FD3A5288F042B6850C66B31F09FE44734EB7990E \
      71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
      DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
      C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
      B9AE9905FFD7803F25714661B63B535A4C206CA9 \
      77984A986EBC2AA786BC0F66B01FBB92821C587A \
      8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
      4ED778F539E3634C779C87C6D7062848A1AB005C \
      A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
      B9E2F5981AA6E0CD28160D9FF13993A75599653C \
    ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
    done

