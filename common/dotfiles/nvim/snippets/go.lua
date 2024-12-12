local get_package = function()
    return vim.fn.fnamemodify(vim.fn.expand('%'), ':p:h:t')
end

local function _tocamel(s)
    return string.upper(string.sub(s, 1, 1)) .. string.sub(s, 2)
end

local function tocamel(s)
    return (string.gsub(s, "_(%w+)", _tocamel)):gsub("^%l", string.upper)
end

local get_object_name = function()
    return tocamel(vim.fn.fnamemodify(vim.fn.expand('%'), ':t:r'))
end

local get_object_repo_name = function()
    return get_object_name():gsub('Service', 'Repository')
end

local get_module_name = function()
    return vim.json.decode(vim.fn.system('go mod edit -json'))['Module']['Path']
end

return {
    s("repository",
        fmt([[
            package {package_name}

            import (
               	"gorm.io/gorm"
                "{module_name}/models"
            )

            type {object_name} interface {{

            }}

            type Gorm{object_name} struct {{
                db *gorm.DB
            }}

            func NewGorm{object_name}(db *gorm.DB) *Gorm{object_name} {{
                return &Gorm{object_name} {{
                    db: db,
                }}
            }}

            {}
        ]], {
            package_name = f(get_package, {}),
            object_name = f(get_object_name, {}),
            module_name = f(get_module_name, {}),
            i(1)
        })
    ),

    s("service",
        fmt([[
            package {package_name}

            import (
                "{module_name}/repositories"
            )

            type {object_name} interface {{

            }}

            type Default{object_name} struct {{
                repo repositories.{object_repo_name}
            }}

            func NewDefault{object_name}(repo repositories.{object_repo_name}) *Default{object_name} {{
                return &Default{object_name} {{
                    repo: repo,
                }}
            }}

            {}
        ]], {
            package_name = f(get_package, {}),
            object_name = f(get_object_name, {}),
            object_repo_name = f(get_object_repo_name, {}),
            module_name = f(get_module_name, {}),
            i(1)
        })
    ),

    s("model",
        fmt([[
            package {package_name}

            import (
                "gorm.io/gorm"
            )

            type {object_name} struct {{
                gorm.Model
            }}

            {}
        ]], {
            package_name = f(get_package, {}),
            object_name = f(get_object_name, {}),
            i(1),
        })
    ),

    s("test",
        c(1, {
            fmt([[
            func Test{}(t *testing.T) {{

            }}
            ]], {i(1)}, {kind = ""}),
            fmt([[
            package {package_name}

            import (
                "testing"
            )

            func Test{}(t *testing.T) {{

            }}
        ]], {
                package_name = f(get_package, {}),
                i(1),
            }, {}),
        })
    )
}
