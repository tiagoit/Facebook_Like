# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  include Devise::Test::IntegrationHelpers

  let(:user) { User.create(first_name: "Test", email: 'test@test.com', 
       password: "password", password_confirmation: "password") }

  describe 'Post create' do 
    it 'creates a valid post for a logged user' do 
      Post.create(user: user, content: 'Post Content')
      sign_in user
      visit 'users/show'
      expect(page).to have_content('Post Content')
      expect(Post.count).to eql(1)
    end

    it 'tries to create an invalid post' do 
      Post.create(user: user, content: '')
      sign_in user
      visit 'users/show'
      expect(page).to have_content('No posts yet')
      expect(Post.count).to eql(0)
    end
  end

  describe 'Posts destroy' do
    it 'destroy a post' do
      sign_in user
      Post.create(user: user, content: 'Post Content')
      expect(Post.count).to eql(1)
      visit '/users/show'
      expect(page).to have_content('Post Content')
      Post.first.destroy
      expect(Post.count).to eql(0)
      visit '/users/show'
      expect(page).to have_content('No posts yet')
    end
  end

  describe 'Posts index' do
    let(:user_1) { User.create(first_name: "Test-1", email: 'test-1@test.com', 
                  password: "password", password_confirmation: "password") }
    let(:user_2) { User.create(first_name: "Test-2", email: 'test-2@test.com', 
                  password: "password", password_confirmation: "password") }

    it 'does not show current user posts' do
      sign_in user
      Post.create(user: user, content: 'Post Content')
      Post.create(user: user_1, content: 'Content User 1')
      Post.create(user: user_2, content: 'Content User 2')
      visit '/posts'
      expect(page).to_not have_content('Post Content')
    end
  end
end
