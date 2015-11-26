User.create(name:  "Chu Anh Tuan",
             email: "tuan@framgia.com",
             password:              "123456",
             password_confirmation: "123456",
             role: :supervisor)
User.create(name:  "Muhammad Tamzid",
             email: "muhammad.tamzid@gmail.com",
             password:              "123456",
             password_confirmation: "123456",
             role: :supervisor)
User.create(name:  "Sujoy Badhon Kopil Deb Prince Subol Datta (Sanjay)",
             email: "sujoy@gmail.com",
             password:              "123456",
             password_confirmation: "123456",
             role: :supervisor)
User.create(name:  "Sirajus Salekin",
             email: "sjsalekin@gmail.com",
             password:              "123456",
             password_confirmation: "123456",
             role: :supervisor)

20.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "123456"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               role: :trainee)
end
