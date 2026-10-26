<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Contrato extends Model
{
    protected $fillable = ['locatario_id','espacio_id','codigo','fecha_inicio','fecha_fin','monto_mensual','estado','observaciones'];
    protected $casts = ['fecha_inicio' => 'date','fecha_fin' => 'date','monto_mensual' => 'decimal:2'];

    public function locatario() { return $this->belongsTo(Locatario::class); }
    public function espacio() { return $this->belongsTo(Espacio::class); }
}