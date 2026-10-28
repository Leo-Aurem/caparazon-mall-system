<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ContratoController;
use App\Http\Controllers\Api\EspacioController;
use App\Http\Controllers\Api\IncidenciaController;
use App\Http\Controllers\Api\LocatarioController;
use App\Http\Controllers\Api\FidelizacionController;
use App\Http\Controllers\Api\ReporteController;
use Illuminate\Support\Facades\Route;

Route::post('/login', [AuthController::class, 'login']);
Route::post('/chat', [App\Http\Controllers\Api\ChatController::class, 'chat']);
Route::get('/directorio', [LocatarioController::class, 'index']); // Público

Route::middleware('auth:api')->group(function () {
    Route::get('/me', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::post('/refresh', [AuthController::class, 'refresh']);
    Route::get('/notificaciones', [App\Http\Controllers\Api\NotificacionController::class, 'index']);
    Route::post('/notificaciones/leer', [App\Http\Controllers\Api\NotificacionController::class, 'leer']);

    // Dashboard: admin, supervisor, operador, seguridad
    Route::middleware('role:Administrador,Supervisor,Operador,Seguridad')->get('/dashboard-kpis', function () {
        return response()->json(['ok' => true]);
    });

    // Locatarios y Contratos: admin, operador
    Route::middleware('role:Administrador,Operador')->group(function () {
        Route::apiResource('locatarios', LocatarioController::class);
        Route::apiResource('contratos', ContratoController::class);
        Route::get('contratos-por-vencer', [ContratoController::class, 'porVencer']);
    });

    // Espacios: admin, supervisor (operador solo lectura)
    Route::get('espacios', [EspacioController::class, 'index']);
    Route::get('espacios/{espacio}', [EspacioController::class, 'show']);
    Route::middleware('role:Administrador,Supervisor')->group(function () {
        Route::post('espacios', [EspacioController::class, 'store']);
        Route::put('espacios/{espacio}', [EspacioController::class, 'update']);
        Route::delete('espacios/{espacio}', [EspacioController::class, 'destroy']);
    });

    // Incidencias: supervisor, seguridad, admin; locatario crea y ve las suyas
    Route::get('incidencias', [IncidenciaController::class, 'index']);
    Route::get('incidencias/{incidencia}', [IncidenciaController::class, 'show']);
    Route::post('incidencias', [IncidenciaController::class, 'store']);
    Route::middleware('role:Administrador,Supervisor,Seguridad')->group(function () {
        Route::patch('incidencias/{incidencia}/estado', [IncidenciaController::class, 'cambiarEstado']);
        Route::put('incidencias/{incidencia}', [IncidenciaController::class, 'update']);
        Route::delete('incidencias/{incidencia}', [IncidenciaController::class, 'destroy']);
    });

        // Fidelización
    Route::middleware('role:Administrador,Operador')->group(function () {
        Route::get('/fidelizacion/resumen', [FidelizacionController::class, 'resumen']);
        Route::post('/fidelizacion/recalcular', [FidelizacionController::class, 'recalcular']);
        Route::get('/fidelizacion/visitantes', [FidelizacionController::class, 'listaVisitantes']);
        Route::post('/fidelizacion/campanas', [FidelizacionController::class, 'crearCampana']);
        Route::post('/fidelizacion/campanas/{campana}/generar-cupones', [FidelizacionController::class, 'generarCupones']);
        Route::post('/fidelizacion/cupones/canjear', [FidelizacionController::class, 'canjearCupon']);
    });

    // Reportes y Administración: solo admin
    Route::middleware('role:Administrador')->group(function () {
        Route::get('/reportes/locatarios/pdf', [ReporteController::class, 'pdfLocatarios']);
        Route::get('/reportes/locatarios/excel', [ReporteController::class, 'excelLocatarios']);
        Route::get('/reportes/incidencias/pdf', [ReporteController::class, 'pdfIncidencias']);
    });
});