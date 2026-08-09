FROM node:22-bookworm

WORKDIR /app

ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

COPY package*.json ./
RUN npm install

# Install full Chromium (not --only-shell) plus its system deps
RUN npx playwright install --with-deps chromium

COPY . .

RUN npm run build

EXPOSE 8080
ENV PORT=8080

CMD ["npm", "run", "start"]
