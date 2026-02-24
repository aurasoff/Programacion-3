defmodule Descuento do
  def main do
    valor_producto =
      "Ingrese el valor del producto:"
      |> Util.ingresar(:entero)

    porcentaje_descuento =
      "Ingrese el porcentaje de descuento:"
      |> Util.ingresar(:real)

    valor_descuento =
      calcular_valor_descuento(valor_producto, porcentaje_descuento)

    valor_final =
      calcular_valor_final(valor_producto, valor_descuento)

    generar_mensaje(valor_descuento, valor_final)
    |> Util.mostrar_mensaje()
  end

  defp calcular_valor_descuento(valor_producto, porcentaje_descuento) do
    (valor_producto * porcentaje_descuento) / 100
  end

  defp calcular_valor_final(valor_producto, valor_descuento) do
    valor_producto - valor_descuento
  end

  defp generar_mensaje(valor_descuento, valor_final) do
    valor_descuento = Float.round(valor_descuento, 1)
    valor_final = Float.round(valor_final, 1)

    "El valor del descuento es $ #{valor_descuento} y el valor final del producto es $ #{valor_final}"
  end
end

Descuento.main()
