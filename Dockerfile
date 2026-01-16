# BO360 Operations Command Console - Planka Fork
# Custom themed version of Planka for Benefits Outreach 360
#
# Build: docker build -t planka-bo360:latest .
# Run: docker-compose up -d

# Stage 1: Server build
FROM node:22-alpine AS server

RUN apk -U upgrade \
  && apk add build-base python3 --no-cache

WORKDIR /app

COPY server .

RUN npm install npm --global \
  && npm install \
  && npm run build \
  && npm prune --production

# Stage 2: Client build (with BO360 theme)
FROM node:22 AS client

WORKDIR /app

COPY client .

# Install all dependencies including dev deps for build
RUN npm install npm --global \
  && npm install \
  && DISABLE_ESLINT_PLUGIN=true npm run build

# Stage 3: Final image
FROM node:22-alpine

# Add BO360 labels
LABEL org.opencontainers.image.title="Planka BO360"
LABEL org.opencontainers.image.description="BO360 Operations Command Console - Custom themed Planka"
LABEL org.opencontainers.image.source="https://github.com/evan043/Benefits-Outreach-360"
LABEL org.opencontainers.image.vendor="BO360 Engineering"
LABEL maintainer="BO360 Engineering"

RUN apk -U upgrade \
  && apk add bash python3 --no-cache \
  && npm install npm --global

USER node
WORKDIR /app

COPY --chown=node:node LICENSE.md .
COPY --chown=node:node ["LICENSES/PLANKA Community License DE.md", "LICENSE_DE.md"]

COPY --from=server --chown=node:node /app/node_modules node_modules
COPY --from=server --chown=node:node /app/dist .

COPY --from=client --chown=node:node /app/dist public
COPY --from=client --chown=node:node /app/dist/index.html views

RUN python3 -m venv .venv \
  && .venv/bin/pip3 install -r requirements.txt --no-cache-dir \
  && mv .env.sample .env \
  && npm config set update-notifier false

VOLUME /app/public/favicons
VOLUME /app/public/user-avatars
VOLUME /app/public/background-images
VOLUME /app/private/attachments

EXPOSE 1337

HEALTHCHECK --interval=10s --timeout=2s --start-period=15s \
  CMD node ./healthcheck.js

CMD ["./start.sh"]
