require 'rspec/core'  # to fix annoying "undefined method `configuration' for RSpec:Module (NoMethodError)"

Then /^the output should contain all of these:$/ do |table|
  table.raw.flatten.each do |string|
    assert_partial_output(string, all_output)
  end
end

Then /^the output should not contain any of these:$/ do |table|
  table.raw.flatten.each do |string|
    all_output.should_not =~ regexp(string)
  end
end

Then /^the example(?:s)? should(?: all)? pass$/ do
  step %q{the output should contain "0 failures"}
  step %q{the exit status should be 0}
end

Then /^the file "([^"]*)" should contain:$/ do |file, partial_content|
  check_file_content(file, partial_content, true)
end

Then /^the backtrace\-normalized output should contain:$/ do |partial_output|
  # ruby 1.9 includes additional stuff in the backtrace,
  # so we need to normalize it to compare it with our expected output.
  normalized_output = all_output.split("\n").map do |line|
    line =~ /(^\s+# [^:]+:\d+)/ ? $1 : line # http://rubular.com/r/zDD7DdWyzF
  end.join("\n")

  normalized_output.should =~ regexp(partial_output)
end

# This step can be generalized if it's ever used to test other colors
Then /^the failing example is printed in magenta$/ do
  # \e[35m = enable magenta
  # \e[0m  = reset colors
  expect(all_output).to include("\e[35m" + "F" + "\e[0m")
end
