<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;

class Cupone extends Model {
    protected $fillable = ['campana_id','codigo','visitante_id','locatario_id','descuento_porcentaje','estado','fecha_emision','fecha_vencimiento','fecha_canje'];
    public function campana() { return $this->belongsTo(Campana::class); }
    public function visitante() { return $this->belongsTo(Visitante::class); }
}