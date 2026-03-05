defmodule PlataformaV do
  def main do

    usuario = %{nombre: "Maríana", edad: 25, email: "mariana@example.com"}
    IO.inspect(usuario)

    nombre_usuario = "Ingrese el nombre del usuario: "
     |> Util.ingresar(:texto)

    edad_usuario = "Ingrese la edad del usuario: "
     |> Util.ingresar(:entero)

     def validar_usuario(usuario, nombre_usuario, edad_usuario) do
     end

     def mostrar_resultado(resultado) do
      (:ok, mensaje) = resultado
        IO.puts(mensaje)
      end
      def mostrar_resultado({:error, mensaje}) do
        IO.puts(mensaje)
      end

    if usuario.edad == edad_usuario do
      IO.puts("Edad coincide: #{Map.has_key?(usuario, :edad)}")
    else
      IO.puts("Edad no coincide: #{Map.has_key?(usuario, :edad)}")
    end

    if usuario.nombre == nombre_usuario do
      IO.puts("Nombre coincide: #{Map.has_key?(usuario, :nombre)}")
    else 
      IO.puts("Nombre no coincide: #{Map.has_key?(usuario, :nombre)}")
    end

    def numero_intentos() do

    end

    acceso_permitido = Map.has_key?(usuario, :nombre) and Map.has_key?(usuario, :edad)
    if acceso_permitido do
      IO.puts("Acceso permitido")
    else
      IO.puts("Acceso denegado")
    end

  end
end
PlataformaV.main()
