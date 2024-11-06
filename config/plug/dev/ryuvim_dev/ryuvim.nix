{ pkgs, ... }:
{
  extraFiles =
    {
      "lua/ryuvim/init.lua" = {
        source = ./ryuvim/init.lua;
      };
      "lua/ryuvim/utils.lua" = {
        source = ./ryuvim/utils.lua;
      };
      "lua/ryuvim/commands/list.lua" = {
        source = ./ryuvim/commands/list.lua;
      };
      "lua/ryuvim/commands/query.lua" = {
        source = ./ryuvim/commands/query.lua;
      };
      "lua/ryuvim/commands/delete.lua" = {
        source = ./ryuvim/commands/delete.lua;
      };
      "lua/ryuvim/openai.lua" = {
        source = ./ryuvim/openai.lua;
      };
      "lua/ryuvim/commands/ask.lua" = {
        source = ./ryuvim/commands/ask.lua;
      };
      "lua/ryuvim/commands/set_db.lua" = {
        source = ./ryuvim/commands/set_db.lua;
      };
      "lua/ryuvim/commands/create.lua" = {
        source = ./ryuvim/commands/create.lua;
      };
    };

  extraConfigLua = ''
    require('ryuvim')
    require('ryuvim/utils')
    require('ryuvim/commands/list')
    require('ryuvim/openai')
  '';

}
