<?php

namespace App\Observers;

use App\Models\Auditoria;
use Illuminate\Database\Eloquent\Model;

class AuditoriaObserver
{
    public function created(Model $model) { $this->registrar($model, 'crear', null, $model->getAttributes()); }
    public function updated(Model $model) { $this->registrar($model, 'actualizar', $model->getOriginal(), $model->getChanges()); }
    public function deleted(Model $model) { $this->registrar($model, 'eliminar', $model->getOriginal(), null); }

    private function registrar(Model $model, string $accion, ?array $antes, ?array $despues): void
    {
        Auditoria::create([
            'usuario_id' => auth('api')->id(),
            'tabla' => $model->getTable(),
            'registro_id' => $model->getKey(),
            'accion' => $accion,
            'datos_antes' => $antes,
            'datos_despues' => $despues,
            'ip' => request()->ip(),
        ]);
    }
}