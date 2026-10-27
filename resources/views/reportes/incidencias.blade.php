<!DOCTYPE html>
<html>
<head>
    <title>Reporte de Incidencias</title>
    <style>
        body { font-family: sans-serif; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background-color: #f4f4f4; }
    </style>
</head>
<body>
    <h2>Mall Center Caparazón - Reporte de Incidencias</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Título</th>
                <th>Espacio</th>
                <th>Prioridad</th>
                <th>Estado</th>
            </tr>
        </thead>
        <tbody>
            @foreach($incidencias as $inc)
            <tr>
                <td>{{ $inc->id }}</td>
                <td>{{ $inc->titulo }}</td>
                <td>{{ $inc->espacio ? $inc->espacio->codigo : 'N/A' }}</td>
                <td>{{ $inc->prioridad }}</td>
                <td>{{ $inc->estado }}</td>
            </tr>
            @endforeach
        </tbody>
    </table>
</body>
</html>
