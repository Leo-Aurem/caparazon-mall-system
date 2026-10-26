<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Incidencia;
use Illuminate\Http\Request;

class IncidenciaController extends Controller
{
    private array $flujo = ['Pendiente'=>'Asignada','Asignada'=>'En proceso','En proceso'=>'Resuelta','Resuelta'=>'Cerrada'];

    public function index() { return Incidencia::with('espacio','reportador','asignado')->paginate(20); }
    public function store(Request $r) {
        $d = $r->validate(['titulo'=>'required','descripcion'=>'required','espacio_id'=>'nullable|exists:espacios,id','asignado_a'=>'nullable|exists:users,id','prioridad'=>'in:Baja,Media,Alta,Critica']);
        $d['reportado_por'] = auth('api')->id();
        return response()->json(Incidencia::create($d), 201);
    }
    public function show(Incidencia $incidencia) { return $incidencia->load('espacio','reportador','asignado'); }
    public function update(Request $r, Incidencia $incidencia) {
        $d = $r->validate(['titulo'=>'sometimes','descripcion'=>'sometimes','espacio_id'=>'nullable|exists:espacios,id','asignado_a'=>'nullable|exists:users,id','prioridad'=>'in:Baja,Media,Alta,Critica']);
        $incidencia->update($d); return $incidencia;
    }
    public function destroy(Incidencia $incidencia) { $incidencia->delete(); return response()->noContent(); }

    public function cambiarEstado(Request $r, Incidencia $incidencia) {
        $d = $r->validate(['estado'=>'required|in:Pendiente,Asignada,En proceso,Resuelta,Cerrada']);
        $actual = $incidencia->estado;
        if (($this->flujo[$actual] ?? null) !== $d['estado']) {
            return response()->json(['message'=>"Transición no permitida: $actual → {$d['estado']}"], 422);
        }
        $incidencia->estado = $d['estado'];
        if ($d['estado'] === 'Cerrada') $incidencia->fecha_cierre = now();
        $incidencia->save();
        return $incidencia;
    }
}