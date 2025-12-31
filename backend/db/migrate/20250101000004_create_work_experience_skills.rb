class CreateWorkExperienceSkills < ActiveRecord::Migration[8.1]
  def change
    create_table :work_experience_skills do |t|
      t.references :work_experience, null: false, foreign_key: true, comment: "職務経歴ID"
      t.references :skill, null: false, foreign_key: true, comment: "スキルID"
      t.date :start_date, null: false, comment: "使用開始日（職務経歴内での使用開始日）"
      t.date :end_date, comment: "使用終了日（職務経歴内での使用終了日、nullの場合は職務経歴の終了日まで）"
      t.text :usage_context, comment: "使用場面・用途（オプション）"

      t.timestamps
    end

    add_index :work_experience_skills, [:work_experience_id, :skill_id], unique: true, name: "index_work_experience_skills_on_work_exp_and_skill"
  end
end

