require 'rubygems'
require 'bundler'

Bundler.require

require 'active_support/inflector'
require 'lib/rest_server/server'

run RestServer::Server
