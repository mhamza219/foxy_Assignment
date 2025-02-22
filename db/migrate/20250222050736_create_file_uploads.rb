class CreateFileUploads < ActiveRecord::Migration[7.1]
  def change
    create_table :file_uploads do |t|
      t.string :title
      t.string :description
      t.string :share_key
      t.string :user_id

      t.timestamps
    end
  end
end
