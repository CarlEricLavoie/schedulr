require 'minitest/autorun'
require 'mocha/test_unit'
# require 'spec_helper'


Given(/^I have (\d+) activity defined$/) do |arg1|
  step %(I run `schedulr add activity_name`)
  # schedulr.add('activity')
end

Given(/^Timer is running$/) do
  step %(I run `schedulr start`)
end

Given(/^today is '(\d+)\-(\d+)\-(\d+)'$/) do |arg1, arg2, arg3|
  @time_now = Time.new(arg1, arg2, arg3)
  Time.stubs(:now).returns(@time_now)
end


When(/^I wait for (\d+) minutes$/) do |arg1|
  Time.stubs(:now).returns(@time_now + (60*arg1.to_i))
end

When /^I get help for "([^"]*)"$/ do |app_name|
  @app_name = app_name
  step %(I run `#{app_name} help`)
end

Then(/^the output should be blank$/) do
  expect(all_commands).not_to include_an_object have_output an_output_string_matching(expected)
end



