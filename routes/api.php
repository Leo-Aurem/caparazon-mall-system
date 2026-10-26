<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ContratoController;
use App\Http\Controllers\Api\EspacioController;
use App\Http\Controllers\Api\IncidenciaController;
use App\Http\Controllers\Api\LocatarioController;
use Illuminate\Support\Facades\Route;

Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:api')->group(function () {
    Route::get('/me', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::post('/refresh', [AuthController::class, 'refresh']);

    // Locatarios: Admin, Supervisor
    Route::middleware('role:Administrador,Supervisor')->group(function () {
        Route::apiResource('locatarios', LocatarioController::class);
        Route::apiResource('contratos', ContratoController::class);
        Route::get('contratos-por-vencer', [ContratoController::class, 'porVencer']);
    });

    // Espacios: todos los roles autenticados pueden ver; solo Admin/Supervisor modifican
    Route::get('espacios', [EspacioController::class, 'index']);
    Route::get('espacios/{espacio}', [EspacioController::class, 'show']);
    Route::middleware('role:Administrador,Supervisor')->group(function () {
        Route::post('espacios', [EspacioController::class, 'store']);
        Route::put('espacios/{espacio}', [EspacioController::class, 'update']);
        Route::delete('espacios/{espacio}', [EspacioController::class, 'destroy']);
    });

    // Incidencias: todos reportan; Admin/Supervisor/Operador gestionan
    Route::apiResource('incidencias', IncidenciaController::class)->except(['destroy']);
    Route::patch('incidencias/{incidencia}/estado', [IncidenciaController::class, 'cambiarEstado']);
    Route::delete('incidencias/{incidencia}', [IncidenciaController::class, 'destroy'])
        ->middleware('role:Administrador');
});