require 'spec_helper'

describe PagesController do
  describe 'GET main' do
    it "renders the 'main' templates" do
      get :main

      response.should render_template :main
    end
  end
end
