ActiveAdmin.register Project do
  
  menu label: '兼职'
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :title, :body, :money, :opened
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
  column '编号', :uniq_id
  column :title, sortable: false
  column '兼职工资价格', :money
  column '工资发放总金额' do |o|
    o.total_salary_money
  end
  column '已发工资总额' do |o|
    o.sent_salary_money
  end
  
  column :opened, sortable: false
  column :created_at
  
  actions defaults: false do |o|
    item "查看", [:admin, o]
    # if current_admin_user.admin? && o.payed_at.blank?
    item "编辑", edit_admin_project_path(o)
    item "删除", admin_project_path(o), method: :delete, data: { confirm: '你确定吗？' }
    item "确认发放工资", confirm_pay_admin_project_path(o), method: :put, data: { confirm: '你确定吗？' }
    # end
    
  end
  
end

member_action :confirm_pay, method: :put do
  resource.confirm_pay!
  redirect_to collection_path, notice: '已发放'
end

show do
  attributes_table do
    row :title
    row :money
    row :body do |o|
      simple_format o.body
    end
    row :opened
    row :created_at
    row :updated_at
  end
  
  panel "工资发放申请记录" do
    table_for project.salaries do
      # selectable_column
      column('#', :id)
      column '流水号', :uniq_id
      column '用户', sortable: false do |o|
        link_to o.user.try(:profile).try(:name), [:admin, o.user.try(:profile)]
      end
      column '支付宝账号', :pay_account, sortable: false
      column '支付宝姓名', :pay_name, sortable: false
      column '工资金额(元)', :money
      column('确认发放时间', :payed_at)
      column '申请发放时间' do |o|
        o.created_at.strftime('%Y年%m月%d日 %H:%M:%S')
      end
      
      
  
      # actions defaults: false do |o|
      #   item "查看", [:admin, o]
      #   if current_admin_user.admin? && o.payed_at.blank?
      #     item "确认发放工资", confirm_pay_admin_salary_path(o), method: :put
      #     item "编辑", edit_admin_salary_path(o)
      #     item "删除", admin_salary_path(o), method: :delete, data: { confirm: '你确定吗？' }
      #   end
      #
      # end
      
    end
  end
end

form do |f|
  f.semantic_errors
  f.inputs do
    f.input :title
    f.input :money, placeholder: '例如：150元'
    f.input :body, as: :text, input_html: { class: 'redactor' }, placeholder: '网页内容，支持图文混排', hint: '网页内容，支持图文混排'
    f.input :opened, label: '是否打开'
  end
  actions
end

end
