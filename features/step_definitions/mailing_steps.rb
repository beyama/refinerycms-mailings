Given /^I have no mailings$/ do
  Mailing.delete_all
end

Given /^I (only )?have mailings titled "?([^\"]*)"?$/ do |only, titles|
  Mailing.delete_all if only
  titles.split(', ').each do |title|
    Mailing.create(:subject => title)
  end
end

Then /^I should have ([0-9]+) mailings?$/ do |count|
  Mailing.count.should == count.to_i
end
