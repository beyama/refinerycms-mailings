User.all.each do |user|
  if user.plugins.where(:name => 'mailings').blank?
    user.plugins.create(:name => 'mailings',
                        :position => (user.plugins.maximum(:position) || -1) +1)
  end
end

# Fix "Unknown column" error after "RemoveTranslatedFieldsFromPages"
Page.reset_column_information

page = Page.create(
  :title => 'Newsletter',
  :link_url => '/newsletter',
  :deletable => false,
  :position => ((Page.maximum(:position, :conditions => {:parent_id => nil}) || -1)+1),
  :menu_match => '^/newsletter(\/|\/.+?|)$'
)

approve = Page.create(
  :title => 'Newsletter approve',
  :link_url => '/newsletter/approve',
  :deletable => false,
  :parent_id => page.id,
  :show_in_menu => false,
  :position => ((Page.maximum(:position, :conditions => {:parent_id => nil}) || -1)+1)
)

[page, approve].each do |p|
  Page.default_parts.each do |default_page_part|
    p.parts.create(:title => default_page_part, :body => nil)
  end
end


