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
      "lua/ryuvim/graph/list.lua" = {
        source = ./ryuvim/graph/list.lua;
      };
      "lua/ryuvim/graph/query.lua" = {
        source = ./ryuvim/graph/query.lua;
      };
      "lua/ryuvim/graph/delete.lua" = {
        source = ./ryuvim/graph/delete.lua;
      };
      "lua/ryuvim/openai.lua" = {
        source = ./ryuvim/openai.lua;
      };
      "lua/ryuvim/core/ask.lua" = {
        source = ./ryuvim/graph/ask.lua;
      };
      "lua/ryuvim/graph/set_db.lua" = {
        source = ./ryuvim/graph/set_db.lua;
      };
      "lua/ryuvim/cypher/create.lua" = {
        source = ./ryuvim/graph/create.lua;
      };
    };

  extraConfigLua = ''
    require('ryuvim')
    require('ryuvim/utils')
    require('ryuvim/graph/list')
    require('ryuvim/openai')
  '';

}
