// Simple in-memory sliding window rate limiter.
// Each client gets a list of timestamps. Requests older than the window are pruned.
// Expired clients are cleaned up every 60 seconds.

interface RateLimitConfig {
  interval: number; // window in ms
  maxRequests: number;
}

interface RateLimitResult {
  success: boolean;
  remaining: number;
  reset: number; // seconds until window resets
}

export function createRateLimiter(config: RateLimitConfig) {
  const clients = new Map<string, number[]>();

  // Periodic cleanup of expired entries
  setInterval(() => {
    const now = Date.now();
    for (const [key, timestamps] of clients) {
      const valid = timestamps.filter((t) => now - t < config.interval);
      if (valid.length === 0) clients.delete(key);
      else clients.set(key, valid);
    }
  }, 60_000).unref();

  return function check(clientId: string): RateLimitResult {
    const now = Date.now();
    const timestamps = clients.get(clientId) || [];
    const valid = timestamps.filter((t) => now - t < config.interval);

    if (valid.length >= config.maxRequests) {
      const oldest = valid[0];
      const reset = Math.ceil((oldest + config.interval - now) / 1000);
      return { success: false, remaining: 0, reset };
    }

    valid.push(now);
    clients.set(clientId, valid);
    return {
      success: true,
      remaining: config.maxRequests - valid.length,
      reset: Math.ceil(config.interval / 1000),
    };
  };
}

// Pre-configured limiters
export const chatLimiter = createRateLimiter({
  interval: 60_000,
  maxRequests: 20,
});
export const authLimiter = createRateLimiter({
  interval: 60_000,
  maxRequests: 5,
});
export const ingestLimiter = createRateLimiter({
  interval: 60_000,
  maxRequests: 10,
});
export const adminLimiter = createRateLimiter({
  interval: 60_000,
  maxRequests: 30,
});

// Helper to extract client identifier from request
export function getClientId(request: Request): string {
  const forwarded = request.headers.get("x-forwarded-for");
  if (forwarded) return forwarded.split(",")[0].trim();
  return "unknown";
}

// Helper to create a 429 Too Many Requests response
export function rateLimitResponse(reset: number): Response {
  return Response.json(
    { error: "Too many requests. Please try again later." },
    {
      status: 429,
      headers: { "Retry-After": String(reset) },
    }
  );
}
