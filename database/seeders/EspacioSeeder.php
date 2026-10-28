<?php

namespace Database\Seeders;

use App\Models\Espacio;
use Illuminate\Database\Seeder;

class EspacioSeeder extends Seeder
{
    public function run(): void
    {
        $pisos = ['Planta Baja', 'Piso 1', 'Piso 2'];
        $n = 1;
        
        foreach ($pisos as $piso) {
            // 2 filas de 10 locales (20 por piso)
            for ($fila = 0; $fila < 2; $fila++) {
                for ($col = 0; $col < 10; $col++) {
                    // Calculamos coordenadas fijas en cuadrícula
                    $map_x = 50 + ($col * 90);
                    $map_y = $fila === 0 ? 50 : 250;

                    Espacio::create([
                        'codigo' => sprintf('E-%02d', $n++),
                        'piso' => $piso,
                        'zona' => 'Zona ' . ($col + 1),
                        'area_m2' => rand(20, 80),
                        'coord_x' => $map_x,
                        'coord_y' => $map_y,
                        'estado' => 'Disponible',
                    ]);
                }
            }
        }
    }
}