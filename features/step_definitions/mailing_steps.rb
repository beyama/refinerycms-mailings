Given /^I have no mailings$/ do
  Mailing.delete_all
end

Given /^I (only )?have mailings titled "?([^\"]*)"?$/ do |only, titles|
  Mailing.delete_all if only
  titles.split(', ').each do |title|
    Mailing.create(:from => ::Refinery::Mailings.from_addresses.first, :subject => title)
  end
end

Given /^I have a default sender$/ do
  RefinerySetting.set(:mailings_from_addresses, ['noreply@example.org'])
end

Given /^I have no mails$/ do
  ActionMailer::Base.deliveries.clear
end

Then /^I should have ([0-9]+) mailings?$/ do |count|
  Mailing.count.should == count.to_i
end

Then /^I should have (\d+) mails?$/ do |count|
  ActionMailer::Base.deliveries.size.should == count.to_i
end

When /^after running the mailing job$/ do
  ::Refinery::Mailings::NewsletterJob.new(Mailing.first, 'example.com').perform
end
