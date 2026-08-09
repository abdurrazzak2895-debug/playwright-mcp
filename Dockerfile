FROM node:22-bookworm

WORKDIR /app

ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

COPY package*.json ./
RUN npm install

# Install full Chromium (not --only-shell) plus its system deps
RUN npx playwright install --with-deps chromium

# xvfb-run needs xauth to manage X authority cookies
RUN apt-get update && apt-get install -y --no-install-recommends xauth && rm -rf /var/lib/apt/lists/*

COPY . .

RUN npm run build

EXPOSE 8080
ENV PORT=8080

CMD ["sh", "-c", "xvfb-run -a --server-args='-screen 0 1280x1024x24' npm run start"]
