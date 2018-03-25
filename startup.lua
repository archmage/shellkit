----- >> -- >> -- |
-- kara's cmder startup config file
-- does prompt things!
----- << -- << -- |

---
-- Setting the prompt in clink means that commands which rewrite the prompt do
-- not destroy our own prompt. It also means that started cmds (or batch files
-- which echo) don't get the ugly '{lamb}' shown.
---
local function set_prompt_filter()
    -- get_cwd() is differently encoded than the clink.prompt.value, so everything other than
    -- pure ASCII will get garbled. So try to parse the current directory from the original prompt
    -- and only if that doesn't work, use get_cwd() directly.
    -- The matching relies on the default prompt which ends in X:\PATH\PATH>
    -- (no network path possible here!)
    local old_prompt = clink.prompt.value
    local cwd = old_prompt:match('.*(.:[^>]*)>')
    if cwd == nil then cwd = clink.get_cwd() end

    -- get hostname
    local handle = io.popen("hostname")
    local hostname = handle:read("*a")
    hostname = hostname:sub(0, hostname:len() - 2)
    handle:close()

    -- kara's custom prompt ^_^
    local cmder_prompt = "\x1b[91m{name}\x1b[95m{joiner}\x1b[35m{domain} \x1b[33m{cwd}\n\x1b[92m{prompt}\x1b[0m"
    cmder_prompt = string.gsub(cmder_prompt, "{name}", clink.get_env("USERNAME"):lower())
    cmder_prompt = string.gsub(cmder_prompt, "{joiner}", "~")
    cmder_prompt = string.gsub(cmder_prompt, "{domain}", hostname:lower())
    cmder_prompt = string.gsub(cmder_prompt, "{cwd}", cwd)
    cmder_prompt = string.gsub(cmder_prompt, "{prompt}", "==> ")

    clink.prompt.value = cmder_prompt
end

clink.prompt.register_filter(set_prompt_filter, 2)