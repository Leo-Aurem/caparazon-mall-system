<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;

class Visita extends Model {
    protected $fillable = ['visitante_id','fecha_hora','zona','gasto_bs'];
    public function visitante() { return $this->belongsTo(Visitante::class); }
}