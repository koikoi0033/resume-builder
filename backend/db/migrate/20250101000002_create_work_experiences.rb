class CreateWorkExperiences < ActiveRecord::Migration[8.1]
  def change
    create_table :work_experiences do |t|
      t.references :profile, null: false, foreign_key: true, comment: "プロフィールID"
      t.string :company_name, null: false, comment: "会社名"
      t.string :position, comment: "役職・職位"
      t.date :start_date, null: false, comment: "開始日"
      t.date :end_date, comment: "終了日（nullの場合は在職中）"
      t.text :job_description, comment: "職務内容・担当業務の詳細"
      t.text :achievements, comment: "主な成果・実績"
      t.text :technical_selection_reason, comment: "技術選定理由"
      t.integer :display_order, default: 0, null: false, comment: "表示順序"

      t.timestamps
    end

    add_index :work_experiences, [:profile_id, :display_order]
    add_index :work_experiences, :start_date
  end
end

