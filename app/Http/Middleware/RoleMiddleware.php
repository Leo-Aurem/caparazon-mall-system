<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class RoleMiddleware
{
    public function handle(Request $request, Closure $next, string ...$roles)
    {
        $user = auth('api')->user();

        if (! $user || ! $user->tieneRol(...$roles)) {
            return response()->json(['message' => 'No autorizado para este rol'], 403);
        }

        return $next($request);
    }
}