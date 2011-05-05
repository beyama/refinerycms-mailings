Given /^I have no subscribers$/ do
  MailingSubscriber.delete_all
end

Given /^I (only )?have subscribers with email addresses "?([^\"]*)"?$/ do |only, addresses|
  MailingSubscriber.delete_all if only
  newsletter = MailingNewsletter.first
  addresses.split(', ').each do |address|
    sub = MailingSubscriber.create(:email => address)
    if newsletter
      sub.subscriptions.create :newsletter => newsletter, :verified_at => Time.now
    end
  end
end

Then /^I should have ([0-9]+) subscribers?$/ do |count|
  MailingSubscriber.count.should == count.to_i
end
