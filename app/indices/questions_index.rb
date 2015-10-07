ThinkingSphinx::Index.define :question, with: :active_record do
  # fields
  indexes title, sortable: true
  indexes body
  indexes user.email, as: :author, sortable: true
  set_property enable_star: 1
  set_property min_infix_len: 3

  # attributes
  has user_id, created_at, updated_at
end