<?php

namespace Database\Seeders;

use App\Models\Contrato;
use App\Models\Espacio;
use App\Models\Locatario;
use Illuminate\Database\Seeder;

class ContratoSeeder extends Seeder
{
    public function run(): void
    {
        $locatarios = Locatario::all();
        $espacios = Espacio::all();
        $n = 1;

        foreach ($locatarios as $i => $loc) {
            $espacio = $espacios[$i] ?? null;
            if (! $espacio) break;

            // Mezcla: 5 vigentes largos, 3 por vencer (<=30 días), 2 vencidos
            if ($i < 5) {
                $inicio = now()->subMonths(6);
                $fin = now()->addMonths(rand(6, 12));
                $estado = 'Vigente';
            } elseif ($i < 8) {
                $inicio = now()->subMonths(11);
                $fin = now()->addDays(rand(5, 25));
                $estado = 'Vigente';
            } else {
                $inicio = now()->subMonths(14);
                $fin = now()->subDays(rand(5, 60));
                $estado = 'Vigente';
            }

            Contrato::create([
                'locatario_id' => $loc->id,
                'espacio_id' => $espacio->id,
                'codigo' => sprintf('C-%04d', $n++),
                'fecha_inicio' => $inicio,
                'fecha_fin' => $fin,
                'monto_mensual' => rand(1500, 8000),
                'estado' => $estado,
            ]);

            $espacio->update(['estado' => 'Ocupado', 'locatario_id' => $loc->id]);
        }
    }
}