local _M = {}

function _M.getHostname()
    local f = io.open("/etc/hostname")
    local hostname = f:read("*a") or ""
    f:close()
    hostname =string.gsub(hostname, "\n$", "")
    return hostname
end

return _M
