<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Incidencia extends Model
{
    protected $fillable = ['titulo','descripcion','espacio_id','reportado_por','asignado_a','prioridad','estado','fecha_cierre'];
    protected $casts = ['fecha_cierre' => 'datetime'];

    public function espacio() { return $this->belongsTo(Espacio::class); }
    public function reportador() { return $this->belongsTo(User::class, 'reportado_por'); }
    public function asignado() { return $this->belongsTo(User::class, 'asignado_a'); }
}