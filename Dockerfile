FROM node:22-bookworm

WORKDIR /app

ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

COPY package*.json ./
RUN npm install

# Install full Chromium (not --only-shell) plus its system deps
RUN npx playwright install --with-deps chromium

# Persistent virtual display + remote viewing: xauth (X auth cookies),
# x11vnc (exposes the display over VNC), websockify+novnc (VNC-over-HTTP
# so it's viewable in a plain browser tab, no VNC client needed)
RUN apt-get update && apt-get install -y --no-install-recommends \
    xauth x11vnc novnc websockify \
    && rm -rf /var/lib/apt/lists/*

COPY . .
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN npm run build

# 8080 = app, 6080 = noVNC web viewer (watch/control the login browser)
EXPOSE 8080 6080
ENV PORT=8080

CMD ["/entrypoint.sh"]
