<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Locatario extends Model
{
    use SoftDeletes;

    protected $fillable = ['nombre','nit','representante','telefono','email','rubro','estado'];

    public function espacios() { return $this->hasMany(Espacio::class); }
    public function contratos() { return $this->hasMany(Contrato::class); }
}