# Instalador Universal de Controladores Nvidia (NUDI)

## Descripción

NUDI (Instalador Universal de Controladores Nvidia) es un script Bash versátil diseñado para simplificar la instalación de controladores Nvidia en varias distribuciones de Linux. Admite Ubuntu, Debian, Fedora, Arch Linux, openSUSE y sus derivados. Esta herramienta es especialmente útil para usuarios que buscan una manera fácil y automatizada de instalar controladores Nvidia sin tener que navegar a través de las complejidades del manejo de paquetes y los métodos de instalación de controladores en cada distribución.

## Estado: ALPHA

Tenga en cuenta que NUDI está actualmente en fase ALPHA, lo que significa que está bajo desarrollo activo y podría estar sujeto a cambios significativos. Aunque nos esforzamos por asegurar la estabilidad y amplia compatibilidad, utilice este script con precaución y bajo su propio riesgo.

## Descargo de responsabilidad

Este script se proporciona sin ninguna garantía o garantía de funcionalidad. Es importante hacer una copia de seguridad de su sistema y datos antes de proceder con la instalación, especialmente porque la instalación de controladores puede impactar significativamente en la estabilidad y el rendimiento del sistema.

## Nota de Compatibilidad

NUDI está destinado para su uso con tarjetas gráficas Nvidia que sean compatibles con los **últimos controladores Nvidia**. Si su tarjeta Nvidia no es compatible con los últimos controladores, este script podría no funcionar para su configuración. Siempre verifique el modelo de su tarjeta gráfica y la compatibilidad del controlador Nvidia antes de usar este script.

## Distribuciones compatibles

- Ubuntu
- Debian
- Fedora
- Arch Linux
- openSUSE Leap
- openSUSE Tumbleweed

## Instalación

Para usar NUDI, siga estos pasos:


   ```bash
   git clone https://github.com/Cardiacman13/NUDI.git
   cd NUDI
   chmod +x ./nvidiainstaller.sh
   sudo ./nvidiainstaller.sh
   ```


## Uso

Una vez que inicie el script, le guiará a través del proceso.

## Contribuciones

¡Las contribuciones a NUDI son bienvenidas! Si tiene sugerencias, informes de errores o contribuciones, por favor abra un problema o una solicitud de extracción en el repositorio.
