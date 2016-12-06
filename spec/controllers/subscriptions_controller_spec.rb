require 'rails_helper'

describe SubscriptionsController do
  describe 'POST create' do
    let(:user) { Fabricate :user, activated: true }
    let(:plan) { Fabricate :plus_plan }
    let(:stripe_token) { 'abc' }

    let(:action) do
      post :create, plan_id: plan.to_param, stripeToken: stripe_token
    end

    before { set_user user }

    it_behaves_like 'a logged in action'
    it_behaves_like 'an activated action'

    context 'from basic to plus plan' do
      context 'with valid card' do
        it 'redirects to my_account' do
          change_result = double(:subscription_result, successful?: true)
          expect_any_instance_of(SubscriptionChange).to receive(:change).and_return(change_result)
          expect_any_instance_of(User).to receive(:plan).and_return(plan)

          action
          expect(response).to redirect_to(my_account_path)
        end
      end

      context 'with declined card' do
        it 'redirects to my_account' do
          change_result = double(:subscription_result, successful?: false, message: 'Card declined.')
          expect_any_instance_of(SubscriptionChange).to receive(:change).and_return(change_result)

          action
          expect(response).to redirect_to my_account_path
        end

        it 'sets the flash' do
          change_result = double(:subscription_result, successful?: false, message: 'Card declined.')
          expect_any_instance_of(SubscriptionChange).to receive(:change).and_return(change_result)

          action
          expect(flash[:danger]).to be_present
        end
      end
    end
  end
end
