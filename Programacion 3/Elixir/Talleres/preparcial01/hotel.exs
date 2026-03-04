defmodule Hotel do
  def main do
    numero_noches = "Ingrese numero de noches: "
    |> Util.ingresar(:entero)
    |> validar_numero_noches()
    tipo_cliente = "Ingrese el tipo de cliente(frecuente, corporativo o ocasional): "
    |> Util.ingresar(:texto)
    |> String.downcase()
    |> validar_tipo_cliente()
    temporada = "Ingrese la temporada(alta, baja): "
    |> Util.ingresar(:texto)
    |> String.downcase()
    |> validar_temporada()

    {subtotal, descuento, total} = calcular_reserva(numero_noches, tipo_cliente, temporada)
    mostrar_resultado(numero_noches, temporada, tipo_cliente, subtotal, descuento, total)
  end

  defp validar_tipo_cliente(tipo) when tipo in ["frecuente", "corporativo", "ocasional"] do
    String.to_atom(tipo)
  end
  defp validar_tipo_cliente(_) do
    Util.mostrar_error("Tipo cliente invalido")
    main()
  end

  defp validar_temporada(temp) when temp in ["alta", "baja"] do
    String.to_atom(temp)
  end
  defp validar_temporada(_) do
    Util.mostrar_error("Tipo de temporada invalida")
    main()
  end

  defp validar_numero_noches(numero_noches) when is_integer(numero_noches) and numero_noches > 0 do
    numero_noches
  end
  defp validar_numero_noches(_) do
    Util.mostrar_error("El numero de noches debe ser mayor que 0")
    main()
  end                                    # ← end solo de la función

  defp calcular_subtotal(numero_noches) do
    costo_noche(numero_noches)
  end

  defp costo_noche(numero_noches) when numero_noches <= 2, do: numero_noches * 12000
  defp costo_noche(numero_noches) when numero_noches <= 5, do: numero_noches * 100000
  defp costo_noche(numero_noches),                         do: numero_noches * 85000

  defp calcular_descuento(:frecuente),   do: 0.20
  defp calcular_descuento(:corporativo), do: 0.15
  defp calcular_descuento(:ocasional),   do: 0

  defp recargo_temporada(temporada) do
    cond do
      temporada == :alta -> 0.25
      true -> 0
    end
  end

  defp calcular_reserva(numero_noches, tipo_cliente, temporada) do
    subtotal = calcular_subtotal(numero_noches)
    descuento = calcular_descuento(tipo_cliente)
    subtotal_with_temporada = subtotal + (subtotal * recargo_temporada(temporada))
    total = subtotal_with_temporada - (subtotal_with_temporada * descuento)
    {subtotal_with_temporada, descuento, total}
  end

  defp mostrar_resultado(noches, temporada, tipo_cliente, subtotal, descuento, total) do
    " Noches: #{noches}\n Temporada: #{temporada}\n Subtotal: $#{round(subtotal)}\n Cliente: #{tipo_cliente}\n Descuento aplicado por ser cliente #{tipo_cliente}: #{round(descuento * 100)}%\n Total a pagar: $#{round(total)}"
    |> Util.mostrar_mensaje()
  end
end                                      # ← end del módulo, solo uno

Hotel.main()
