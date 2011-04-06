Given /^I have no subscribers$/ do
  MailingSubscriber.delete_all
end

Given /^I (only )?have subscribers titled "?([^\"]*)"?$/ do |only, titles|
  Subscriber.delete_all if only
  titles.split(', ').each do |title|
    Subscriber.create(:email => title)
  end
end

Then /^I should have ([0-9]+) subscribers?$/ do |count|
  MailingSubscriber.count.should == count.to_i
end
