<?php

namespace Database\Seeders;

use App\Models\Locatario;
use Illuminate\Database\Seeder;

class LocatarioSeeder extends Seeder
{
    public function run(): void
    {
        $rubros = ['Ropa','Comida','Tecnología','Juguetes','Calzado','Cosméticos','Librería','Deportes','Mascotas','Servicios'];
        foreach ($rubros as $i => $rubro) {
            Locatario::create([
                'nombre' => "Locatario $rubro",
                'nit' => sprintf('NIT-%04d', $i + 1),
                'representante' => "Rep $rubro",
                'telefono' => '7' . rand(1000000, 9999999),
                'email' => strtolower($rubro) . '@caparazon.bo',
                'rubro' => $rubro,
                'estado' => 'Activo',
            ]);
        }
    }
}