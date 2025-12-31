class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles do |t|
      t.string :name, null: false, comment: "氏名"
      t.date :birthday, null: false, comment: "生年月日"
      t.integer :gender, comment: "性別（enum: male, female, other, prefer_not_to_say）"
      t.text :career_profile, comment: "キャリアプロフィール"
      t.text :job_summary, comment: "職務要約"
      t.date :document_date, default: -> { "(CURRENT_DATE)" }, comment: "記入日（職務経歴書の記入日）"

      t.timestamps
    end

    add_index :profiles, :name
  end
end

