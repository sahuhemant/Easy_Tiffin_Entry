ActiveAdmin.register User do
  permit_params :name, :user_name, :password, :password_confirmation, :number, 
                :stripe_customer_id, :email, :otp, :otp_verified

  index do
    selectable_column
    id_column
    column :name
    column :user_name
    column :email
    column :number
    column :stripe_customer_id
    column :otp
    column :otp_verified
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :user_name
  filter :email
  filter :number
  filter :otp_verified
  filter :created_at
  filter :updated_at

  show do
    attributes_table do
      row :id
      row :name
      row :user_name
      row :email
      row :number
      row :stripe_customer_id
      row :otp
      row :otp_generated_at
      row :otp_verified
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs 'User Details' do
      f.input :name
      f.input :user_name
      f.input :email
      f.input :number
      f.input :stripe_customer_id
      f.input :otp
      f.input :otp_verified
    end

    f.inputs 'Password' do
      f.input :password
      f.input :password_confirmation
    end

    f.actions
  end
end
