<?php

namespace Database\Seeders;

use App\Models\Espacio;
use Illuminate\Database\Seeder;

class EspacioSeeder extends Seeder
{
    public function run(): void
    {
        $pisos = ['Planta Baja','Piso 1','Piso 2'];
        $n = 1;
        foreach ($pisos as $piso) {
            for ($z = 1; $z <= 7; $z++) {
                Espacio::create([
                    'codigo' => sprintf('E-%02d', $n++),
                    'piso' => $piso,
                    'zona' => "Zona $z",
                    'area_m2' => rand(20, 80),
                    'coord_x' => rand(10, 900),
                    'coord_y' => rand(10, 500),
                    'estado' => 'Disponible',
                ]);
            }
        }
    }
}