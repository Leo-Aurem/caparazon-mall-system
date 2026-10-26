<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
{
    Schema::create('contratos', function (Blueprint $table) {
        $table->id();
        $table->foreignId('locatario_id')->constrained('locatarios')->cascadeOnDelete();
        $table->foreignId('espacio_id')->constrained('espacios')->cascadeOnDelete();
        $table->string('codigo')->unique();
        $table->date('fecha_inicio');
        $table->date('fecha_fin');
        $table->decimal('monto_mensual', 12, 2);
        $table->enum('estado', ['Vigente','Por vencer','Vencido','Rescindido'])->default('Vigente');
        $table->text('observaciones')->nullable();
        $table->timestamps();
    });
}

public function down(): void
{
    Schema::dropIfExists('contratos');
}
};
