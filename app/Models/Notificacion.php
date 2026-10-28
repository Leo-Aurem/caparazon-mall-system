<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Notificacion extends Model
{
    protected $table = 'notificaciones'; // Por si Laravel busca en inglés
    protected $fillable = ['user_id', 'texto', 'ruta', 'clave', 'leida'];
}