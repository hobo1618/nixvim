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
      "lua/ryuvim/graph/save.lua" = {
        source = ./ryuvim/graph/save.lua;
      };
      "lua/ryuvim/graph/create.lua" = {
        source = ./ryuvim/graph/create.lua;
      };
      "lua/ryuvim/graph/copy.lua" = {
        source = ./ryuvim/graph/copy.lua;
      };
      "lua/ryuvim/openai.lua" = {
        source = ./ryuvim/openai.lua;
      };
      "lua/ryuvim/core/search.lua" = {
        source = ./ryuvim/core/search.lua;
      };
      "lua/ryuvim/core/ask.lua" = {
        source = ./ryuvim/core/ask.lua;
      };
      "lua/ryuvim/graph/set_db.lua" = {
        source = ./ryuvim/graph/set_db.lua;
      };
      "lua/ryuvim/cypher/create.lua" = {
        source = ./ryuvim/cypher/create.lua;
      };
    };

  extraConfigLua = ''
    require('ryuvim')
    require('ryuvim/utils')
    require('ryuvim/graph/list')
    require('ryuvim/openai')
    require('ryuvim/core/ask')
    require('ryuvim/core/search')
    require('ryuvim/cypher/create')
  '';

}
