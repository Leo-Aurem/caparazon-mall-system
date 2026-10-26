<?php

namespace App\Console\Commands;

use App\Models\Contrato;
use Illuminate\Console\Command;

class AlertasVencimiento extends Command
{
    protected $signature = 'alertas:vencimiento';
    protected $description = 'Marca contratos por vencer y vencidos';

    public function handle(): int
    {
        $hoy = now();
        $limite = now()->addDays(30);

        $porVencer = Contrato::where('estado', 'Vigente')
            ->whereBetween('fecha_fin', [$hoy, $limite])
            ->get();

        foreach ($porVencer as $c) {
            $c->estado = 'Por vencer';
            $c->save();
            $this->info("Contrato {$c->codigo} marcado Por vencer (vence {$c->fecha_fin->toDateString()})");
        }

        $vencidos = Contrato::whereIn('estado', ['Vigente','Por vencer'])
            ->where('fecha_fin', '<', $hoy)
            ->get();

        foreach ($vencidos as $c) {
            $c->estado = 'Vencido';
            $c->save();
            $this->info("Contrato {$c->codigo} marcado Vencido");
        }

        $this->info("Procesados: {$porVencer->count()} por vencer, {$vencidos->count()} vencidos.");
        return self::SUCCESS;
    }
}