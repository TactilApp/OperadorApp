
![](https://github.com/patoroco/OperadorApp/raw/master/Recursos/00%20-%20icono%20y%20default/Icon%402x.png) OperadorApp
======================
OperadorApp sirve para descubrir de qué compañía es un número de teléfono móvil (de momento únicamente en España).

Se puede descargar gratuítamente desde la AppStore: [OperadorApp](https://itunes.apple.com/es/app/operadorapp/id431750600?mt=8).

Instalación
===========
La aplicación incluye diferentes submodulos, por lo que en primer lugar hay que inicializarlos y descargar su código fuente.

Clonado
-------
	git clone git@github.com:TactilApp/OperadorApp.git

Para inicializar todos los módulos
----------------------------------
	git submodule init
	git submodule update

Copiar configuraciones
----------------------
	mv configuracion-ejemplo configuracion

Sería conveniente editar los dos ficheros que contiene el directorio que se acaba de renombrar con los parámetros de cada servicio (UrbanAirship, Flurry, …).