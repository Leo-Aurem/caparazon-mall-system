<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Auditoria extends Model
{
    protected $table = 'auditoria';
    protected $fillable = ['usuario_id','tabla','registro_id','accion','datos_antes','datos_despues','ip'];
    protected $casts = ['datos_antes' => 'array','datos_despues' => 'array'];
}