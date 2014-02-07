Given /^the translator can translate$/ do 
  Comment.any_instance.stub(:translate).and_return('successful translation')
end

Given /^the translator cannot translate$/ do
  Comment.any_instance.stub(:can_translate?).and_return(false)
end

When /^I click on the translate link$/ do
  click_link 'translate-comment-1'
end

Then /^I should see a link to translate the comment$/ do
  page.should have_css('#translate-comment-1')
end

Then /^I should not see a link to translate the comment$/ do
  page.should have_no_css('#translate-comment-1')
end

Then /^the translation should appear$/ do
  page.should have_content('successful translation')
end

Then /^a failure to translate message should appear$/ do
  page.should have_content('Unable to complete translation')
end