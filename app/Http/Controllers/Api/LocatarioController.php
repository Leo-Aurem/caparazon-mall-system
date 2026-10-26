<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Locatario;
use Illuminate\Http\Request;

class LocatarioController extends Controller
{
    public function index() { return Locatario::with('espacios')->paginate(20); }
    public function store(Request $r) {
        $d = $r->validate(['nombre'=>'required','nit'=>'required|unique:locatarios','representante'=>'nullable','telefono'=>'nullable','email'=>'nullable|email','rubro'=>'nullable','estado'=>'in:Activo,Inactivo,Suspendido']);
        return response()->json(Locatario::create($d), 201);
    }
    public function show(Locatario $locatario) { return $locatario->load('espacios','contratos'); }
    public function update(Request $r, Locatario $locatario) {
        $d = $r->validate(['nombre'=>'sometimes','nit'=>'sometimes|unique:locatarios,nit,'.$locatario->id,'representante'=>'nullable','telefono'=>'nullable','email'=>'nullable|email','rubro'=>'nullable','estado'=>'in:Activo,Inactivo,Suspendido']);
        $locatario->update($d); return $locatario;
    }
    public function destroy(Locatario $locatario) { $locatario->delete(); return response()->noContent(); }
}