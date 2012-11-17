OperadorApp
===========
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

Editar los dos ficheros que contiene este directorio con los parámetros que se deseen.