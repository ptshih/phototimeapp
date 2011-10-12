require File.join(File.dirname(__FILE__), '..', 'config', 'boot')
require File.join(File.dirname(__FILE__), '..', 'config', 'environment')

require 'clockwork'
require 'resque'
include Clockwork

every(10.seconds, 'EyefiJob') {
  puts "enqueue eyefijob"
  Resque.enqueue(EyefiJob)
}