<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Espacio;
use Illuminate\Http\Request;

class EspacioController extends Controller
{
    public function index() { return Espacio::with('locatario')->get(); }
    public function store(Request $r) {
        $d = $r->validate(['codigo'=>'required|unique:espacios','piso'=>'required','zona'=>'nullable','area_m2'=>'nullable|numeric','coord_x'=>'nullable|numeric','coord_y'=>'nullable|numeric','estado'=>'in:Disponible,Ocupado,Mantenimiento','locatario_id'=>'nullable|exists:locatarios,id']);
        return response()->json(Espacio::create($d), 201);
    }
    public function show(Espacio $espacio) { return $espacio->load('locatario','contratos','incidencias'); }
    public function update(Request $r, Espacio $espacio) {
        $d = $r->validate(['codigo'=>'sometimes|unique:espacios,codigo,'.$espacio->id,'piso'=>'sometimes','zona'=>'nullable','area_m2'=>'nullable|numeric','coord_x'=>'nullable|numeric','coord_y'=>'nullable|numeric','estado'=>'in:Disponible,Ocupado,Mantenimiento','locatario_id'=>'nullable|exists:locatarios,id']);
        $espacio->update($d); return $espacio;
    }
    public function destroy(Espacio $espacio) { $espacio->delete(); return response()->noContent(); }
}