Core = {}

if Config.Framework == 'qb' then
    Core.Object = exports['qb-core']:GetCoreObject()
else
    Core.Object = exports['es_extended']:getSharedObject()
end
