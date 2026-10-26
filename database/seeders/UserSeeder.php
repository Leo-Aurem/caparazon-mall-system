<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        $roles = ['Administrador','Supervisor','Operador','Seguridad','Locatario'];
        foreach ($roles as $rol) {
            User::updateOrCreate(
                ['email' => strtolower($rol).'@caparazon.bo'],
                [
                    'name' => $rol,
                    'password' => Hash::make('Caparazon2026!'),
                    'role' => $rol,
                    'activo' => true,
                ]
            );
        }
    }
}