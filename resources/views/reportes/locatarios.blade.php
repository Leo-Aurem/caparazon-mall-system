<!DOCTYPE html>
<html>
<head>
    <title>Reporte de Locatarios</title>
    <style>
        body { font-family: sans-serif; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background-color: #f4f4f4; }
    </style>
</head>
<body>
    <h2>Mall Center Caparazón - Reporte de Locatarios</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>NIT</th>
                <th>Rubro</th>
                <th>Estado</th>
            </tr>
        </thead>
        <tbody>
            @foreach($locatarios as $loc)
            <tr>
                <td>{{ $loc->id }}</td>
                <td>{{ $loc->nombre }}</td>
                <td>{{ $loc->nit }}</td>
                <td>{{ $loc->rubro }}</td>
                <td>{{ $loc->estado }}</td>
            </tr>
            @endforeach
        </tbody>
    </table>
</body>
</html>
