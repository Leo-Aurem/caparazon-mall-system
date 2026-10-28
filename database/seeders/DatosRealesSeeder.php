<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Locatario;
use App\Models\Espacio;
use App\Models\Contrato;
use App\Models\Incidencia;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;

class DatosRealesSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Limpiar tablas
        DB::statement('TRUNCATE TABLE incidencias CASCADE');
        DB::statement('TRUNCATE TABLE contratos CASCADE');
        DB::statement('TRUNCATE TABLE espacios CASCADE');
        DB::statement('TRUNCATE TABLE locatarios CASCADE');
        DB::statement('TRUNCATE TABLE users CASCADE');

        // 2. Crear Usuarios del Sistema
        $roles = [
            ['name' => 'Carlos Admin', 'email' => 'admin@caparazon.bo', 'role' => 'Administrador'],
            ['name' => 'Maria Supervisora', 'email' => 'supervisor@caparazon.bo', 'role' => 'Supervisor'],
            ['name' => 'Juan Operador', 'email' => 'operador@caparazon.bo', 'role' => 'Operador'],
            ['name' => 'Pedro Seguridad', 'email' => 'seguridad@caparazon.bo', 'role' => 'Seguridad'],
            ['name' => 'Empresa Locataria', 'email' => 'locatario@caparazon.bo', 'role' => 'Locatario'],
        ];
        foreach ($roles as $r) {
            User::create(array_merge($r, ['password' => Hash::make('Caparazon2026!')]));
        }

        // 3. Locatarios (Nombres Reales)
        $tiendas = [
            ['nombre' => 'Zapatillas BolivIA', 'rubro' => 'Calzado', 'rep' => 'Roberto Gomez'],
            ['nombre' => 'Burger King', 'rubro' => 'Comida', 'rep' => 'Lucia Perez'],
            ['nombre' => 'TecnoStore', 'rubro' => 'Tecnología', 'rep' => 'Diego Flores'],
            ['nombre' => 'Farmacia San Juan', 'rubro' => 'Salud', 'rep' => 'Ana Rojas'],
            ['nombre' => 'Ropa Elegante', 'rubro' => 'Ropa', 'rep' => 'Carla Mamani'],
            ['nombre' => 'Juguetes Felices', 'rubro' => 'Juguetes', 'rep' => 'Luis Quispe'],
            ['nombre' => 'Café La Vita', 'rubro' => 'Comida', 'rep' => 'Elena Choque'],
            ['nombre' => 'Perfumería Glamour', 'rubro' => 'Cosméticos', 'rep' => 'Sofia Ticona'],
            ['nombre' => 'Librería Central', 'rubro' => 'Librería', 'rep' => 'Jorge Condori'],
            ['nombre' => 'Gimnasio FitLife', 'rubro' => 'Deportes', 'rep' => 'Marco Apaza'],
            ['nombre' => 'Heladería Bravos', 'rubro' => 'Comida', 'rep' => 'Sara Limachi'],
            ['nombre' => 'Óptica Visión', 'rubro' => 'Salud', 'rep' => 'Rene Villca'],
        ];
        
        $locatariosCreados = [];
        foreach ($tiendas as $i => $t) {
            $locatariosCreados[] = Locatario::create([
                'nombre' => $t['nombre'],
                'nit' => rand(1000000, 9999999) . '01' . $i,
                'representante' => $t['rep'],
                'telefono' => '7' . rand(1000000, 9999999),
                'email' => 'contacto@' . strtolower(str_replace(' ', '', $t['nombre'])) . '.com',
                'rubro' => $t['rubro'],
                'estado' => 'Activo'
            ]);
        }

        // 4. Espacios (Mapa perfecto)
        $pisos = ['Planta Baja', 'Piso 1', 'Piso 2'];
        $n = 1;
        $espaciosCreados = [];
        foreach ($pisos as $piso) {
            for ($fila = 0; $fila < 2; $fila++) {
                for ($col = 0; $col < 10; $col++) {
                    $map_x = 50 + ($col * 90);
                    $map_y = $fila === 0 ? 50 : 250;

                    $espaciosCreados[] = Espacio::create([
                        'codigo' => 'L-' . sprintf('%02d', $n++),
                        'piso' => $piso,
                        'zona' => 'Ala ' . ($col + 1),
                        'area_m2' => rand(20, 80),
                        'coord_x' => $map_x,
                        'coord_y' => $map_y,
                        'estado' => 'Disponible',
                    ]);
                }
            }
        }

        // 5. Contratos (Asignar Locatarios a Espacios)
        for ($i = 0; $i < count($locatariosCreados); $i++) {
            $espacio = $espaciosCreados[$i];
            $locatario = $locatariosCreados[$i];
            
            $inicio = now()->subMonths(rand(1, 10));
            $fin = now()->addMonths(rand(1, 12));

            Contrato::create([
                'locatario_id' => $locatario->id,
                'espacio_id' => $espacio->id,
                'codigo' => 'CTR-' . sprintf('%04d', $i + 1),
                'fecha_inicio' => $inicio,
                'fecha_fin' => $fin,
                'monto_mensual' => rand(2000, 8000),
                'estado' => 'Vigente',
            ]);

            $espacio->update(['estado' => 'Ocupado', 'locatario_id' => $locatario->id]);
        }

        // 6. Incidencias Reales
        $problemas = [
            'Fuga de agua en el baño de hombres',
            'Luz quemada en el pasillo central',
            'Aire acondicionado no enfría',
            'Puerta de vidrio rota en el local',
            'Basura acumulada en la zona de comidas',
            'Ruido excesivo en el local de al lado',
            'Cámara de seguridad desconectada',
            'Escaleras eléctricas detenidas',
            'Filtración de agua en el techo',
            'Vidrio roto en la entrada principal'
        ];

        // Obtenemos los IDs reales de los usuarios creados
        $admin = User::where('email', 'admin@caparazon.bo')->first();
        $operador = User::where('email', 'operador@caparazon.bo')->first();

        for ($i = 0; $i < 25; $i++) {
            Incidencia::create([
                'titulo' => $problemas[array_rand($problemas)],
                'descripcion' => 'Se reporta el problema para su revisión inmediata por el equipo de mantenimiento.',
                'espacio_id' => $espaciosCreados[array_rand($espaciosCreados)]->id,
                'reportado_por' => $admin->id, 
                'asignado_a' => $operador->id, 
                'prioridad' => ['Baja','Media','Alta','Critica'][rand(0,3)],
                'estado' => ['Pendiente','Asignada','En proceso','Resuelta','Cerrada'][rand(0,4)],
            ]);
        }
    }
}