class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_name, :email, :number, :created_at
end