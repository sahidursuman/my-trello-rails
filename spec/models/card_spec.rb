require 'rails_helper'

describe Card do
  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:list) }

    it { should serialize(:activities).as(HashSerializer) }
  end

  context 'associations' do
    it { should belong_to(:list) }
    it { should have_many(:card_watchings) }
    it do
      should have_many(:watchers).
        through(:card_watchings).
        source(:user)
    end
  end

  # ====------------------------------====
  # Activities
  # ====------------------------------====

  describe '#add_activity' do
    let(:card) { Fabricate :card }
    let(:user) { Fabricate :user }
    let(:action) { card.add_activity 'edited the description.', user }

    context 'with NULL activity column' do
      it 'adds an "items" attribute to the object' do
        action
        expect(card.reload.activities[:items]).to be_instance_of(Array)
      end

      it 'adds activity to the "items" array' do
        action
        activities = card.reload.activities[:items]
        expect(activities.last[:text]).to eq('edited the description.')
      end

      it 'defaults to "log" type' do
        action
        activity = card.reload.activities[:items].last
        expect(activity[:type]).to eq('log')
      end
    end

    context 'with existing activity column' do
      before { card.add_activity 'edited the title.', user }

      it 'adds the new activity to the "items" array' do
        expect{ action }.to change{ card.reload.activities[:items].size }.by(1)
      end
    end

    context 'with invalid type' do
      let(:action) { card.add_activity 'this won\'t work', user, type: :bork }

      it 'returns false' do
        expect(action).to be(false)
      end
    end

    context 'with empty text' do
      let(:action) { card.add_activity '', user }

      it 'returns false' do
        expect(action).to be(false)
      end
    end
  end

  describe '#add_comment' do
    let(:card) { Fabricate :card }
    let(:user) { Fabricate :user }
    let(:action) { card.add_comment 'This is a comment', user }

    it 'adds an activity' do
      action
      expect(card.activities[:items].size).to eq(1)
    end

    it 'makes the new activity a comment type' do
      action
      activity = card.reload.activities[:items].last
      expect(activity[:type]).to eq('comment')
    end

    context 'with empty text' do
      let(:action) { card.add_comment '', user }

      it 'returns false' do
        expect(action).to be(false)
      end
    end
  end

  # ====------------------------------====
  # Checklists
  # ====------------------------------====

  describe '#add_checklist' do
    let(:card) { Fabricate :card }
    let(:user) { Fabricate :user }

    context 'with valid input' do
      let(:action) { card.add_checklist 'A Checklist', user }

      it 'adds a checklist' do
        action
        expect(card.reload.checklists[:lists].size).to eq(1)
      end

      it 'adds an activity' do
        action
        expect(card.reload.activities[:items].size).to eq(1)
      end
    end

    context 'with invalid input' do
      let(:action) { card.add_checklist '', user }

      it 'returns false' do
        expect(action).to be(false)
      end
    end
  end

  describe '#add_check_item' do
    let(:card) { Fabricate :card }
    let(:user) { Fabricate :user }
    before { card.add_checklist Faker::Lorem.words(4).join(' '), user }

    context 'with valid input' do
      let(:action) { card.add_check_item 'A check item', 0 }

      it 'adds a check_item to the checklist' do
        action
        # I know, it's ugly.
        check_item = card.reload.checklists[:lists][0][:check_items][0]
        expect(check_item[:name]).to eq('A check item')
        expect(check_item[:done]).to be(false)
      end

      it 'does not add a check_item to other checklists' do
        card.add_checklist Faker::Lorem.words(3).join(' '), user
        action
        expect(card.reload.checklists[:lists][1][:check_items]).to be_empty
      end
    end

    context 'with invalid input' do
      let(:action) { card.add_check_item '', 0 }

      it 'does not add a check_item to the checklist' do
        action
        checklist = card.reload.checklists[:lists][0]
        expect(checklist[:check_items]).to be_empty
      end

      it 'returns false' do
        expect(action).to be(false)
      end
    end
  end

  # ====------------------------------====
  # Overwritten Methods
  # ====------------------------------====

  describe '#update' do
    let(:card) { Fabricate :card }
    let(:user) { Fabricate :user }

    context 'when passing in one changed attribute' do
      let(:action) { card.update({ description: 'changed' }, user) }

      it 'updates the attribute' do
        action
        expect(card.reload.description).to eq('changed')
      end

      it 'adds an activity' do
        card.add_activity 'initializing the object so no errors are thrown', user
        expect{ action }.to change{ card.reload.activities[:items].size }.by(1)
      end
    end

    context 'when passing in multiple changed attributes' do
      let(:action) { card.update({ title: 'changed title', description: 'changed description' }, user) }

      it 'updates both attributes' do
        action
        expect(card.reload.title).to eq('changed title')
        expect(card.reload.description).to eq('changed description')
      end

      it 'adds two activities' do
        card.add_activity 'initializing the object so no errors are thrown', user
        expect{ action }.to change{ card.reload.activities[:items].size }.by(2)
      end
    end

    context 'when passing in changed and unchanged attributes' do
      let(:action) { card.update({ title: card.title, description: 'changed' }, user) }

      it 'updates one attribute' do
        unchanged_title = card.title
        action
        expect(card.reload.description).to eq('changed')
        expect(card.reload.title).to eq(unchanged_title)
      end

      it 'adds one activity' do
        card.add_activity 'initializing the object so no errors are thrown', user
        expect{ action }.to change{ card.reload.activities[:items].size }.by(1)
      end
    end

    context 'when passing in no changed attributes' do
      let(:action) { card.update({ title: card.title }, user) }

      it 'changes no attributes' do
        unchanged_title = card.title
        action
        expect(card.reload.title).to eq(unchanged_title)
      end

      it 'adds no activities' do
        card.add_activity 'initializing the object so no errors are thrown', user
        expect{ action }.to change{ card.reload.activities[:items].size }.by(0)
      end
    end
  end
end
