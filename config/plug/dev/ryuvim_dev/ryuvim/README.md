## Dependencies

- Your plugin requires `LuaSocket` for HTTP requests. You can install it as follows:

### For Neovim Users

- **Using `packer.nvim`**:
  ```lua
  use {
    "your-username/your-plugin-name",
    requires = { "luarocks/luasocket" }
  }
  ```
