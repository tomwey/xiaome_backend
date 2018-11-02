ActiveAdmin.register Project do
  
  menu label: '兼职管理'
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :title, :body, :money, :opened, :begin_date, :end_date
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

filter :uniq_id
filter :title
filter :created_at
filter :begin_date
filter :end_date

# filter :project_id, as: :select, label: '兼职项目', collection: Project.where(opened: true).order('id desc').limit(20).map { |p| ["[编号:#{p.uniq_id}]#{p.title}", p.id] }
# filter :user_id, as: :select, label: '申请人', collection: User.order('id desc').map { |u| ["[#{u.mobile}]#{u.profile.try(:name)}", u.id] }
# filter :money, label: '申请工资'
# filter :created_at, label: '申请时间'
# filter :pay_account, label: '支付宝账号手机'
# filter :pay_name, label: '支付宝账号姓名'


actions :all, except: [:destroy]

index do
  selectable_column
  column('#', :id)
  column '编号', :uniq_id
  column :title, sortable: false
  column '兼职工作时间' do |o|
    o.begin_date ? "#{o.begin_date} 至 #{o.end_date}" : '--'
  end
  column '兼职工资价格', :money
  column :opened, sortable: false
  column :created_at
  
  column '工资汇总 (元)' do |o|
    raw("工资发放总额: #{o.total_salary_money}<br>已发工资总额: #{o.sent_salary_money}<br>待发工资总额: #{o.senting_salary_money}")
  end
  
  actions defaults: false do |o|
    item "查看", [:admin, o] if authorized?(:read, o)
    item "编辑", edit_admin_project_path(o) if authorized?(:update, o)
    item "删除", delete_admin_project_path(o), method: :put, data: { confirm: '你确定吗？' } if authorized?(:destroy, o)
    item "确认发放工资", confirm_pay_admin_project_path(o), method: :put, data: { confirm: '你确定吗？' } if authorized?(:confirm_pay, o) and o.senting_salary_money > 0.0

  end
  
end

member_action :confirm_pay, method: :put do
  authorize! :confirm_pay, resource
  resource.confirm_pay!
  redirect_to collection_path, notice: '已发放'
end

member_action :delete, method: :put do
  authorize! :destroy, resource
  resource.delete!
  redirect_to collection_path, notice: '已删除'
end

batch_action :delete do |ids|
  authorize! :destroy, Project
  batch_action_collection.find(ids).each do |e|
    e.delete!
  end
  redirect_to collection_path, alert: "已删除"
end

show do
  attributes_table do
    row :title
    row '兼职工作时间' do |o|
      "#{o.begin_date} 至 #{o.end_date}"
    end
    row :money
    row :body do |o|
      simple_format o.body
    end
    row '工资发放总额' do |o|
      o.total_salary_money
    end
    row '已发工资总额' do |o|
      o.sent_salary_money
    end
    row :opened
    row :created_at
    row :updated_at
  end
  
  panel "工资发放记录" do
    table_for project.salaries.order('id desc') do
      
      # selectable_column
      column('#', :id)
      column '流水号', :uniq_id
      column '用户', sortable: false do |o|
        o.user.try(:profile) ? link_to(o.user.try(:profile).try(:name), [:admin, o.user.try(:profile)]) : '--'
      end
      column '支付宝账号', :pay_account, sortable: false
      column '支付宝姓名', :pay_name, sortable: false
      column '工资金额(元)', :money
      column('确认发放时间', :payed_at)
      column '申请发放时间' do |o|
        o.created_at.strftime('%Y年%m月%d日 %H:%M:%S')
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
      
      # column '操作', class: 'col-actions' do |o|
      #   div class: 'table_actions' do
      #     link_to '审核通过', '#'
      #   end
      #   # item "查看", [:admin, o]
      # end
      
    end
  end
  
end

form do |f|
  f.semantic_errors
  f.inputs do
    f.input :title
    f.input :begin_date, as: :string, label: '开始日期', placeholder: '2018-01-21'
    f.input :end_date, as: :string, label: '截止日期', placeholder: '2018-01-21'
    f.input :money, placeholder: '例如：150元'
    f.input :body, as: :text, input_html: { class: 'redactor' }, placeholder: '网页内容，支持图文混排', hint: '网页内容，支持图文混排'
    f.input :opened, label: '是否打开'
  end
  actions
end

end
