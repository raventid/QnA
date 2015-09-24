class CommentSerializer < ActiveModel::Serializer
  attributes :id, :comment_body, :created_at, :updated_at
end
