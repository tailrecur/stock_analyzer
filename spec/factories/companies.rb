# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :company do |f|
  f.name "MyString"
  f.sequence(:mc_code) {|n| "mc#{n}" }
end