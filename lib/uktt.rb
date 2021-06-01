Dir[File.join(__dir__, 'uktt', 'resources', '*.rb')].sort.each { |file| require file }

require_relative 'uktt/version'
require_relative 'uktt/http'
require_relative 'uktt/parser'
