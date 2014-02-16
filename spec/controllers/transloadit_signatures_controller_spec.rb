require 'spec_helper'

describe TransloaditSignaturesController do
  context "when logged in" do
    before do
      sign_in_user
    end

    describe "GET template" do
      context "with things_store_original template id requested" do
        it "renders json" do
          get :template, { format: 'json', template_id: 'things_store_original' }
          expect(JSON.parse(response.body).length).to eql(2)
        end
      end

      context "with things_crop template id requested" do
        it "renders json" do
          get :template, { format: 'json', template_id: 'things_crop' }
          expect(JSON.parse(response.body).length).to eql(2)
        end
      end

      context "with template id that does not exist is requested" do
        it "renders nothing" do
          get :template, { format: 'json', template_id: 'does_not_exist' }
          expect(JSON.parse(response.body)).to eql({})
        end
      end
    end
  end

  context "when not logged in" do
    describe "GET template" do
      it "renders json" do
        get :template, { format: 'json', template_id: 'things_store_original' }
        expect(JSON.parse(response.body).has_key?('error')).to be_true
      end
    end
  end
end
