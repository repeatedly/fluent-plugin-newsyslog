# simplecov must be loaded before any of target code
if ENV['SIMPLE_COV']
  require 'simplecov'
  if defined?(SimpleCov::SourceFile)
    mod = SimpleCov::SourceFile
    def mod.new(*args, &block)
      m = allocate
      m.instance_eval do
        begin
          initialize(*args, &block)
        rescue Encoding::UndefinedConversionError
          @src = "".force_encoding('UTF-8')
        end
      end
      m
    end
  end
  unless SimpleCov.running
    SimpleCov.start do
      add_filter '/test/'
      add_filter '/gems/'
    end
  end
end

require 'rr'
require 'test/unit'
require 'test/unit/rr'
require 'fileutils'
require 'fluent/log'
require 'fluent/test'
require 'fluent/plugin/in_newsyslog'
require 'fluent/plugin/parser_newsyslog'

#Dir["../lib/**/*.rb"].each{| f | require f}

unless defined?(Test::Unit::AssertionFailedError)
  class Test::Unit::AssertionFailedError < StandardError
  end
end

def unused_port
  s = TCPServer.open(0)
  port = s.addr[1]
  s.close
  port
end

def ipv6_enabled?
  require 'socket'

  begin
    TCPServer.open("::1", 0)
    true
  rescue
    false
  end
end

$log = Fluent::Log.new(Fluent::Test::DummyLogDevice.new, Fluent::Log::LEVEL_WARN)
