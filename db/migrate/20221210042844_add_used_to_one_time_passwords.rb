# frozen_string_literal: true

class AddUsedToOneTimePasswords < ActiveRecord::Migration[7.0]
  def change
    add_column :one_time_passwords, :used, :boolean, default: false, null: false
  end
end
