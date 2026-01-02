-- Configuración
local tiempoLimpieza = 120 -- Minutos

-- Función para notificar a todos los jugadores
function NotificarLimpieza(mensaje, tipo)
    -- Opción A: Notificación de OX (Si usas ox_lib, es la más bonita)
    TriggerClientEvent('ox_lib:notify', -1, {
        title = 'SISTEMA DE LIMPIEZA',
        description = mensaje,
        type = tipo or 'inform', -- 'inform', 'error', 'success'
        position = 'top'
    })

    -- Opción B: Chat tradicional (Como respaldo)
    TriggerClientEvent('chat:addMessage', -1, {
        color = {255, 0, 0},
        multiline = true,
        args = {"SISTEMA", mensaje}
    })
end

function LimpiarServidor()
    local vehiculos = GetAllVehicles()
    local vehiculosEliminados = 0

    for i=1, #vehiculos do
        local veh = vehiculos[i]
        local ocupado = false
        for seat = -1, 6 do 
            if GetPedInVehicleSeat(veh, seat) ~= 0 then
                ocupado = true
                break
            end
        end

        if not ocupado then
            DeleteEntity(veh)
            vehiculosEliminados = vehiculosEliminados + 1
        end
    end

    -- Notificamos el resultado final
    local textoFinal = 'La ciudad ha sido optimizada. Se eliminaron ' .. vehiculosEliminados .. ' vehículos abandonados.'
    NotificarLimpieza(textoFinal, 'success')
    print('^2[LIMPIEZA]^7 ' .. textoFinal)
end

-- Bucle automático con avisos
CreateThread(function()
    while true do
        Wait((tiempoLimpieza - 1) * 60000) -- Espera hasta 1 minuto antes del tiempo total
        NotificarLimpieza('AVISO: Limpieza de vehículos abandonados en 60 segundos. ¡Súbete a tu auto!', 'error')
        
        Wait(60000) -- El último minuto de espera
        LimpiarServidor()
    end
end)

-- Comando manual para probar
RegisterCommand('limpiartodo', function(source)
    -- Solo permite a la consola (source 0) o verifica permisos aquí
    LimpiarServidor()
end, true)