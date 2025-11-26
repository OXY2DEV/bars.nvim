# 📐 Architecture

This document describes how the various modules are structured & how they interact with each other under the hood.

<!-- GRAPH -->

Each module is composed of 2 files,

1. A `<module>.lua` which holds all the commands & set/reset functions.
2. A `components/<module>.lua` which holds all the components.

For example, the `statusline` module uses the following files,

- [../lua/bars/statusline.lua](https://github.com/OXY2DEV/bars.nvim/blob/main/lua/bars/statusline.lua)
- [../lua/bars/components/statusline.lua](https://github.com/OXY2DEV/bars.nvim/blob/main/lua/bars/components/statusline.lua)

## `<module>.lua`

This file holds,

+ A configuration table(`module.config`).
  Typically it would have the following structure,

```lua $TYP: ../lua/bars/types/statusline.lua, from: $TYP, class: statusline.config
--- Statusline configuration table.
---@class statusline.config
---
---@field force_attach? string[] List of `statusline` values to ignore when attaching.
---
---@field ignore_filetypes string[] Filetypes to ignore when attaching.
---@field ignore_buftypes string[] Buffer types to ignore when attaching.
---
---@field condition? fun(buffer: integer, window: integer): boolean Additional condition for attaching to windows.
---
---@field default statusline.style Default style.
---@field [string] statusline.style Named style.
```

+ Module state(`module.state`).
```lua $SRC: ../lua/bars/statusline.lua, from: $SRC, field: statusline.state
statusline.state = {
    enable = true,
    attached_windows = {}
};
```

+ A renderer(`module.render`). This will be used as the content of the specific bar/line.
```lua from: $SRC, field: statusline.render
--- Renders the statusline for a window.
---@return string
statusline.render = function ()
    ---|fS

    local components = require("bars.components.statusline");

    local window = vim.g.statusline_winid;
    local buffer = vim.api.nvim_win_get_buf(window);

    statusline.update_style(window);

    local style = vim.w[window].bars_statusline_style or vim.w[window]._bars_statusline_style or "default";
    local config = statusline.config[style];

    if type(config) ~= "table" then
        return "";
    end

    local _o = "";

    for _, component in ipairs(config.components or {}) do
        _o = _o .. components.get(component.kind, buffer, window, component, _o);
    end

    return _o;

    ---|fE
end
```

+ Helper functions such as,
    + A start function(`module.start()`). Usually called during `VimEnter` or via commands.
    + A window attach function(`module.attach(win: integer)`) for attaching to windows.
    + A window detach function(`module.detach(win: integer)`) for detaching from windows.
    + A style updater(`module.update_style(win: integer)`) to change which style is used. Usually called when setting `filetype` & `buftype`.
    + A setup function(`module.setup(config: table)`).

    And optionally some commands(e.g. `module.Enable()`, the function name should start with a **capital letter**).

## `components/<module>.lua`

This file holds,

+ A component retriever to get the various components(and handle errors),

```lua $CMP: ../lua/bars/components/statusline.lua, from: $CMP, field: slC.get
--- Returns the output of the section {name}.
---@param name string
---@param buffer integer
---@param window integer
---@param component_config table
---@param statusline string
---@return string
slC.get = function (name, buffer, window, component_config, statusline)
    ---|fS

    if type(name) ~= "string" then
        --- Component doesn't exist.
        return "";
    elseif type(slC[name]) ~= "function" then
        --- Not a valid component.
        return "";
    else
        if component_config.condition ~= nil then
            if component_config.condition == false then
                --- Component is disabled.
                return "";
            else
                local sucess, val = pcall(component_config.condition, buffer, window, statusline);

                if sucess == false then
                    return "";
                elseif val == false then
                    return "";
                end
            end
        end

        local static_config = vim.deepcopy(component_config);

        for key, value in pairs(static_config) do
            if type(value) ~= "function" then
                goto continue;
            end

            local s_success, s_val = pcall(value, buffer, window, statusline);

            if s_success == false then
                static_config[key] = nil;
            else
                static_config[key] = s_val;
            end

            ::continue::
        end

        --- Return component value.
        return slC[name](buffer, window, static_config, statusline) or "";
    end

    ---|fE
end
```

+ Any number of component functions,

```lua from: $CMP, field: slC.custom, field: slC.branch
--- Custom section.
---@param config statusline.components.custom
---@return string
slC.custom = function (_, _, config)
    return config.value --[[ @as string ]];
end

--- Shows current git branch.
---@param buffer integer
---@param window integer
---@param main_config statusline.components.branch
---@return string
slC.branch = function (buffer, window, main_config)
    ---|fS

    local cwd;
    local ignore = { "default", "condition", "throttle", "kind" };

    vim.api.nvim_win_call(window, function ()
        cwd = vim.fn.getcwd(window);
    end);

    if type(cwd) ~= "string" then
        return "";
    end

    local branch;

    --- Gets the current git branch.
    ---@return string
    local function get_branch ()
        ---|fS

        if package.loaded["gitsigns"] and type(vim.b[buffer].gitsigns_head) == "string" then
            --[[
                NOTE: In case `gitsigns.nvim` is available, use their information instead.

                Getting the branch data may be expensive, so there should be no reason to do it multiple times.
                And `gitsigns.nvim` should handle Git-related stuff better than we do.

                See `:h b:gitsigns_head`.
            ]]
            return vim.b[buffer].gitsigns_head;
        end

        --- Are we in a repo?
        ---@type string
        local in_repo = vim.fn.system({
            "git",
            "-C",
            cwd,
            "rev-parse",
            "--is-inside-work-tree"
        });

        if not in_repo or string.match(in_repo, "^true") == nil then
            --- The output doesn't exist or it doesn't
            --- start with "true" then return.
            return "";
        end

        --- First check if we are inside
        --- a branch.
        ---@type string | ""
        local _branch = vim.fn.system({
            "git",
            "-C",
            cwd,
            "branch",
            "--show-current"
        });

        if _branch == "" then
            --- We are not in a branch.
            --- Attempt to get commit hash(short).
            ---@type string
            _branch = vim.fn.system({
                "git",
                "-C",
                cwd,
                "rev-parse",
                "--short",
                "HEAD"
            });
        end

        return _branch or "";

        ---|fE
    end

    if not vim.w[window].bars_cached_git_branch then
        --- Cached branch name not found.
        --- Get current branch name.
        ---@type string
        branch = vim.split(get_branch(), "\n", { trimempty = true });

        vim.w[window].bars_cached_git_branch = branch;
        vim.w[window].bars_cached_time_git = vim.uv.hrtime();
    else
        ---@type infowhat
        local now = vim.uv.hrtime();
        ---@type integer
        local bef = vim.w.bars_cached_time_git or 0;

        --- Branch value update delay.
        ---@type integer
        local throttle = main_config.throttle or 2000;

        if now - bef >= (throttle * 1e6) then
            --- We have waited longer than `throttle`.
            ---@type string
            branch = vim.split(get_branch(), "\n", { trimempty = true });

            --- Update cached value & update time.
            vim.w[window].bars_cached_git_branch = branch;
            vim.w[window].bars_cached_time_git = vim.uv.hrtime();
        else
            --- Not enough time has passed.
            --- Use cached value.
            branch = vim.w[window].bars_cached_git_branch;
        end
    end

    if not branch or vim.tbl_isempty(branch) then
        return "";
    elseif branch[1]:match("^fatal%:") then
        return "";
    elseif branch[1]:match("^error%:") then
        return "";
    else
        ---@type branch.opts
        local config = utils.match(main_config, branch[1], ignore);

        return table.concat({
            utils.set_hl(config.hl),

            string.format("%s%s", utils.set_hl(config.corner_left_hl), config.corner_left  or ""),
            string.format("%s%s", utils.set_hl(config.padding_left_hl), config.padding_left or ""),
            string.format("%s%s", utils.set_hl(config.icon_hl), config.icon or ""),

            config.text or branch[1] or "",

            string.format("%s%s", utils.set_hl(config.padding_right_hl), config.padding_right or ""),
            string.format("%s%s", utils.set_hl(config.corner_right_hl), config.corner_right  or "")
        });
    end

    ---|fE
end
```

