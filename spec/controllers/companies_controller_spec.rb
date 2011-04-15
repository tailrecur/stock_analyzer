require 'spec_helper'

describe CompaniesController do
  describe "has_scope" do
    it "should retrieve matching companies by name" do
      Company.track_method(:name_like)
      get :index, :name_like => '123', :format => 'json'
      response.should be_ok
      Company.should have_received(:name_like).with('123')
    end
  end

  it { should respond_to('json')}

end
