<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Visitante;
use App\Models\Campana;
use App\Models\Cupone;
use App\Services\SegmentacionService;
use Illuminate\Http\Request;
use Carbon\Carbon;

class FidelizacionController extends Controller
{
    public function resumen()
    {
        return response()->json([
            'visitantes' => Visitante::count(),
            'vip' => Visitante::where('segmento', 'vip')->count(),
            'frecuentes' => Visitante::where('segmento', 'frecuente')->count(),
            'en_riesgo' => Visitante::where('segmento', 'en_riesgo')->count(),
            'nuevos' => Visitante::where('segmento', 'nuevo')->count(),
            'cupones_activos' => Cupone::where('estado', 'activo')->count(),
        ]);
    }

    public function recalcular(SegmentacionService $service)
    {
        $service->recalcular();
        return response()->json(['message' => 'Segmentación recalculada con éxito']);
    }

    public function listaVisitantes(Request $request)
    {
        $query = Visitante::orderBy('id', 'desc');
        if ($request->has('segmento')) {
            $query->where('segmento', $request->segmento);
        }
        return $query->paginate(20);
    }

    public function crearCampana(Request $r)
    {
        $d = $r->validate([
            'nombre' => 'required',
            'segmento_objetivo' => 'required',
            'descuento_porcentaje' => 'required|numeric|min:1|max:100',
            'fecha_inicio' => 'required|date',
            'fecha_fin' => 'required|date|after:fecha_inicio',
        ]);
        $c = Campana::create($d);
        return response()->json($c, 201);
    }

    public function generarCupones(Campana $campana)
    {
        $visitantes = Visitante::where('segmento', $campana->segmento_objetivo)->get();
        $generados = 0;
        
        foreach ($visitantes as $v) {
            // Verificar si ya tiene cupón para esta campaña
            $existe = Cupone::where('campana_id', $campana->id)->where('visitante_id', $v->id)->exists();
            if (!$existe) {
                Cupone::create([
                    'campana_id' => $campana->id,
                    'codigo' => 'CUP-' . strtoupper(uniqid()),
                    'visitante_id' => $v->id,
                    'descuento_porcentaje' => $campana->descuento_porcentaje,
                    'estado' => 'activo',
                    'fecha_emision' => now(),
                    'fecha_vencimiento' => now()->addDays(30)
                ]);
                $generados++;
            }
        }
        return response()->json(['message' => "Se generaron $generados cupones"]);
    }

    public function canjearCupon(Request $r)
    {
        $r->validate(['codigo' => 'required|exists:cupones,codigo']);
        $cupon = Cupone::where('codigo', $r->codigo)->first();

        if ($cupon->estado === 'canjeado') {
            return response()->json(['message' => 'Este cupón ya fue canjeado'], 422);
        }
        if ($cupon->estado === 'vencido' || Carbon::parse($cupon->fecha_vencimiento)->isPast()) {
            $cupon->update(['estado' => 'vencido']);
            return response()->json(['message' => 'Este cupón está vencido'], 422);
        }

        $cupon->update(['estado' => 'canjeado', 'fecha_canje' => now()]);
        return response()->json(['message' => 'Cupón canjeado con éxito', 'cupon' => $cupon]);
    }
}