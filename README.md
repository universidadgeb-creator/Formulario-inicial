# Encuesta de bienvenida — Vivo 47 Center

Encuesta interactiva para nuevos socios de Vivo 47 Center. Es un sitio estático (un solo `index.html`, sin build) publicado con GitHub Pages: https://universidadgeb-creator.github.io/Formulario-inicial/

## Qué incluye

- Encuesta paso a paso (12 preguntas) con borrador guardado en el navegador.
- Plano de Center clicable y selección múltiple de capacidades.
- Pantalla final con el equipo del bloque elegido, recomendaciones, botón para enviar el resumen al WhatsApp de Center y botón para agregar la primera sesión al calendario.
- Panel **Admin** (enlace en la esquina, o `/#admin`) con contraseña: resumen de resultados, tabla, búsqueda, exportar CSV y borrado de registros.

## Conectar Supabase (una sola vez)

1. En [supabase.com](https://supabase.com) crea un proyecto.
2. **SQL Editor → New query**, pega todo `supabase/schema.sql` y presiona **Run**. Crea la tabla `respuestas`, la seguridad y las funciones del panel Admin.
3. En otra consulta, pon tu contraseña de administración (cámbiala por la tuya) y presiona **Run**:

   ```sql
   insert into public.admin_config (id, password_hash)
   values (1, extensions.crypt('TU_CONTRASEÑA_AQUÍ', extensions.gen_salt('bf')))
   on conflict (id) do update set password_hash = excluded.password_hash;
   ```

   La contraseña se guarda cifrada; nunca queda en el código. Para cambiarla, vuelve a correr la consulta.
4. **Project Settings → API**: copia la **Project URL** y la **anon public key** y pégalas en `index.html`:

   ```js
   const SUPABASE_URL = "https://xxxx.supabase.co";
   const SUPABASE_ANON_KEY = "eyJ...";
   ```

   La anon key es pública por diseño. Nunca pongas la `service_role` key en el sitio.
5. Sube el cambio a `main`; GitHub Pages se actualiza en uno o dos minutos.

Sin esas dos líneas el sitio sigue funcionando en modo de prueba: las respuestas se guardan solo en el navegador de quien contesta.

## Cómo está protegido

- Quien llena la encuesta solo puede **agregar** una respuesta. No puede leer, editar ni borrar nada (RLS activado, sin permisos de lectura).
- El panel Admin usa funciones del servidor (`admin_list`, `admin_delete`, `admin_delete_all`) que validan la contraseña en cada llamada. Un intento fallido tarda un segundo en responder para frenar adivinanzas.
- La contraseña de la sesión se guarda en `sessionStorage` y se borra al cerrar la pestaña o al dar "Cerrar sesión".
- Los datos son personales (nombre, teléfono, hábitos de salud). Conviene avisar a los socios para qué se usan, y limpiar los registros de prueba antes de abrir al público (Admin → "Borrar todo").

## Equipo y plano

- `TEAM` (en el `<script>`): coaches, fotos (`img/equipo/`) y horarios. Cada socio ve a quien se traslapa 2 horas o más con el bloque que elige; `blocks:[...]` fija bloques sin horario y `vacant:true` oculta una vacante.
- `BLOQUES`: ventanas de los bloques (matutino 5–12, vespertino 12–22).
- `floorplanSVG()`: plano esquemático de Center.
- `CENTER_WHATSAPP`: número de Center (código de país + 10 dígitos).
