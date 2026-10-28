<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::create('visitantes', function (Blueprint $table) {
            $table->id();
            $table->string('nombre');
            $table->string('email')->unique();
            $table->string('telefono')->nullable();
            $table->date('fecha_registro');
            $table->string('segmento')->default('ocasional'); // nuevo, frecuente, vip, en_riesgo, ocasional
            $table->integer('puntos')->default(0);
            $table->timestamp('ultima_visita')->nullable();
            $table->timestamps();
        });
    }
    public function down(): void { Schema::dropIfExists('visitantes'); }
};