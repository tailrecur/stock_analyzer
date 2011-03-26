require 'spec_helper'

describe FormulaeController do
  it "should apply formulae to company" do

    get :apply, :company_id => 1, :format => 'json'
    json = JSON.parse(response.body)
    json.length.should > 0
    formula = json.first
    formula['result'].should be_false
    formula['illustration'].should_not be_nil
  end
end
