ActiveAdmin.register Salary do
  
  menu label: '工资发放申请'
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :pay_account, :pay_name, :money
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

filter :project_id, as: :select, label: '兼职项目', collection: Project.where(opened: true).order('id desc').map { |p| ["[编号:#{p.uniq_id}]#{p.title}", p.id] }
filter :user_id, as: :select, label: '申请人', collection: User.order('id desc').map { |u| ["[#{u.mobile}]#{u.profile.try(:name)}", u.id] }
filter :money, label: '申请工资'
filter :created_at, label: '申请时间'
filter :pay_account, label: '支付宝账号手机'
filter :pay_name, label: '支付宝账号姓名'

actions :all, except: [:new, :create]

scope :unpayed, default: true
scope :payed
scope :all

csv do
  column :id
  column :uniq_id
  column :money
  column(:project) { |s| "[编号:#{s.project.uniq_id}]#{s.project.title}" }
  column(:user) { |s| "[#{s.user.mobile}]#{s.user.profile.try(:name)}" }
  column :pay_name
  column :pay_account
  column :payed_at
  column :created_at
end

index do
  selectable_column
  column('#', :id)
  column '流水号', :uniq_id
  column '用户', sortable: false do |o|
    link_to o.user.try(:profile).try(:name), [:admin, o.user.try(:profile)]
  end
  column '兼职', sortable: false do |o|
    link_to o.project.try(:title), [:admin, o.project]
  end
  column '支付宝账号', :pay_account, sortable: false
  column '支付宝姓名', :pay_name, sortable: false
  column '工资金额(元)', :money
  column('确认发放时间', :payed_at)
  column '申请发放时间' do |o|
    o.created_at.strftime('%Y年%m月%d日 %H:%M')
  end
  column '状态' do |o|
    case o.state
    when 'pending' then '待审核'
    when 'approved' then '已审核'
    when 'rejected' then '被驳回'
    when 'payed' then '已发放'
    else ''
    end
  end
  
  actions defaults: false do |o|
    item "查看", [:admin, o] if authorized?(:read, o)
    # if current_admin_user.admin? && o.payed_at.blank?
    
    item "编辑", edit_admin_salary_path(o) if authorized?(:edit, o)
    item "删除", admin_salary_path(o), method: :delete, data: { confirm: '你确定吗？' } if authorized?(:destroy, o)
    item "确认发放工资", confirm_pay_admin_salary_path(o), method: :put if o.approved? and authorized?(:confirm_pay, o)
    item "审核通过", approve_admin_salary_path(o), method: :put if o.can_approve? and authorized?(:approve, o)
    item "审核驳回", reject_admin_salary_path(o), method: :put if o.can_reject? and authorized?(:reject, o)
    # end
    
  end
  
end

batch_action :confirm_pay do |ids|
  authorize! :confirm_pay, Salary
  batch_action_collection.find(ids).each do |e|
    e.confirm_pay!
  end
  redirect_to collection_path, alert: "已发放"
end

member_action :confirm_pay, method: :put do
  authorize! :confirm_pay, resource
  msg = resource.confirm_pay!
  if msg.blank?
    msg = '发放成功'
  end
  
  redirect_to collection_path, notice: msg
end

batch_action :approve do |ids|
  authorize! :approve, Salary
  batch_action_collection.find(ids).each do |e|
    e.approve
  end
  redirect_to collection_path, alert: "全部审核通过"
end

batch_action :reject do |ids|
  authorize! :reject, Salary
  batch_action_collection.find(ids).each do |e|
    e.reject
  end
  redirect_to collection_path, alert: "审核未通过"
end

member_action :approve, method: :put do
  authorize! :approve, resource
  resource.approve
  redirect_to collection_path, notice: '审核通过'
end

member_action :reject, method: :put do
  authorize! :reject, resource
  resource.reject
  redirect_to collection_path, notice: '审核不通过'
end

form do |f|
  f.semantic_errors
  f.inputs do
    f.input :money, label: '工资发放金额', input_html: { type: :number }
    f.input :pay_account, label: '支付宝账号手机'
    f.input :pay_name, label: '支付宝账号姓名'
  end
  actions
end

end
