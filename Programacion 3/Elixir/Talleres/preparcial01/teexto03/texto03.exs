defmodule Acceso do
  def main do
    # Ingresamos los datos del empleado
    nombre = "Ingrese el nombre del empleado: "
     |> Util.ingresar(:texto)
    edad = "Ingrese la edad: "
    |> Util.ingresar(:entero)
    rol = "Ingrese el rol (administrador/auditor/operario): "
     |> Util.ingresar(:texto)
     |> String.to_atom()
    departamento = "Ingrese el departamento: "
     |> Util.ingresar(:texto)

    # Armamos la tupla y la enviamos a verificar
    {nombre, edad, rol, departamento}
    |> verificar_acceso()
    |> mostrar_resultado()
  end

  # ─── VALIDACIONES POR ROL ─────────────────────────────────────────────────

  # :administrador con 21 años o más → acceso concedido
  # el _ en departamento significa que no importa el departamento
  defp verificar_acceso({nombre, edad, :administrador, _departamento})
       when edad >= 21 do
    {:acceso_concedido, "Bienvenido #{nombre}"}
  end

  # :auditor solo si pertenece a Finanzas o Seguridad
  # in verifica si el valor está dentro de la lista
  defp verificar_acceso({nombre, _edad, :auditor, departamento})
       when departamento in ["Finanzas", "Seguridad"] do
    {:acceso_concedido, "Bienvenido #{nombre}"}
  end

  # :operario mayor de 18 → verificamos si es contratista externo
  defp verificar_acceso({nombre, edad, :operario, _departamento})
       when edad > 18 do
    # Convertimos a minúsculas para comparar sin importar mayúsculas
    nombre_lower = String.downcase(nombre)

    # Si el nombre tiene x o z es contratista externo → advertencia
    if String.contains?(nombre_lower, ["x", "z"]) do
      {:acceso_concedido_con_advertencia, "Bienvenido #{nombre} - Requiere supervisión"}
    else
      {:acceso_concedido, "Bienvenido #{nombre}"}
    end
  end

  # Cualquier otro caso que no coincida arriba → acceso denegado
  # Este caso siempre va al final porque es el más general
  defp verificar_acceso({_nombre, _edad, _rol, _departamento}) do
    {:acceso_denegado, "No cumple con las políticas de seguridad"}
  end

  # ─── MOSTRAR RESULTADO ────────────────────────────────────────────────────

  # Acceso normal
  defp mostrar_resultado({:acceso_concedido, mensaje}) do
    Util.mostrar_mensaje(mensaje)
  end

  # Acceso con advertencia (contratista externo)
  defp mostrar_resultado({:acceso_concedido_con_advertencia, mensaje}) do
    Util.mostrar_mensaje(mensaje)
  end

  # Acceso denegado
  defp mostrar_resultado({:acceso_denegado, mensaje}) do
    Util.mostrar_error(mensaje)
  end
end

Acceso.main()
