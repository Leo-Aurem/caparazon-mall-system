<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;

class Visitante extends Model {
    protected $fillable = ['nombre','email','telefono','fecha_registro','segmento','puntos','ultima_visita'];
    public function visitas() { return $this->hasMany(Visita::class); }
    public function cupones() { return $this->hasMany(Cupone::class); }
}