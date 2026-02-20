defmodule EntradaDatos do
  def main do
    "Ingrese nombre del empleado: "
    |> Util.ingresar_texto()
    |> generar_mensaje()
    |> Util.mostrar_mensaje()
  end

  def generar_mensaje(frase) do
    "El nombre del empleado es :  #{frase}"
   end
  end
  EntradaDatos.main()
