defmodule EntradaEnteros do
  def main do
    valor_total = "Ingrese el valor total de la compra: "
    |> Util.ingresar(:entero)

    valor_entregado = "Ingrese el valor entregado por el cliente: "
    |> Util.ingresar(:entero)

    calcular_devuelta(valor_entregado, valor_total)
    |> generar_mensaje()
    |> Util.mostrar_mensaje()
  end

  defp calcular_devuelta(valor_pago, valor_total) do
    valor_pago - valor_total
  end
  defp generar_mensaje(devuelta) do
    "El cambio a entregar es $ #{devuelta}"
  end
end

EntradaEnteros.main()
