<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
{
    Schema::create('auditoria', function (Blueprint $table) {
        $table->id();
        $table->foreignId('usuario_id')->nullable()->constrained('users')->nullOnDelete();
        $table->string('tabla');
        $table->unsignedBigInteger('registro_id')->nullable();
        $table->enum('accion', ['crear','actualizar','eliminar']);
        $table->json('datos_antes')->nullable();
        $table->json('datos_despues')->nullable();
        $table->string('ip', 45)->nullable();
        $table->timestamps();
        $table->index(['tabla','registro_id']);
    });
}

public function down(): void
{
    Schema::dropIfExists('auditoria');
}
};
