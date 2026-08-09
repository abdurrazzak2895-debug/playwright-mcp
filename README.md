This is a [Next.js](https://nextjs.org) project bootstrapped with [`create-next-app`](https://github.com/vercel/next.js/tree/canary/packages/create-next-app).

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.js`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/app/building-your-application/optimizing/fonts) to automatically optimize and load [Geist](https://vercel.com/font), a new font family for Vercel.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js) - your feedback and contributions are welcome!

## Deploy on Vercel

This app launches a **Playwright Chromium** browser on the server (login, fetching
exam dates/sessions, rebook/reschedule). Serverless environments do **not** ship a
browser by default, so `vercel.json` is configured to install Chromium *into the
project* during the build:

```json
{
  "installCommand": "npm install --no-audit --no-fund && PLAYWRIGHT_BROWSERS_PATH=0 npx playwright install --with-deps chromium",
  "env": { "PLAYWRIGHT_BROWSERS_PATH": "0" }
}
```

- `PLAYWRIGHT_BROWSERS_PATH=0` makes Playwright install the browser into
  `node_modules/playwright-core/.local-browsers`, so the binary is bundled with the
  serverless function. The runtime env var is also set from `vercel.json` so
  Playwright always looks in the right place.
- `--with-deps` installs the OS libraries Chromium needs (runs as root in the build).
- `src/lib/svp-playwright.js` also resolves the Chromium executable explicitly at
  launch, so it works even if the env var is missing or overridden.

### Steps to go live

1. Push this repo to GitHub (already configured:
   `origin → https://github.com/abdurrazzak2895-debug/playwright-mcp.git`).
2. In the Vercel dashboard: **Add New → Project**, import the repo, keep the
   default framework (**Next.js**). `vercel.json` is picked up automatically.
3. Recommended project env vars (Settings → Environment Variables):
   - `PLAYWRIGHT_BROWSERS_PATH` = `0` (already set via `vercel.json`; harmless to set here too)
4. Deploy. On every push to `main` Vercel re-builds and redeploys automatically.
   The deployed URL becomes `https://<project>.vercel.app`
   (e.g. `https://playwright-mcp-alpha.vercel.app`).

You can also deploy from the CLI:

```bash
npm i -g vercel
vercel --prod
```

### Vercel gotchas

- **Function size:** Chromium adds ~150 MB to the serverless bundle. If Vercel
  complains the function is too large, drop the `puppeteer` dependency
  (`npm uninstall puppeteer`) — the app's browser work goes through Playwright.
- **Duration:** API routes that launch the browser declare
  `export const maxDuration = 60;`. Hobby allows up to 60 s; the Pro plan allows 300 s.
- **Ephemeral disk:** tokens/session files (`.svp-token.json`,
  `.svp-storage.json`) are written to the server filesystem, which does **not**
  persist across cold starts on Vercel. If the app ever says
  *"Not authenticated. Please login first."*, re-run the SVP login flow to mint a
  fresh session, or pass the session via the UI.
