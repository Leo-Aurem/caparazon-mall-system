<?php

namespace Database\Seeders;

use App\Models\Espacio;
use App\Models\Incidencia;
use App\Models\User;
use Illuminate\Database\Seeder;

class IncidenciaSeeder extends Seeder
{
    public function run(): void
    {
        $espacios = Espacio::all();
        $admin = User::where('role', 'Administrador')->first();
        $operador = User::where('role', 'Operador')->first();
        $estados = ['Pendiente','Asignada','En proceso','Resuelta','Cerrada'];
        $prioridades = ['Baja','Media','Alta','Critica'];

        for ($i = 1; $i <= 25; $i++) {
            Incidencia::create([
                'titulo' => "Incidencia #$i",
                'descripcion' => "Descripción simulada de la incidencia $i",
                'espacio_id' => $espacios->random()->id,
                'reportado_por' => $admin->id,
                'asignado_a' => $i % 2 === 0 ? $operador->id : null,
                'prioridad' => $prioridades[array_rand($prioridades)],
                'estado' => $estados[array_rand($estados)],
                'fecha_cierre' => null,
            ]);
        }
    }
}