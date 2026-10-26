<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
{
    Schema::create('espacios', function (Blueprint $table) {
        $table->id();
        $table->string('codigo')->unique();
        $table->string('piso');
        $table->string('zona')->nullable();
        $table->decimal('area_m2', 8, 2)->nullable();
        $table->decimal('coord_x', 10, 2)->nullable();
        $table->decimal('coord_y', 10, 2)->nullable();
        $table->enum('estado', ['Disponible','Ocupado','Mantenimiento'])->default('Disponible');
        $table->foreignId('locatario_id')->nullable()->constrained('locatarios')->nullOnDelete();
        $table->timestamps();
    });
}

public function down(): void
{
    Schema::dropIfExists('espacios');
}
};
