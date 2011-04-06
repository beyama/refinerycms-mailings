Given /^I have no mailing_templates$/ do
  MailingTemplate.delete_all
end

Given /^I (only )?have mailing_templates titled "?([^\"]*)"?$/ do |only, titles|
  MailingTemplate.delete_all if only
  titles.split(', ').each do |title|
    MailingTemplate.create(:slug => title)
  end
end

Then /^I should have ([0-9]+) mailing_templates?$/ do |count|
  MailingTemplate.count.should == count.to_i
end
