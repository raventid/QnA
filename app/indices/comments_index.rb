ThinkingSphinx::Index.define :comment, with: :active_record do
  indexes comment_body
  indexes user.email, as: :author, sortable: true

  has user_id, created_at, updated_at
end