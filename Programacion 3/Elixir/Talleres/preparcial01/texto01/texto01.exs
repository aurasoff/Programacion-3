defmodule Texto do
  def main do
    texto  =
    "Ingrese el texto del reporte: "
    |> Util.ingresar(:texto)
    |> String.downcase()
    |> String.trim()
    |> String.replace(["contraseña", "pasword"], "[CENSURADO]")
    |> convertir_si_urgente_brecha()

    texto
    |> verificar_longitud()
    |> mostrar_mensaje()
  end
  defp verificar_longitud(texto)  do
    long= String.length(texto)
    palabras = String.split(texto) |> length()
    caracteres = String.graphemes(texto) |>length()
    if long < 20 do
      {:error, "EL reporte no cumple con la longitud minima requerida"}
    else
      {:ok,texto, palabras, caracteres}
    end
  end

  defp convertir_si_urgente_brecha(texto) do
    if String.contains?(texto, ["urgente", "brocha"]), do: String.upcase(texto),
   else: texto
  end

  defp mostrar_mensaje({:ok, texto, palabras, caracteres}= tupla) do
    mensaje = """
    Reporte valido :
    -texto : #{texto}, palabras #{palabras}, #{caracteres}
    """
    Util.mostrar_mensaje(mensaje)
   tupla
   end
   defp mostrar_mensaje({:error, mensaje}= tupla) do
    Util.mostrar_error(mensaje)
    tupla
   end
end
Texto.main()
