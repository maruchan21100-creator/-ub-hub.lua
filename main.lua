-- Ulstar UB Hub - Versión FINAL corregida 2026 (sin barras extras en \~=)
-- Móvil: Doble toque en pantalla vacía para abrir menú
-- Campos de batalla definitivos - Veracruz 🌴
-- Ejecuta con: loadstring(game:HttpGet("https://raw.githubusercontent.com/maruchan21100-creator/-ub-hub.lua/main/main.lua"))()

Jugadores locales = juego:GetService("Jugadores")
RunService local = juego:GetService("RunService")
ServicioDeEntradaDeUsuario local = juego:ObtenerServicio("ServicioDeEntradaDeUsuario")
ServicioTween local = juego:GetService("ServicioTween")
Almacenamiento replicado local = juego:GetService("Almacenamiento replicado")

jugador local = Jugadores.JugadorLocal
personaje local = jugador.Personaje o jugador.PersonajeAñadido:Espera()
raíz local = personaje:WaitForChild("HumanoidRootPart")
humanoide local = personaje:WaitForChild("Humanoide")

-- Configuración
configuración local = {
    alterna = {
        \KillAura = verdadero,
        InfiniteUltimate = verdadero,
        GodMode = verdadero,
        HitboxExpander = verdadero,
        AntiLag = verdadero
    },
    valores = {
        Rango de aura = 500,
        Tamaño del área de impacto = 80
    }
}

-- GUI sencilla y grande para móviles
screenGui local = Instancia.new("ScreenGui")
screenGui.Name = "UlstarUB"
screenGui.ResetOnSpawn = falso
screenGui.Parent = jugador:WaitForChild("PlayerGui")

marco local = Instancia.new("Marco")
marco.Tamaño = UDim2.nuevo(0.7, 0, 0.6, 0)
marco.Posición = UDim2.new(0.15, 0, 0.2, 0)
marco.ColorDeFondo3 = Color3.deRGB(15, 15, 20)
marco.Transparencia de fondo = 0,45
marco.BorderSizePixel = 0
marco.Visible = verdadero
marco.Activo = verdadero
marco.Draggable = verdadero
marco.Padre = screenGui

título local = Instancia.new("TextLabel")
título.Tamaño = UDim2.new(1, 0, 0.12, 0)
título.Transparencia de fondo = 1
título.Texto = "Ulstar UB Hub"
título.TextColor3 = Color3.fromRGB(0, 255, 180)
título.Fuente = Enumeración.Fuente.SourceSansBold
título.TextScaled = verdadero
título.Padre = marco

- Función para crear alternancias
función local createToggle(nombre, yPos, callback)
    etiqueta local = Instancia.new("TextLabel")
    etiqueta.Tamaño = UDim2.nuevo(0.6, 0, 0.1, 0)
    etiqueta.Posición = UDim2.new(0.05, 0, yPos, 0)
    etiqueta.Transparencia de fondo = 1
    etiqueta.Texto = nombre
    etiqueta.TextoColor3 = Color3.nuevo(1,1,1)
    etiqueta.TextScaled = verdadero
    etiqueta.Padre = marco

    botón local = Instancia.new("TextButton")
    botón.Tamaño = UDim2.nuevo(0.3, 0, 0.1, 0)
    botón.Posición = UDim2.new(0.65, 0, yPos, 0)
    botón.Texto = "OFF"
    botón.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    botón.TextColor3 = Color3.nuevo(1)
    botón.TextScaled = verdadero
    boton.Parent = marco

    estado local = falso
    función local alternar()
        estado = no estado
        boton.Text = estado y "ON" o "OFF"
        boton.BackgroundColor3 = estado y Color3.fromRGB(0, 180, 0) o Color3.fromRGB(180, 0, 0)
        devolución de llamada(estado)
    fin

    boton.TouchTap:Conectar(alternar)
    boton.MouseButton1Click:Conectar(alternar)
fin

-- Alterna principales
createToggle("Matar Aura", 0.18, función(v) config.toggles.KillAura = v fin)
createToggle("Ultimate Infinito", 0.32, función(v) config.toggles.InfiniteUltimate = v end)
createToggle("Modo Dios", 0.46, function(v) config.toggles.GodMode = v end)
createToggle("Expansor de Hitbox", 0.60, función(v) config.toggles.HitboxExpander = v fin)
createToggle("Anti Lag", 0.74, función(v) config.toggles.AntiLag = v fin)

-- Abrir/cerrar menú
función local alternarGUI()
    marco.Visible = no marco.Visible
    trans local = marco.Visible y 0,45 o 1
    TweenService:Create(frame, TweenInfo.new(0.3), {Transparencia de fondo = trans}):Reproducir()
fin

UserInputService.TouchTap:Connect(función(_, proc) si no es proc entonces alternarGUI() fin fin)
UserInputService.InputBegan:Connect(función(entrada)
    si input.KeyCode == Enum.KeyCode.RightShift entonces alternarGUI() fin
fin)

-- Lógica principal (cada 0.2s para no laggear)
último local = 0
RunService.Heartbeat:Connect(función()
    si tick() - ultimo < 0.2 entonces devuelve fin
    último = tick()

    si config.toggles.InfiniteUltimate entonces
        pcall(función()
            local rem = ReplicatedStorage:FindFirstChild("DespertarRemoto") o ReplicatedStorage.Remotes:FindFirstChild("Último")
            si rem entonces rem:FireServer() fin
        fin)
    fin

    si config.toggles.GodMode entonces
        humanoide.Salud = humanoide.MáxSalud
        humanoide: SetStateEnabled (Enum.HumanoidStateType.Ragdoll, falso)
        humanoide:SetStateEnabled(Enum.HumanoidStateType.FallingDown, falso)
    fin

    si config.toggles.KillAura entonces
        para _, otro en ipairs(Players:GetPlayers()) hacer
            si otro \~= jugador y otro.Carácter y otro.Carácter:FindFirstChild("HumanoidRootPart") entonces
                dist local = (raíz.Posición - otro.Carácter.ParteRaízHumanoid.Posición).Magnitud
                si dist <= config.values.AuraRange entonces
                    otro.Personaje.Humanoide.Salud = 0
                fin
            fin
        fin
    fin

    si config.toggles.HitboxExpander entonces
        para _, otro en ipairs(Players:GetPlayers()) hacer
            si otro \~= jugador y otro.Carácter y otro.Carácter:FindFirstChild("HumanoidRootPart") entonces
                hrp local = otro.Personaje.ParteRaízHumanoid
                hrp.Tamaño = Vector3.nuevo(config.valores.HitboxSize, config.valores.HitboxSize, 
    config.valores.HitboxSize)
                hrp.Transparencia = 0.7
                hrp.CanCollide = falso
            fin
        fin
    fin

    si config.toggles.AntiLag entonces
        para _, obj en ipairs(workspace:GetDescendants()) hacer
            si obj:IsA("EmisorDePartículas") o obj:IsA("Rastro") o obj:IsA("Rayo") entonces
                obj.Enabled = falso
            fin
        fin
    fin
fin)

jugador.PersonajeAñadido:Conectar(función(nc)
    carácter = nc
    raíz = nc:WaitForChild("ParteRaízHumanoid")
    humanoide = nc:WaitForChild("Humanoide")
fin)

print("Ulstar UB Hub cargado correctamente - Doble toque para abrir menú. ¡A dominar UB! 🌴")
