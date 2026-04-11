// src/lib/api-client.ts

type HttpMethod = 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE';

interface ApiResponse<T> {
  data: T;
  message?: string;
  pagination?: {
    page: number;
    pageSize: number;
    totalCount: number;
    totalPages: number;
  };
}

class ApiClient {
  private baseUrl: string;

  constructor(baseUrl: string) {
    this.baseUrl = baseUrl;
  }

  async request<T>(
    method: HttpMethod,
    path: string,
    options?: {
      body?: unknown;
      params?: Record<string, string>;
      next?: NextFetchRequestConfig;
    }
  ): Promise<ApiResponse<T>> {
    const url = new URL(`${this.baseUrl}${path}`);

    if (options?.params) {
      Object.entries(options.params).forEach(([key, value]) => {
        url.searchParams.set(key, value);
      });
    }

    const response = await fetch(url.toString(), {
      method,
      headers: { 'Content-Type': 'application/json' },
      body: options?.body ? JSON.stringify(options.body) : undefined,
      next: options?.next,
    });

    if (!response.ok) {
      throw new ApiError(response.status, await response.json());
    }

    return response.json();
  }

  get<T>(path: string, options?: { params?: Record<string, string>; next?: NextFetchRequestConfig }) {
    return this.request<T>('GET', path, options);
  }

  post<T>(path: string, body: unknown) {
    return this.request<T>('POST', path, { body });
  }

  put<T>(path: string, body: unknown) {
    return this.request<T>('PUT', path, { body });
  }

  delete<T>(path: string) {
    return this.request<T>('DELETE', path);
  }
}

class ApiError extends Error {
  constructor(public status: number, public body: unknown) {
    super(`API Error: ${status}`);
  }
}

// Backend URL from Flutter app: https://teammanagementbackend.projectece5566.workers.dev
const BACKEND_URL = process.env.BACKEND_API_URL || 'https://teammanagementbackend.projectece5566.workers.dev';

// Server-side client (for Server Components — calls backend directly)
export const serverApi = new ApiClient(BACKEND_URL);

// Client-side client (for Client Components — calls Next.js API routes proxy)
export const clientApi = new ApiClient('/api/proxy');
