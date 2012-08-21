# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  Movie.create!(movie)
  end
  #assert false, "Unimplemented"
end


# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  page.html.should match /#{e1}.*#{e2}/m
  #flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(/( *)*,( *)*/).select{|i| i=~ /\w/}.each do |rating|
  if uncheck then
    step %{I uncheck "ratings[#{rating}]"}
  else
    step %{I check "ratings[#{rating}]"}   
  end
  end
end

When /I click the "(.*)" button/ do |button|
  click_button(button)
end

Then /^I should see movies with ratings (.*) displayed$/ do |ratings|
  ratings.split(/( *)*and( *)*/).select{|i| i=~ /\w/}.each do |rating|
    page.should have_content(Movie.find_all_by_rating)
  end
end

  
Then /^the "(.*)" checkbox should be (un)?checked$/ do |field, unchecked|
  if unchecked then
    #step %{I uncheck "ratings_#{field}"}
    uncheck("#{field}")
  else 
    check("#{field}")
  end
end

And /I should see all the movies/ do
  movies = Movie.all.map(&:title)
  assert_equal page.all('table#movies tbody tr').count, movies.length
  movies.each do |movie|
    step %{I should see "#{movie}"}
  end
end

And /I should not see any movies/ do
  page.all('table#movies tbody tr').count == 0
end
