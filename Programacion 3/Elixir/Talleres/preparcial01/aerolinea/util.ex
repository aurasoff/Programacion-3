defmodule Util do
 def mostrar_mensaje(mensaje) do
    IO.puts(mensaje)
  end
  def ingresar(mensaje, :texto) do
    mensaje
    |> IO.gets()
    |> String.trim()
  end
  def ingresar(mensaje, :entero) do
  mensaje
  |> Util.ingresar(:texto)
  |> String.to_integer()
  rescue
    ArgumentError ->
      "Error, se espera que ingrese un número entero\n"
      |> mostrar_error()

      mensaje
      |> ingresar(:entero)
    end
    def mostrar_error (mensaje) do
      IO.puts(:standard_error, mensaje)
  end

end
