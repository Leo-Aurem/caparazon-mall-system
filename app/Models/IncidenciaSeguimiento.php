<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class IncidenciaSeguimiento extends Model
{
    protected $table = 'incidencia_seguimientos';
    protected $fillable = ['incidencia_id', 'user_id', 'estado_anterior', 'estado_nuevo', 'comentario'];

    public function user() { return $this->belongsTo(User::class); }
}