<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
   public function up(): void
{
    Schema::create('incidencias', function (Blueprint $table) {
        $table->id();
        $table->string('titulo');
        $table->text('descripcion');
        $table->foreignId('espacio_id')->nullable()->constrained('espacios')->nullOnDelete();
        $table->foreignId('reportado_por')->nullable()->constrained('users')->nullOnDelete();
        $table->foreignId('asignado_a')->nullable()->constrained('users')->nullOnDelete();
        $table->enum('prioridad', ['Baja','Media','Alta','Critica'])->default('Media');
        $table->enum('estado', ['Pendiente','Asignada','En proceso','Resuelta','Cerrada'])->default('Pendiente');
        $table->timestamp('fecha_cierre')->nullable();
        $table->timestamps();
    });
}

public function down(): void
{
    Schema::dropIfExists('incidencias');
}
};
