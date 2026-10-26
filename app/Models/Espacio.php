<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Espacio extends Model
{
    protected $fillable = ['codigo','piso','zona','area_m2','coord_x','coord_y','estado','locatario_id'];

    public function locatario() { return $this->belongsTo(Locatario::class); }
    public function contratos() { return $this->hasMany(Contrato::class); }
    public function incidencias() { return $this->hasMany(Incidencia::class); }
}