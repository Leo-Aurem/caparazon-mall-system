<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Locatario;

class FidelizacionController extends Controller
{
    public function index()
    {
        $locatarios = Locatario::all();
        
        // Simulación de cálculo RFM (Recency, Frequency, Monetary)
        $datos = $locatarios->map(function ($loc, $index) {
            // Generamos valores aleatorios simulados para la demo
            $recencia = rand(1, 90); // Días desde la última compra
            $frecuencia = rand(1, 50); // Número de compras
            $monto = rand(100, 5000); // Monto total gastado

            // Segmentación básica
            $segmento = 'Nuevo';
            if ($monto > 3000 && $frecuencia > 20) $segmento = 'VIP';
            else if ($monto > 1500) $segmento = 'Frecuente';
            else if ($recencia > 60) $segmento = 'En Riesgo';

            return [
                'id' => $loc->id,
                'nombre' => $loc->nombre,
                'rubro' => $loc->rubro,
                'recencia' => $recencia,
                'frecuencia' => $frecuencia,
                'monto_total' => $monto,
                'segmento' => $segmento
            ];
        });

        return response()->json($datos);
    }
}
