<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Incidencia;
use App\Models\IncidenciaSeguimiento;
use App\Models\Notificacion;
use App\Models\User;
use Illuminate\Http\Request;

class IncidenciaController extends Controller
{
    private array $flujo = ['Pendiente'=>'Asignada','Asignada'=>'En proceso','En proceso'=>'Resuelta','Resuelta'=>'Cerrada'];

    public function index()
    {
        $user = auth('api')->user();
        $query = Incidencia::with('espacio', 'reportador', 'asignado');

        if ($user->role === 'Locatario') {
            $query->where('reportado_por', $user->id);
        }

        return $query->paginate(20);
    }

    public function store(Request $r)
    {
        $d = $r->validate([
            'titulo'=>'required',
            'descripcion'=>'required',
            'espacio_id'=>'nullable|exists:espacios,id',
            'asignado_a'=>'nullable|exists:users,id',
            'prioridad'=>'in:Baja,Media,Alta,Critica'
        ]);
        $d['reportado_por'] = auth('api')->id();
        
        $incidencia = Incidencia::create($d);

        // Registrar primer seguimiento
        IncidenciaSeguimiento::create([
            'incidencia_id' => $incidencia->id,
            'user_id' => auth('api')->id(),
            'estado_anterior' => null,
            'estado_nuevo' => 'Pendiente',
            'comentario' => 'Incidencia reportada'
        ]);

        // Notificar a Seguridad y Supervisores
        $avisar = User::whereIn('role', ['Seguridad', 'Supervisor'])->get();
        foreach ($avisar as $u) {
            Notificacion::create([
                'user_id' => $u->id,
                'texto' => "Nueva incidencia: {$incidencia->titulo}",
                'ruta' => '/incidencias',
                'clave' => "nueva_incidencia_{$incidencia->id}_{$u->id}"
            ]);
        }

        return response()->json($incidencia, 201);
    }

    public function show(Incidencia $incidencia)
    {
        $user = auth('api')->user();
        if ($user->role === 'Locatario' && $incidencia->reportado_por !== $user->id) {
            return response()->json(['message' => 'No autorizado'], 403);
        }
        return $incidencia->load('espacio', 'reportador', 'asignado');
    }

    public function update(Request $r, Incidencia $incidencia)
    {
        $d = $r->validate([
            'titulo'=>'sometimes',
            'descripcion'=>'sometimes',
            'espacio_id'=>'nullable|exists:espacios,id',
            'asignado_a'=>'nullable|exists:users,id',
            'prioridad'=>'in:Baja,Media,Alta,Critica'
        ]);
        $incidencia->update($d); 
        return $incidencia;
    }

    public function destroy(Incidencia $incidencia) { $incidencia->delete(); return response()->noContent(); }

    public function cambiarEstado(Request $r, Incidencia $incidencia)
    {
        $d = $r->validate([
            'estado'=>'required|in:Pendiente,Asignada,En proceso,Resuelta,Cerrada',
            'comentario' => 'nullable|string'
        ]);
        
        $actual = $incidencia->estado;
        if (($this->flujo[$actual] ?? null) !== $d['estado']) {
            return response()->json(['message'=>"Transición no permitida: $actual → {$d['estado']}"], 422);
        }

        $estadoAnterior = $actual;
        $incidencia->estado = $d['estado'];
        if ($d['estado'] === 'Cerrada') $incidencia->fecha_cierre = now();
        $incidencia->save();

        // Guardar historial
        IncidenciaSeguimiento::create([
            'incidencia_id' => $incidencia->id,
            'user_id' => auth('api')->id(),
            'estado_anterior' => $estadoAnterior,
            'estado_nuevo' => $d['estado'],
            'comentario' => $d['comentario'] ?? null
        ]);

        // Notificar al Locatario si se resolvió o cerró
        if (in_array($d['estado'], ['Resuelta', 'Cerrada'])) {
            Notificacion::create([
                'user_id' => $incidencia->reportado_por,
                'texto' => "Tu incidencia '{$incidencia->titulo}' pasó a estado: {$d['estado']}",
                'ruta' => '/incidencias',
                'clave' => "cambio_estado_{$incidencia->id}_{$d['estado']}"
            ]);
        }

        return $incidencia;
    }
}