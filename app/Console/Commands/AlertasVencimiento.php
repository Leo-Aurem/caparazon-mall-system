<?php

namespace App\Console\Commands;

use App\Models\Contrato;
use App\Models\Notificacion;
use App\Models\User;
use Illuminate\Console\Command;

class AlertasVencimiento extends Command
{
    protected $signature = 'alertas:vencimiento';
    protected $description = 'Marca contratos por vencer y vencidos y genera notificaciones';

    public function handle(): int
    {
        $hoy = now();
        $limite = now()->addDays(30);
        $usuariosAvisar = User::whereIn('role', ['Administrador', 'Operador'])->get();

        $porVencer = Contrato::where('estado', 'Vigente')
            ->whereBetween('fecha_fin', [$hoy, $limite])
            ->get();

        foreach ($porVencer as $c) {
            $c->estado = 'Por vencer';
            $c->save();
            $this->info("Contrato {$c->codigo} marcado Por vencer");

            foreach ($usuariosAvisar as $u) {
                Notificacion::firstOrCreate(
                    ['clave' => "vencimiento_{$c->id}_{$u->id}"],
                    [
                        'user_id' => $u->id,
                        'texto' => "El contrato {$c->codigo} vence pronto ({$c->fecha_fin->toDateString()})",
                        'ruta' => '/contratos'
                    ]
                );
            }
        }

        $vencidos = Contrato::whereIn('estado', ['Vigente','Por vencer'])
            ->where('fecha_fin', '<', $hoy)
            ->get();

        foreach ($vencidos as $c) {
            $c->estado = 'Vencido';
            $c->save();
            $this->info("Contrato {$c->codigo} marcado Vencido");

            foreach ($usuariosAvisar as $u) {
                Notificacion::firstOrCreate(
                    ['clave' => "vencido_{$c->id}_{$u->id}"],
                    [
                        'user_id' => $u->id,
                        'texto' => "El contrato {$c->codigo} ha VENCIDO ({$c->fecha_fin->toDateString()})",
                        'ruta' => '/contratos'
                    ]
                );
            }
        }

        $this->info("Procesados: {$porVencer->count()} por vencer, {$vencidos->count()} vencidos.");
        return self::SUCCESS;
    }
}