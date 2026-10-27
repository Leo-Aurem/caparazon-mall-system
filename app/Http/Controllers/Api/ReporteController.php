<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Locatario;
use App\Models\Incidencia;
use Barryvdh\DomPDF\Facade\Pdf;
use Maatwebsite\Excel\Facades\Excel;
use Illuminate\Http\Request;

class ReporteController extends Controller
{
    public function pdfLocatarios()
    {
        $locatarios = Locatario::all();
        $pdf = Pdf::loadView('reportes.locatarios', compact('locatarios'));
        return $pdf->download('locatarios.pdf');
    }

    public function excelLocatarios()
    {
        // Generación rápida de Excel sin una clase Export dedicada
        $locatarios = Locatario::all();
        $filename = 'locatarios.csv';
        $handle = fopen('php://output', 'w');
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="'.$filename.'"');
        fputcsv($handle, ['ID', 'Nombre', 'NIT', 'Estado']);
        foreach ($locatarios as $loc) {
            fputcsv($handle, [$loc->id, $loc->nombre, $loc->nit, $loc->estado]);
        }
        fclose($handle);
        exit;
    }

    public function pdfIncidencias()
    {
        $incidencias = Incidencia::with('espacio')->get();
        $pdf = Pdf::loadView('reportes.incidencias', compact('incidencias'));
        return $pdf->download('incidencias.pdf');
    }
}
