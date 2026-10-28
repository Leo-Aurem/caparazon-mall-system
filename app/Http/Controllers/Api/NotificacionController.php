<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Notificacion;
use Illuminate\Http\Request;

class NotificacionController extends Controller
{
    public function index()
    {
        return Notificacion::where('user_id', auth('api')->id())
            ->orderBy('created_at', 'desc')
            ->take(10)
            ->get();
    }

    public function leer(Request $r)
    {
        $r->validate(['id' => 'required|exists:notificaciones,id']);
        $noti = Notificacion::where('id', $r->id)->where('user_id', auth('api')->id())->first();
        if ($noti) {
            $noti->update(['leida' => true]);
        }
        return response()->json(['ok' => true]);
    }
}