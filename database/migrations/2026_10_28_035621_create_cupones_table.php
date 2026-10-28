<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::create('cupones', function (Blueprint $table) {
            $table->id();
            $table->foreignId('campana_id')->constrained('campanas')->cascadeOnDelete();
            $table->string('codigo')->unique();
            $table->foreignId('visitante_id')->constrained('visitantes')->cascadeOnDelete();
            $table->foreignId('locatario_id')->nullable()->constrained('locatarios')->nullOnDelete();
            $table->decimal('descuento_porcentaje', 5, 2);
            $table->enum('estado', ['activo', 'canjeado', 'vencido'])->default('activo');
            $table->date('fecha_emision');
            $table->date('fecha_vencimiento');
            $table->timestamp('fecha_canje')->nullable();
            $table->timestamps();
        });
    }
    public function down(): void { Schema::dropIfExists('cupones'); }
};