<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Tymon\JWTAuth\Contracts\JWTSubject;

class User extends Authenticatable implements JWTSubject
{
    use Notifiable;

    protected $fillable = ['name','email','password','role','activo'];
    protected $hidden = ['password','remember_token'];
    protected $casts = ['email_verified_at' => 'datetime','password' => 'hashed','activo' => 'boolean'];

    public function getJWTIdentifier() { return $this->getKey(); }
    public function getJWTCustomClaims() { return ['role' => $this->role]; }

    public function esAdmin(): bool { return $this->role === 'Administrador'; }
    public function tieneRol(string ...$roles): bool { return in_array($this->role, $roles, true); }
}