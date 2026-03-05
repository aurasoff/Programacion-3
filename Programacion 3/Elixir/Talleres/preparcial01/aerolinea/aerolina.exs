defmodule Aerolina do
  def main do
    destino = "Ingresar destino(medellin, bogota, cartagena, san andres): "
    |> Util.ingresar(:texto)
    |> String.downcase()
    |> String.replace(" ", "_")
    |> verificar_destino()

    servicio_adicional = "Agregue el servicio adicional (Seleccion de sillas, Maleta en Bodeja, Seguro de viaje, ninguno): "
    |> Util.ingresar(:texto)
    |> String.downcase()
    |> String.replace(" ", "_")
    |> verificar_servicio_ad()


    {total, destino, servicio, automatica} =
      {destino, servicio_adicional}
      |> agregar_maleta_obligatoria()
      |> calcular_total()

    mostrar_resultado({total, destino, servicio, automatica})
  end
  def verificar_destino(destino) when destino in ["medellin", "bogota", "cartagena", "san_andres"] do
    String.to_atom(destino)
  end

  def verificar_destino(_) do Util.mostrar_error("Tipo de temporada invalida.")
    main()
  end

  defp verificar_servicio_ad(servicio) when servicio in ["seleccion_de_sillas", "maleta_de_bodega", "seguro_de_viaje", "ninguno"] do
    String.to_atom(servicio)
  end

  defp veificar_servicio_ad(_) do Util.mostrar_error("El tipo de servicio adicional es invalida")
   main()
  end
  defp precio_base(:medellin), do: 300000
  defp precio_base(:bogota), do: 350000
  defp precio_base(:cartagena), do: 500000
  defp precio_base(:san_andres), do: 870000

  defp servicio_adicional(:seleccion_de_sillas), do: 15000
  defp servicio_adicional(:maleta_de_bodega), do: 45000
  defp servicio_adicional(:seguro_de_viaje), do: 12000
  defp servicio_adicional(:ninguno), do: 0

  defp maleta_obligatoria?(destino) when destino == :san_andres, do: true
  defp maleta_obligatoria?(_destino), do: false

  def agregar_maleta_obligatoria({destino,servicio}) do
    if maleta_obligatoria?(destino) do {destino, :maleta_de_bodega, true}
  else
    {destino,servicio,false}
    end
  end

  defp calcular_total({destino, servicio, automatica}) do
    total= precio_base(destino) + servicio_adicional(servicio)
    {total, automatica, destino, servicio}
  end
  defp mostrar_resultado({total, destino, servicio, true}) do
  Util.mostrar_mensaje("Destino: #{destino}")
  Util.mostrar_mensaje("Servicio: #{servicio} (agregado automáticamente)")
  Util.mostrar_mensaje("Total a pagar: $#{total}")
end

defp mostrar_resultado({total, destino, servicio, false}) do
  Util.mostrar_mensaje("Destino: #{destino}")
  Util.mostrar_mensaje("Servicio: #{servicio}")
  Util.mostrar_mensaje("Total a pagar: $#{total}")
end
end

Aerolina.main()
