# Encuesta de bienvenida — Vivo 47 Center

Encuesta interactiva para nuevos socios de Vivo 47 Center. Es un sitio estático (un solo `index.html`, sin build ni librerías) publicado con GitHub Pages: https://universidadgeb-creator.github.io/Formulario-inicial/

## Qué incluye

- Encuesta paso a paso (12 preguntas) con borrador guardado en el navegador.
- Plano de Center clicable y selección múltiple de capacidades.
- Pantalla final con el equipo del bloque elegido, recomendaciones, botón para enviar el resumen al WhatsApp de Center y botón para agregar la primera sesión al calendario.
- Panel **Admin** (enlace en la esquina, o `/#admin`) con contraseña: resumen de resultados, tabla, búsqueda, exportar CSV y borrado de registros.

## Conectar Firebase (una sola vez)

1. En [console.firebase.google.com](https://console.firebase.google.com) crea un proyecto (Analytics no hace falta).
2. **Authentication → Comenzar → Correo electrónico/contraseña → Habilitar.** Luego **Usuarios → Agregar usuario**: pon un correo y la contraseña de administración. Ese correo y esa contraseña son los del panel Admin (en el panel solo se escribe la contraseña).
3. **Firestore Database → Crear base de datos** (modo producción; elige la región más cercana).
4. **Firestore → Reglas**: pega `firebase/firestore.rules`, cambia `admin@CAMBIA.com` por el correo del paso 2 y presiona **Publicar**.
5. **Configuración del proyecto (engrane) → Tus apps → `</>` Web**: registra una app y copia `apiKey` y `projectId`.
6. En `index.html` completa:

   ```js
   const FIREBASE_API_KEY = "AIza...";
   const FIREBASE_PROJECT_ID = "mi-proyecto";
   const ADMIN_EMAIL = "el-correo-del-paso-2";
   ```

   La `apiKey` de Firebase es pública por diseño; lo que protege los datos son las reglas del paso 4.
7. Sube el cambio a `main`; GitHub Pages se actualiza en uno o dos minutos.

Sin esas tres líneas el sitio sigue funcionando en modo de prueba: las respuestas se guardan solo en el navegador de quien contesta.

## Cómo está protegido

- Quien llena la encuesta solo puede **agregar** una respuesta con la forma esperada (campos y largos validados por las reglas). No puede leerla, editarla ni borrarla.
- Solo el usuario administrador de Firebase Auth puede leer y borrar. Firebase limita por sí mismo los intentos fallidos de contraseña.
- La contraseña de la sesión se guarda en `sessionStorage` y se borra al cerrar la pestaña o al dar "Cerrar sesión".
- Si quieres restringir la `apiKey`, en Google Cloud Console → Credenciales puedes limitarla al dominio `universidadgeb-creator.github.io`.
- Los datos son personales (nombre, teléfono, hábitos de salud). Conviene avisar a los socios para qué se usan, y limpiar los registros de prueba antes de abrir al público (Admin → "Borrar todo").

## Equipo y plano

- `TEAM` (en el `<script>`): coaches, fotos (`img/equipo/`) y turnos. Cada socio ve a quien trabaja 2 horas o más dentro del bloque que elige; `vacant:true` oculta una vacante.
- `BLOQUES`: ventanas de los bloques (matutino 5–12, vespertino 12–22).
- `floorplanSVG()`: plano esquemático de Center.
- `CENTER_WHATSAPP`: número de Center (código de país + 10 dígitos).
