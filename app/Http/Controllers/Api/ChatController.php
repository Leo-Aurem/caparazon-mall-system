<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use App\Models\Espacio;
use App\Models\Locatario;
use App\Models\Incidencia;

class ChatController extends Controller
{
    public function chat(Request $r)
    {
        $r->validate(['mensaje' => 'required|string']);
        $mensajeOriginal = $r->mensaje;
        $mensaje = mb_strtolower($mensajeOriginal);

        $intencion = 'desconocido';
        $entidades = [];
        $respuestaSugerida = null;

        // 1. Conectar con Python (FastAPI)
        try {
            $res = Http::timeout(2)->post('http://127.0.0.1:8001/nlp', [
                'mensaje' => $mensajeOriginal
            ]);
            if ($res->successful()) {
                $data = $res->json();
                $intencion = $data['intencion'] ?? 'desconocido';
                $entidades = $data['entidades'] ?? [];
                $respuestaSugerida = $data['respuesta_sugerida'] ?? null;
            }
        } catch (\Exception $e) {
            \Log::warning('Python IA apagado. Usando reglas locales.');
        }

        // 2. Respaldo local si Python está apagado o devolvió desconocido
        if ($intencion === 'desconocido') {
            if (preg_match('/(hola|buenos|buenas|que tal)/i', $mensaje)) {
                $intencion = 'saludo';
            } elseif (preg_match('/(hora|abren|cierran|horario)/i', $mensaje)) {
                $intencion = 'horario';
            } elseif (preg_match('/(donde|ubicacion|direccion|queda|llegar)/i', $mensaje)) {
                $intencion = 'ubicacion';
            } elseif (preg_match('/(libre|alquil|disponible|espacio)/i', $mensaje)) {
                $intencion = 'locales_libres';
            } elseif (preg_match('/(cupon|descuento|promo)/i', $mensaje)) {
                $intencion = 'cupones';
            } else {
                $intencion = 'buscar_tienda';
            }
        }

        // 3. Resolver intención con datos reales de PostgreSQL
        switch ($intencion) {
            case 'saludo':
                return ['respuesta' => $respuestaSugerida ?? '¡Hola! Qué gusto saludarte. Soy el asistente virtual del Mall Center Caparazón. ¿Buscas alguna tienda, horarios o información de locales?'];

            case 'horario':
                return ['respuesta' => $respuestaSugerida ?? 'Abrimos todos los días de lunes a domingo, de 10:00 a.m. a 09:00 p.m. ¡Te esperamos!'];

            case 'ubicacion':
                return ['respuesta' => $respuestaSugerida ?? 'Nos encontramos en la Zona La Vita, muy cerca al Puente Vita, en La Paz - Bolivia.'];

            case 'locales_libres':
                $libres = Espacio::where('estado', 'Disponible')->count();
                if ($libres > 0) {
                    return ['respuesta' => "¡Qué bueno que quieras sumarte a Caparazón! Actualmente tenemos $libres espacios disponibles para alquiler. Puedes consultarlos en administración o en el Directorio."];
                }
                return ['respuesta' => 'Por el momento todos nuestros espacios comerciales están ocupados, pero puedes dejar tus datos en administración para lista de espera.'];

            case 'buscar_tienda':
                $palabras = $entidades['palabras_clave'] ?? [];
                if (empty($palabras)) {
                    $limpio = str_replace(['burguer', 'sapatillas', 'farmasia'], ['burger', 'zapatillas', 'farmacia'], $mensaje);
                    $palabras = array_filter(explode(' ', preg_replace('/[^a-z0-9\s]/', '', $limpio)), fn($p) => strlen($p) > 3);
                }

                $locatario = null;
                foreach ($palabras as $palabra) {
                    $locatario = Locatario::where('nombre', 'ILIKE', "%{$palabra}%")
                        ->orWhere('rubro', 'ILIKE', "%{$palabra}%")
                        ->first();
                    if ($locatario) break;
                }

                // Búsqueda aproximada por similitud si hubo otro error ortográfico
                if (!$locatario && !empty($palabras)) {
                    $termino = implode(' ', $palabras);
                    $todos = Locatario::all();
                    $mejorPorcentaje = 0;
                    foreach ($todos as $item) {
                        similar_text($termino, mb_strtolower($item->nombre), $pctNombre);
                        similar_text($termino, mb_strtolower($item->rubro ?? ''), $pctRubro);
                        $maxPct = max($pctNombre, $pctRubro);
                        if ($maxPct > $mejorPorcentaje && $maxPct >= 55) {
                            $mejorPorcentaje = $maxPct;
                            $locatario = $item;
                        }
                    }
                }

                if ($locatario) {
                    $tel = $locatario->telefono ? " Su teléfono de contacto es {$locatario->telefono}." : "";
                    return ['respuesta' => "¡Claro! Contamos con '{$locatario->nombre}' en el rubro de {$locatario->rubro}.{$tel} Puedes hacer clic en su tarjeta en el Directorio de esta página para ver todos sus detalles."];
                }

                return ['respuesta' => $respuestaSugerida ?? 'No encontré una tienda exacta con ese nombre, pero puedes revisar todas nuestras tiendas abiertas en el Directorio de esta página o preguntarme por rubros como comida, ropa, farmacia o tecnología.'];

            case 'estado_incidencia':
                if (auth('api')->check()) {
                    $inc = Incidencia::where('reportado_por', auth('api')->id())->latest()->first();
                    if ($inc) {
                        return ['respuesta' => "Tu incidencia más reciente es '{$inc->titulo}' y actualmente se encuentra en estado: {$inc->estado}."];
                    }
                }
                return ['respuesta' => $respuestaSugerida ?? 'Para revisar el estado de tus incidencias necesito que inicies sesión primero con tu cuenta de Locatario.'];

            case 'cupones':
                return ['respuesta' => $respuestaSugerida ?? '¡Tenemos excelentes beneficios y descuentos para nuestros visitantes! Puedes consultar tus cupones activos en la sección de Fidelización.'];

            default:
                return ['respuesta' => $respuestaSugerida ?? 'Disculpa, no estoy seguro de haber entendido del todo. Puedo ayudarte con horarios, ubicación del mall, locales disponibles o buscar alguna tienda.'];
        }
    }
}