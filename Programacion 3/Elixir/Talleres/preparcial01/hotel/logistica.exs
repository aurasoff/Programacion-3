defmodule GestionOrdenes do

  # ─── Tarifa de envío con CASE ──────────────────────────────
  defp tarifa_envio(categoria) do
    case categoria do
      :electronica -> 15_000
      :hogar       -> 10_000
      :alimentos   ->  5_000
      _otro        -> 20_000 nnnmn
    end
  end

  # ─── Descuento con GUARDS ──────────────────────────────────
  defp porcentaje_descuento(cantidad) when cantidad > 10,                    do: 0.10
  defp porcentaje_descuento(cantidad) when cantidad >= 5 and cantidad <= 10, do: 0.05
  defp porcentaje_descuento(_cantidad),                                      do: 0.00

  # ─── Funciones encadenadas ─────────────────────────────────
  defp calcular_subtotal_y_descuento({categoria, cantidad, precio_unitario}) do
    subtotal        = precio_unitario * cantidad
    porcentaje      = porcentaje_descuento(cantidad)
    valor_descuento = subtotal * porcentaje
    subtotal_descontado = subtotal - valor_descuento
    {categoria, cantidad, precio_unitario, subtotal, valor_descuento, subtotal_descontado}
  end

  defp calcular_impuesto({categoria, cantidad, precio_unitario, subtotal, valor_descuento, subtotal_descontado}) do
    valor_impuesto =
      unless categoria == :alimentos do
        subtotal_descontado * 0.19
      else
        0.0
      end
    {categoria, cantidad, precio_unitario, subtotal, valor_descuento, subtotal_descontado, valor_impuesto}
  end

  defp calcular_envio_y_total({categoria, cantidad, precio_unitario, subtotal, valor_descuento, subtotal_descontado, valor_impuesto}) do
    costo_envio = tarifa_envio(categoria)
    total_final = subtotal_descontado + valor_impuesto + costo_envio

    estado_orden =
      cond do
        total_final > 500_000                              -> :prioridad_alta
        total_final >= 200_000 and total_final <= 500_000  -> :prioridad_normal
        total_final < 200_000                              -> :prioridad_baja
      end

    {subtotal, valor_descuento, valor_impuesto, costo_envio, total_final, estado_orden}
  end

  # ─── calcular_orden con |> ─────────────────────────────────
  def calcular_orden(nombre_producto, categoria, cantidad, precio_unitario) do
    IO.puts("\n📦 Procesando: #{nombre_producto}")

    {subtotal, valor_descuento, valor_impuesto, costo_envio, total_final, estado_orden} =
      {categoria, cantidad, precio_unitario}
      |> calcular_subtotal_y_descuento()
      |> calcular_impuesto()
      |> calcular_envio_y_total()

    {:ok, subtotal, valor_descuento, valor_impuesto, costo_envio, total_final, estado_orden}
  end

  # ─── Imprimir resultado ────────────────────────────────────
  defp imprimir_resultado(nombre, resultado) do
    {:ok, subtotal, descuento, impuesto, envio, total, estado} = resultado

    IO.puts("┌─────────────────────────────────────────┐")
    IO.puts("│  Producto : #{String.pad_trailing(nombre, 29)}│")
    IO.puts("├─────────────────────────────────────────┤")
    IO.puts("│  Subtotal        : $#{String.pad_leading(fmt(subtotal), 18)}  │")
    IO.puts("│  Descuento       : -$#{String.pad_leading(fmt(descuento), 17)}  │")
    IO.puts("│  IVA (19%)       : +$#{String.pad_leading(fmt(impuesto), 17)}  │")
    IO.puts("│  Costo envío     : +$#{String.pad_leading(fmt(envio * 1.0), 17)}  │")
    IO.puts("├─────────────────────────────────────────┤")
    IO.puts("│  TOTAL FINAL     :  $#{String.pad_leading(fmt(total), 17)}  │")
    IO.puts("│  Estado orden    :  #{String.pad_trailing(Atom.to_string(estado), 20)}│")
    IO.puts("└─────────────────────────────────────────┘\n")
  end

  defp fmt(valor), do: :erlang.float_to_binary(valor * 1.0, decimals: 2)

  # ─── Leer categoría ───────────────────────────────────────
  defp leer_categoria do
    IO.puts("   Categorías disponibles:")
    IO.puts("   1 → electronica  ($15.000 envío)")
    IO.puts("   2 → hogar        ($10.000 envío)")
    IO.puts("   3 → alimentos    ($5.000 envío, sin IVA)")
    IO.puts("   4 → otra         ($20.000 envío)")
    opcion = IO.gets("   Elige una opción (1-4): ") |> String.trim()

    case opcion do
      "1" -> :electronica
      "2" -> :hogar
      "3" -> :alimentos
      "4" -> :otra
      _   ->
        IO.puts("   ⚠️  Opción inválida, intenta de nuevo.")
        leer_categoria()a
    end
  end

  # ─── Leer cantidad ────────────────────────────────────────
  defp leer_cantidad do
    entrada = IO.gets("   Cantidad: ") |> String.trim()
    case Integer.parse(entrada) do
      {n, ""} when n > 0 -> n
      _ ->
        IO.puts("   ⚠️  Ingresa un número entero positivo.")
        leer_cantidad()
    end
  end

  # ─── Leer precio ──────────────────────────────────────────
  defp leer_precio do
    entrada = IO.gets("   Precio unitario: $") |> String.trim()
    case Float.parse(entrada) do
      {p, ""} when p > 0 -> p
      _ ->
        case Integer.parse(entrada) do
          {p, ""} when p > 0 -> p * 1.0
          _ ->
            IO.puts("   ⚠️  Ingresa un precio válido mayor a 0.")
            leer_precio()
        end
    end
  end

  # ─── MAIN ─────────────────────────────────────────────────
  def main do
    IO.puts("\n╔═════════════════════════════════════════╗")
    IO.puts("║   SISTEMA DE GESTIÓN DE ÓRDENES         ║")
    IO.puts("╚═════════════════════════════════════════╝")

    loop()
  end

  defp loop do
    IO.puts("\n¿Qué deseas hacer?")
    IO.puts("  1 → Registrar nueva orden")
    IO.puts("  2 → Salir")
    opcion = IO.gets("\nOpción: ") |> String.trim()

    case opcion do
      "1" ->
        IO.puts("\n── Nueva Orden ──────────────────────────")
        nombre    = IO.gets("   Nombre del producto: ") |> String.trim()
        categoria = leer_categoria()
        cantidad  = leer_cantidad()
        precio    = leer_precio()

        resultado = calcular_orden(nombre, categoria, cantidad, precio)
        imprimir_resultado(nombre, resultado)
        loop()

      "2" ->
        IO.puts("\n👋 ¡Hasta luego!\n")

      _ ->
        IO.puts("⚠️  Opción inválida.")
        loop()
    end
  end
end

# ─── Punto de entrada ─────────────────────────────────────
GestionOrdenes.main()
