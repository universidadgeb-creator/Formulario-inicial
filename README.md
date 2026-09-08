# Formulario inicial — Vivo 47 Center

Ficha de bienvenida interactiva para nuevos socios de Vivo 47 Center. Es un sitio estático (un solo `index.html`, sin dependencias de build) con la identidad visual de [center.vivo47.com](https://center.vivo47.com).

## Ver el sitio localmente

Abre `index.html` directamente en el navegador, o sirve la carpeta con cualquier servidor estático:

```bash
npx serve .
```

## Publicar con GitHub Pages

1. Settings → Pages → Deploy from a branch.
2. Elige la rama `main` y la carpeta `/ (root)`.
3. Guarda — el sitio queda publicado en `https://universidadgeb-creator.github.io/Formulario-inicial/`.

## Qué incluye

- Formulario paso a paso (12 preguntas) con guardado de borrador en `localStorage`.
- Mapa corporal (frente y espalda) y plano de Center, ambos clicables y de selección múltiple.
- Pantalla final con recomendaciones automáticas, botón para enviar los resultados por WhatsApp y botón para agregar la primera sesión a Google Calendar.
- Panel `/#coaches` (enlace "Admin" en la esquina) para revisar respuestas.

## Estado de la base de datos

**Todavía no hay backend conectado.** Las respuestas se guardan únicamente en el `localStorage` del navegador de quien contesta (ver `saveResponse()` en `index.html`), además de lo que la persona decida enviar por WhatsApp o agregar a su calendario.

Para conectar una base de datos real:

1. Reemplaza el cuerpo de `saveResponse()` por una llamada a tu API (por ejemplo `fetch("/api/responses", { method: "POST", body: JSON.stringify(state) })`).
2. Reemplaza `loadAdminData()` para que lea de esa misma API en lugar de `localStorage`.

## Datos de ejemplo a personalizar

- `TEAM` (dentro del `<script>`): nombres y roles de coaches por turno — son placeholders, reemplázalos por tu staff real.
- El plano de Center en `floorplanSVG()` es una interpretación esquemática del layout — ajusta las coordenadas si tienes las medidas reales.
