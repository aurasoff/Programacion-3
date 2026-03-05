# El parqueadero, necesita obtener la hora actual, además saludar
# al usuario.

defmodule Parqueadero do

  def obtener_hora_actual do
    {{_year, _month, _day}, {hour, minutes, seconds}} = :calendar.local_time()

    saludo =
      cond do
        hour < 12 -> "Buenos días."
        hour < 18 -> "Buenas tardes."
        true -> "Buenas noches."
      end

    nombre =
      "Ingrese nombre: "
      |> Util.ingresar(:texto)

    Util.mostrar_mensaje("La hora actual es: #{hour}:#{minutes}:#{seconds}")
    Util.mostrar_mensaje("#{saludo} #{nombre}")
  end


  def main do

    nombre =
      "Ingrese nombre: "
      |> Util.ingresar(:texto)

    {nombre, []}
    |> verificar_longitud()
    |> verificar_miniculas()
    |> verificar_espacios()
    |> verificar_caracteres_especiales()
    |> contiene_letra()
    |> construir_mensaje()
    |> mostrar_mensaje()


    hora_entrada = "Hora de entrada: " |> Util.ingresar(:entero)
    hora_salida1  = "Hora de salida: "  |> Util.ingresar(:entero)
    frecuente     = "¿Es cliente frecuente? (1 para sí, 0 para no): " |> Util.ingresar(:entero)
    electrico     = "¿Es un vehículo eléctrico? (1 para sí, 0 para no): " |> Util.ingresar(:entero)
    fin_de_semana = "¿Es fin de semana? (1 para sí, 0 para no): " |> Util.ingresar(:entero)

    tarifa = tarifa_base(hora_entrada, hora_salida1)

    descuento(
      hora_entrada,
      hora_salida1,
      frecuente,
      electrico,
      fin_de_semana,
      tarifa
    )

  end


 def tarifa_base(hora_entrada, hora_salida) do
  horas = hora_salida - hora_entrada

  cond do
    horas <= 2 ->
      3000

    horas <= 5 ->
      3000 + (horas - 2) * 2500 #se restan las 2 horas iniciales

    horas <= 8 ->
      3000 + (3 * 2500) + (horas - 5) * 2000 # se multiplican por 3 las 3 horas que ya pasaron y se restan -5 por las horas anteriores

    true ->
      18000
  end
end

  def descuento(hora_entrada, hora_salida, frecuente, electrico, fin_de_semana, tarifa_base) do
    descuento_frecuente= if frecuente == 1,      do: 0.15, else: 0.0
    descuento_electrico= if electrico == 1,      do: 0.20, else: 0.0
    descuento_fin_de_semana= if fin_de_semana == 1,  do: 0.10, else: 0.0

    total_descuento = descuento_frecuente + descuento_electrico + descuento_fin_de_semana
    valor_final = tarifa_base - (tarifa_base * total_descuento)

    Util.mostrar_mensaje("Valor final: #{round(valor_final)}")
    Util.mostrar_mensaje("Valor sin descuento: #{round(tarifa_base)}")
  end



  def verificar_longitud({nombre, errores}) do
    longitud = String.length(nombre)

    cond do
      longitud < 5 ->
        {nombre, errores ++ ["Debe tener mínimo 5 caracteres"]}

      longitud > 12 ->
        {nombre, errores ++ ["No debe exceder 12 caracteres"]}

      true ->
        {nombre, errores}
    end
  end


  def verificar_miniculas({nombre, errores}) do
    if String.downcase(nombre) != nombre do
      {nombre, errores ++ ["Debe estar en minúsculas"]}
    else
      {nombre, errores}
    end
  end


  def verificar_espacios({nombre, errores}) do
    if String.contains?(nombre, " ") do
      {nombre, errores ++ ["No debe contener espacios"]}
    else
      {nombre, errores}
    end
  end


  def verificar_caracteres_especiales({nombre, errores}) do
    if String.contains?(nombre, ["@", "#", "$", "%"]) do
      {nombre, errores ++ ["No puede contener @ # $ %"]}
    else
      {nombre, errores}
    end
  end


  def contiene_letra({nombre, errores}) do
  tiene_letra =
    nombre
    |> String.to_charlist()
    |> Enum.any?(fn c -> c >= ?a and c <= ?z end)

  if tiene_letra do
    {nombre, errores}
  else
    {nombre, errores ++ ["Debe contener al menos una letra"]}
  end
end


  def construir_mensaje({nombre, []}) do
    {:ok, "Usuario válido: #{nombre}"}
  end


  def construir_mensaje({nombre, errores}) do
    mensaje = Enum.join(errores, "\n - ")
    {:error, "Usuario inválido:\n - #{mensaje}"}
  end


  def mostrar_mensaje({:ok, mensaje}) do
    Util.mostrar_mensaje(mensaje)
  end


  def mostrar_mensaje({:error, mensaje}) do
    Util.mostrar_mensaje(mensaje)
  end

end


Parqueadero.main()
