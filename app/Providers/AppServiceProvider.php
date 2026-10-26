<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        \App\Models\Locatario::observe(\App\Observers\AuditoriaObserver::class);
        \App\Models\Espacio::observe(\App\Observers\AuditoriaObserver::class);
        \App\Models\Contrato::observe(\App\Observers\AuditoriaObserver::class);
        \App\Models\Incidencia::observe(\App\Observers\AuditoriaObserver::class);
    }
}
