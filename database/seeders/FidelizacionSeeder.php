<?php
namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Visitante;
use App\Models\Visita;
use Carbon\Carbon;

class FidelizacionSeeder extends Seeder
{
    public function run(): void
    {
        mt_srand(12345); // Semilla fija para que los datos sean deterministas
        $ahora = Carbon::now();

        for ($i = 0; $i < 800; $i++) {
            $v = Visitante::create([
                'nombre' => "Visitante $i",
                'email' => "visita$i@test.com",
                'fecha_registro' => $ahora->copy()->subDays(mt_rand(1, 365)),
                'puntos' => mt_rand(10, 5000),
            ]);

            // Generar ~10 visitas por visitante
            for ($j = 0; $j < 10; $j++) {
                Visita::create([
                    'visitante_id' => $v->id,
                    'fecha_hora' => $ahora->copy()->subDays(mt_rand(1, 365)),
                    'zona' => 'Zona ' . mt_rand(1, 5),
                    'gasto_bs' => mt_rand(10, 300),
                ]);
            }
        }
    }
}