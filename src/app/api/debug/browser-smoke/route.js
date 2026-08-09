import { NextResponse } from 'next/server';
import { probeBrowser } from '@/lib/svp-playwright';

export const dynamic = 'force-dynamic';
export const maxDuration = 60;

export async function GET() {
  const result = await probeBrowser();
  return NextResponse.json(
    { success: result.ok, data: result },
    { status: result.ok ? 200 : 500 }
  );
}