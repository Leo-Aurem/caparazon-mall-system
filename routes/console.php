<?php

use Illuminate\Support\Facades\Schedule;

Schedule::command('alertas:vencimiento')->dailyAt('06:00');