// src/app/api/proxy/[...path]/route.ts
import { NextRequest, NextResponse } from 'next/server';

const BACKEND_URL = process.env.BACKEND_API_URL || 'https://teammanagementbackend.projectece5566.workers.dev';

async function proxyRequest(request: NextRequest, { params }: { params: Promise<{ path: string[] }> }) {
  const accessToken = request.cookies.get('access_token')?.value;

  // For logout or profile fetch, we need the token. 
  // Public routes shouldn't use the proxy or handle auth separately.
  if (!accessToken) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const { path } = await params;
  const targetPath = path.join('/');
  const url = new URL(request.url);
  const queryString = url.searchParams.toString();
  const targetUrl = `${BACKEND_URL}/${targetPath}${queryString ? `?${queryString}` : ''}`;

  const headers: HeadersInit = {
    Authorization: `Bearer ${accessToken}`,
    'Content-Type': request.headers.get('Content-Type') || 'application/json',
  };

  const fetchOptions: RequestInit = {
    method: request.method,
    headers,
  };

  if (['POST', 'PUT', 'PATCH'].includes(request.method)) {
    fetchOptions.body = await request.text();
  }

  try {
    const response = await fetch(targetUrl, fetchOptions);

    if (response.status === 401) {
      // In a real billing app, we'd handle refresh token logic here.
      // For now, we return 401 and the frontend redirects to login.
      return NextResponse.json({ error: 'Session expired' }, { status: 401 });
    }

    const data = await response.json();
    return NextResponse.json(data, { status: response.status });
  } catch (error) {
    console.error('Proxy error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

export const GET = proxyRequest;
export const POST = proxyRequest;
export const PUT = proxyRequest;
export const PATCH = proxyRequest;
export const DELETE = proxyRequest;
