#we need the actual library file
require_relative "../lib/truevault"

#dependencies
require "factory_girl"
require "minitest/autorun"
require "webmock/minitest"
require "dotenv"
require "pry"
require "vcr"
require "turn"

Dotenv.load

Turn.config do |c|
	c.format  = :pretty
	c.natural = true
end

class Minitest::Spec
  include FactoryGirl::Syntax::Methods
end

FactoryGirl.find_definitions

REDACTED_STRING = "REDACTED_ID"
REDACTED_WHITELIST = ["group_id", "user_id"]

VCR.configure do |c|
	c.cassette_library_dir = "spec/fixtures/truevault_cassettes"
	c.hook_into :webmock
	c.default_cassette_options = { :match_requests_on => [:method], :record => :new_episodes }
	c.before_record do |interaction|
		interaction.request.body.gsub!(/(\S{8}-\S{4}-\S{4}-\S{4}-\S{12})/, REDACTED_STRING)
		interaction.request.uri.gsub!(/(\S{8}-\S{4}-\S{4}-\S{4}-\S{12})/, REDACTED_STRING)

		whitelist = REDACTED_WHITELIST.map{|string| "\\\"#{string}\\\": \\\""}.join("|")
		interaction.response.body.gsub!(/(?<!#{whitelist})(\S{8}-\S{4}-\S{4}-\S{4}-\S{12})/, REDACTED_STRING)
	end

end

def random_string(length = 10)
	(0...length).map { (65 + rand(26)).chr }.join
end
