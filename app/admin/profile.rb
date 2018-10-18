ActiveAdmin.register Profile do
  
  menu label: '用户资料'
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

actions :all, except: [:new, :create]

csv do
  column :id
  column('用户ID') { |s| s.user.try(:uid) }
  column :name
  column('登录手机') { |s| s.user.try(:mobile) }
  column('账号注册时间') { |s| s.user.try(:created_at) }
  column :idcard
  column :phone
  column :sex
  column :birth
  column :is_student
  column :college
  column :specialty
  column :created_at
end

index do
  selectable_column
  column('#', :id)
  column '用户ID' do |o|
    o.user.try(:uid)
  end
  column :name, sortable: false
  column '登录手机' do |o|
    o.user.try(:mobile)
  end
  column '账号注册时间' do |o|
    o.user.try(:created_at)
  end
  column :idcard, sortable: false
  column :phone
  column :sex, sortable: false
  column :birth, sortable: false
  column :is_student, sortable: false
  column :college, sortable: false
  column :specialty, sortable: false
  column :created_at
  
  actions
  
end

end
