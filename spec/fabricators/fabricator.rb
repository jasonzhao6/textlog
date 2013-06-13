Fabricator(:message) do
  message { Faker::Lorem.paragraph(2) }
end

Fabricator(:activity) do
  message
  activity { Faker::Lorem.word }
end

Fabricator(:friend) do
  name { Faker::Name.name }
  fb_id { Faker::Internet.user_name }
end