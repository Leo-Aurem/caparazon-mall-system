<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Contrato;
use Illuminate\Http\Request;

class ContratoController extends Controller
{
    public function index() { return Contrato::with('locatario','espacio')->paginate(20); }
    public function store(Request $r) {
        $d = $r->validate(['locatario_id'=>'required|exists:locatarios,id','espacio_id'=>'required|exists:espacios,id','codigo'=>'required|unique:contratos','fecha_inicio'=>'required|date','fecha_fin'=>'required|date|after:fecha_inicio','monto_mensual'=>'required|numeric','estado'=>'in:Vigente,Por vencer,Vencido,Rescindido','observaciones'=>'nullable']);
        return response()->json(Contrato::create($d), 201);
    }
    public function show(Contrato $contrato) { return $contrato->load('locatario','espacio'); }
    public function update(Request $r, Contrato $contrato) {
        $d = $r->validate(['locatario_id'=>'sometimes|exists:locatarios,id','espacio_id'=>'sometimes|exists:espacios,id','codigo'=>'sometimes|unique:contratos,codigo,'.$contrato->id,'fecha_inicio'=>'sometimes|date','fecha_fin'=>'sometimes|date|after:fecha_inicio','monto_mensual'=>'sometimes|numeric','estado'=>'in:Vigente,Por vencer,Vencido,Rescindido','observaciones'=>'nullable']);
        $contrato->update($d); return $contrato;
    }
    public function destroy(Contrato $contrato) { $contrato->delete(); return response()->noContent(); }

    public function porVencer() {
        return Contrato::whereBetween('fecha_fin', [now(), now()->addDays(30)])
            ->where('estado', '!=', 'Rescindido')->get();
    }
}