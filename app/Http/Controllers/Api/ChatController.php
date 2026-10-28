<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use App\Models\Espacio;
use App\Models\Locatario;
use App\Models\Incidencia;
use App\Models\Cupone;

class ChatController extends Controller
{
    public function chat(Request $r)
    {
        $r->validate(['mensaje' => 'required|string']);
        $mensaje = strtolower($r->mensaje);
        $intencion = 'desconocido';

        // 1. Intentar conectar con Python (FastAPI)
        try {
            $res = Http::timeout(2)->post('http://127.0.0.1:8001/nlp', [
                'mensaje' => $mensaje
            ]);
            if ($res->successful()) {
                $intencion = $res->json('intencion');
            }
        } catch (\Exception $e) {
            // Si Python está apagado, no hacemos nada y usamos reglas locales
            \Log::warning('Python IA apagado. Usando reglas locales.');
        }

        // 2. Reglas de respaldo si Python falló o no entendió
        if ($intencion === 'desconocido') {
            if (str_contains($mensaje, 'hola')) $intencion = 'saludo';
            elseif (str_contains($mensaje, 'hora')) $intencion = 'horario';
            elseif (str_contains($mensaje, 'donde')) $intencion = 'ubicacion';
            elseif (str_contains($mensaje, 'libre')) $intencion = 'locales_libres';
            elseif (str_contains($mensaje, 'tienda')) $intencion = 'buscar_tienda';
        }

        // 3. Laravel resuelve la intención consultando PostgreSQL
        switch ($intencion) {
            case 'saludo':
                return ['respuesta' => '¡Hola! Bienvenido al Mall Caparazón. ¿En qué puedo ayudarte?'];
            
            case 'horario':
                return ['respuesta' => 'Nuestro horario es de Lunes a Domingo de 10:00 a.m. a 09:00 p.m.'];
            
            case 'ubicacion':
                return ['respuesta' => 'Estamos ubicados en la Zona La Vita, cerca al Puente Vita, La Paz, Bolivia.'];
            
            case 'locales_libres':
                $libres = Espacio::where('estado', 'Disponible')->count();
                return ['respuesta' => "Actualmente contamos con $libres locales disponibles para alquiler. Puedes ver más detalles en nuestro Directorio."];
            
            case 'buscar_tienda':
                $loc = Locatario::inRandomOrder()->first(); // Simulamos que buscó una tienda
                if ($loc) {
                    return ['respuesta' => "Tenemos la tienda '{$loc->nombre}' especializada en {$loc->rubro}. Puedes encontrarla en nuestro Directorio Público."];
                }
                return ['respuesta' => 'No encontramos tiendas con ese nombre.'];
            
            case 'estado_incidencia':
                // Si el usuario está logueado, buscamos su última incidencia
                if (auth('api')->check()) {
                    $inc = Incidencia::where('reportado_por', auth('api')->id())->latest()->first();
                    if ($inc) {
                        return ['respuesta' => "Tu incidencia más reciente es '{$inc->titulo}' y su estado actual es: {$inc->estado}."];
                    }
                }
                return ['respuesta' => 'Debes iniciar sesión con tu cuenta de Locatario para consultar el estado de tus incidencias.'];
            
            case 'cupones':
                return ['respuesta' => 'Tenemos descuentos exclusivos para clientes VIP y Frecuentes. ¡Pregunta en administración por nuestros cupones!'];
            
            default:
                return ['respuesta' => 'Lo siento, no entendí tu pregunta. Puedes preguntarme sobre horarios, ubicación, locales disponibles o buscar una tienda.'];
        }
    }
}