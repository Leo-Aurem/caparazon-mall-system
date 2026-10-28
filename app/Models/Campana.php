<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;

class Campana extends Model {
    protected $fillable = ['nombre','segmento_objetivo','descuento_porcentaje','fecha_inicio','fecha_fin','activa'];
    public function cupones() { return $this->hasMany(Cupone::class); }
}