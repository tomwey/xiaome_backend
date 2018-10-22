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
  column('登录手机') { |s| s.user.try(:mobile).to_s }
  column(:idcard) { |s| '身份证: ' + s.idcard.to_s }
  column :phone
  column :sex
  column :birth
  column(:is_student) { |s| s.is_student ? '在读' : '--' }
  column :college
  column :specialty
  column('账号注册时间') { |s| s.user.try(:created_at) }
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
  column '工资信息' do |o|
    raw("已领取工资: #{o.payed_salary}<br>未领取工资: #{o.unpayed_salary}")
  end
  column '基本信息' do |o|
    raw("身份证: #{o.idcard}<br>电话: #{o.phone}<br>性别: #{o.sex}<br>生日: #{o.birth}")
  end
  column :is_student, sortable: false
  column '学校/专业' do |o|
    raw("学校: #{o.college}<br>专业: #{o.specialty}")
  end
  column '账号注册时间' do |o|
    o.user.try(:created_at)
  end
  
  actions
  
end

# show do
#   attributes_table do
#     row :title
#     row :money
#     row :body do |o|
#       simple_format o.body
#     end
#
#     row :opened
#     row :created_at
#     row :updated_at
#   end
#
#   panel "工资发放记录" do
#     table_for project.salaries.order('id desc') do
#
#       # selectable_column
#       column('#', :id)
#       column '流水号', :uniq_id
#       column '用户', sortable: false do |o|
#         link_to o.user.try(:profile).try(:name), [:admin, o.user.try(:profile)]
#       end
#       column '支付宝账号', :pay_account, sortable: false
#       column '支付宝姓名', :pay_name, sortable: false
#       column '工资金额(元)', :money
#       column('确认发放时间', :payed_at)
#       column '申请发放时间' do |o|
#         o.created_at.strftime('%Y年%m月%d日 %H:%M:%S')
#       end
#
#       # column '操作', class: 'col-actions' do |o|
#       #   div class: 'table_actions' do
#       #     link_to '审核通过', '#'
#       #   end
#       #   # item "查看", [:admin, o]
#       # end
#
#     end
#   end
#
# end

end
