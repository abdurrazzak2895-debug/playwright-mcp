/** @type {import('next').NextConfig} */
const nextConfig = {
  /* config options here */
  reactCompiler: true,
  allowedDevOrigins: ['192.168.31.175'],
  // Ship Playwright's browsers.json + Chromium binaries inside every API
  // route's serverless trace. Playwright-core `require`s browsers.json via a
  // dynamic path, so static tracing alone never picks it up (breaks Vercel).
  outputFileTracingIncludes: {
    '/api/**': [
      './node_modules/playwright-core/browsers.json',
      './node_modules/playwright-core/.local-browsers/**/*',
      './node_modules/.cache/ms-playwright/**/*'
    ]
  }
};

export default nextConfig;
