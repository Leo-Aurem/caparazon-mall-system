<?php
namespace App\Services;

use App\Models\Visitante;
use Carbon\Carbon;

class SegmentacionService
{
    public function recalcular()
    {
        $hoy = Carbon::now();
        $visitantes = Visitante::with('visitas')->get();

        foreach ($visitantes as $v) {
            $totalVisitas = $v->visitas->count();
            $ultimaVisita = $v->visitas->max('fecha_hora') ? Carbon::parse($v->visitas->max('fecha_hora')) : null;
            $diasUltima = $ultimaVisita ? $ultimaVisita->diffInDays($hoy) : 999;
            
            // Visitas en los últimos 90 días
            $visitas90 = $v->visitas->filter(function($vis) use ($hoy) {
                return Carbon::parse($vis->fecha_hora)->diffInDays($hoy) <= 90;
            });
            
            $gasto90 = $visitas90->sum('gasto_bs');

            $segmento = 'ocasional';

            if ($totalVisitas <= 1) {
                $segmento = 'nuevo';
            } elseif ($diasUltima > 60) {
                $segmento = 'en_riesgo';
            } elseif ($visitas90->count() >= 10 && $gasto90 >= 1500) {
                $segmento = 'vip';
            } elseif ($visitas90->count() >= 4) {
                $segmento = 'frecuente';
            }

            $v->update([
                'segmento' => $segmento,
                'ultima_visita' => $ultimaVisita
            ]);
        }
        return true;
    }
}