# Encuesta de bienvenida — Vivo 47 Center

Encuesta pública para nuevos socios. Es un sitio estático (un solo `index.html`, sin build) que guarda cada respuesta en Firestore (`respuestas`). **Los resultados se consultan en el dashboard de retención**, no aquí.

> Esta rama (`unificacion-dashboard`) es la versión integrada con el dashboard. Se basa en `public/bienvenida/` de la entrega de Ceci y **no está publicada**: GitHub Pages sigue sirviendo `main`.

## Qué cambia respecto a `main`

- Se retiró el panel Admin con contraseña. El equipo entra al dashboard con sus usuarios individuales; `DASHBOARD_URL` (en `index.html`) pone el enlace "Acceso del equipo" cuando el dashboard esté desplegado.
- Nuevo paso de **aviso de privacidad** con casilla de consentimiento. Se guarda `consentimiento`, `avisoVersion` y `consentimientoEn` junto a cada respuesta.
- Soporte opcional de App Check (`WELCOME_APP_CHECK`), apagado hasta registrar la app.
- `firebase/firestore.rules` es el de la entrega: acepta los campos de consentimiento, mantiene el esquema anterior y cierra `vivo47Dashboard` y `vivo47Config`.

## Aviso de privacidad (pendiente de GEB)

El paso enlaza https://center.vivo47.com/aviso-de-privacidad (actualización del 17 de septiembre de 2026). Ese aviso dice que su formulario **no recaba datos de salud**, y esta encuesta pregunta condición física, lesiones o molestias y motivos de abandono. Mientras GEB no confirme que el aviso cubre la encuesta (o publique uno específico), `PRIVACY_NOTICE.approved` queda en `false` y el sitio **no guarda en Firebase**: solo admite ensayos locales. Para habilitarlo, cambiar a `approved:true` y, si el aviso cambia, actualizar `version`.

## Firebase

Proyecto `center-2026`, base `(default)`, colección `respuestas`.

1. Combinar `firebase/firestore.rules` con las reglas vigentes del proyecto y publicarlas. No publicar un archivo incompleto sobre otras aplicaciones.
2. La lectura heredada de `respuestas` exige un correo verificado y el documento `vivo47Config/respuestasAccess` (`{"enabled":true,"email":"..."}`) creado con Admin SDK o Console. Sin él, solo el servidor del dashboard (permisos de servicio) lee las respuestas.
3. Confirmar en Authentication que el registro libre está deshabilitado.
4. Revisar la restricción de la `apiKey` por dominio y, cuando se registre la app, activar App Check primero en modo de monitoreo.

El dashboard, su despliegue (Hosting + Functions + Authentication + Firestore, plan Blaze) y la vinculación de respuestas con socios por teléfono están documentados en la entrega (`INTEGRACION_CECI.md` y `ACCESO_INSTITUCIONAL.md`).

## Dirección de la encuesta

La encuesta no se enlaza desde el sitio público de Center: se comparte directo con los socios (WhatsApp, correo o QR) en un subdominio propio. Para que no aparezca en buscadores, `index.html` lleva `noindex, nofollow` y el repo incluye `robots.txt`. Es una petición a los buscadores, no un control de acceso: quien tenga el enlace entra, porque el socio responde sin cuenta.

## Equipo y plano

- `TEAM`: coaches, fotos (`img/equipo/`) y turnos. Cada socio ve a quien trabaja 2 horas o más dentro del bloque que elige.
- `BLOQUES`: matutino 5–12, vespertino 12–22.
- `floorplanSVG()`: plano esquemático de Center.
- `CENTER_WHATSAPP`: número de Center (código de país + 10 dígitos).
