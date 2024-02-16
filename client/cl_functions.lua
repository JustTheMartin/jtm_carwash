ESX = exports.es_extended:getSharedObject()

function Notify(message, type)
    if Config.Notify == "esx" then
        ESX.ShowNotification(message)
    elseif Config.Notify == "ox" then
        lib.notify({
            description = message,
            type = type
        })
    elseif Config.Notify == "okok" then
        exports['okokNotify']:Alert('Car Wash', message, 7500, type, true)
    else
        -- Add your own notifiaction
    end
end

function HelpText(message)
    if Config.HelpText == "esx" then
        ESX.ShowHelpNotification(message, false, false, -1)
    elseif Config.HelpText == "ox" then
        lib.showTextUI(message)
    elseif Config.HelpText == "okok" then
        exports['okokTextUI']:Open(message, 'gray', 'right-center', true)
    else
        -- Add your own helptext
    end
end

function HideText()
    if Config.HelpText == "ox" then
        lib.hideTextUI()
    elseif Config.HelpText == "okok" then
        exports['okokTextUI']:Close()
    else
        -- Add your own hide helptext
    end
end

function ProgressBar(duration, message)
    if Config.ProgressBar == "ox" then
        return lib.progressBar({
            duration = duration,
            label = message,
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = false,
                move = true,
                combat = true,
                sprint = true
            }
        })
    else
        -- Add your own progressbar
        return true -- Do not delete
    end
end