ActiveAdmin.register Salary do
  
  menu label: '工资发放'
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

index do
  selectable_column
  column('#', :id)
  column 'ID', :uniq_id
  column '用户', sortable: false do |o|
    link_to o.user.try(:profile).try(:name), [:admin, o.user]
  end
  column '兼职', sortable: false do |o|
    link_to o.project.try(:title), [:admin, o.project]
  end
  column '支付宝账号', :pay_account, sortable: false
  column '支付宝姓名', :pay_name, sortable: false
  column '工资金额(元)', :money
  column('确认发放时间', :payed_at)
  column '申请发放时间' do |o|
    o.created_at.strftime('%Y年%m月%d日 %H:%M:%S')
  end
  
  actions defaults: false do |o|
    item "查看", [:admin, o]
    if current_admin_user.admin? && o.payed_at.blank?
      item "确认发放工资", confirm_pay_admin_salary_path(o), method: :put
    end
  end
  
end

batch_action :confirm_pay do |ids|
  batch_action_collection.find(ids).each do |e|
    e.confirm_pay!
  end
  redirect_to collection_path, alert: "已发放"
end
member_action :confirm_pay, method: :put do
  msg = resource.confirm_pay!
  if msg.blank?
    msg = '发放成功'
  end
  
  redirect_to collection_path, notice: msg
end

end
