defmodule Cupon do
  def main do
    cupon = "Ingrese el cupon: "
    |> Util.ingresar(:texto)
    |> String.replace(" ", "") # se hace para que el usuario no ingrese algun espacio ^^
    {cupon,[]}
    |> verificar_longitud()
    |> verificar_mayuscula()
    |> verificar_numero()
    |> verificar_espacios()
    |> construir_mensaje()
    |> mostrar_mensaje()
  end


    def verificar_longitud({cupon, errores}) do
      if String.length(cupon) >= 10, do: {cupon, errores},
     else: {cupon, errores ++ ["El cupon debe contener al menos 10 caracteres"]}
    end

    def verificar_mayuscula({cupon, errores}) do
     if cupon != String.downcase(cupon), do: {cupon, errores},
     else: {cupon, errores ++ ["El cupon debe contener al menos una mayuscula"]}
    end

    def verificar_numero({cupon, errores}) do
      if String.contains?(cupon, ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]), do: {cupon, errores},
      else: {cupon, errores ++ ["El cupon debe contener al menos un número."]}
    end

    def verificar_espacios({cupon, errores}) do
      if String.contains?(cupon, " "), do: {cupon, errores ++ ["El cupon no puede contener espacios."]},
     else: {cupon, errores}
    end

    defp construir_mensaje({cupon, []}) do
      {:ok, "Cupón valido #{cupon}"}
    end

    defp construir_mensaje({cupon, errores}) do
      mensaje = Enum.join(errores, "\n -")
      {:error, "Cupon invalido:\n - #{mensaje}"}
    end

    def mostrar_mensaje({:ok, mensaje}), do: Util.mostrar_mensaje(mensaje)
    def mostrar_mensaje({:error, mensaje}), do: Util.mostrar_error(mensaje)

end

Cupon.main()
