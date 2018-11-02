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

filter :user_uid, label: 'UID', as: :number
filter :user_mobile, label: '登录手机', as: :string
filter :name
filter :sex
filter :birth
filter :phone
filter :idcard
filter :college
filter :specialty
filter :is_student
filter :user_created_at, as: :date_range, label: '账号注册时间'

actions :all, except: [:new, :create, :destroy]

# 导出Excel
action_item :export_excel, only: :index, if: proc { authorized?(:export_excel, Profile) } do
  link_to '导出Excel', action: 'export_excel'
end

collection_action :export_excel, method: :get do
  authorize! :export_excel, Profile
  @profiles = Profile.includes(:user).order('id desc')
  render xlsx: "用户资料-#{Time.zone.now.strftime('%Y-%m-%d-%H-%M-%S')}", template: 'admin/export_excel/profiles.xlsx.axlsx', layout: false
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
  
  actions defaults: false do |o|
    item "查看", [:admin, o] if authorized?(:read, o)
    item "编辑", edit_admin_profile_path(o) if authorized?(:update, o)
    item "删除", delete_admin_profile_path(o), method: :put, data: { confirm: '你确定吗？' } if authorized?(:destroy, o)
  end
  
end

member_action :delete, method: :put do
  authorize! :destroy, resource
  resource.delete!
  redirect_to collection_path, notice: '已删除'
end

batch_action :delete do |ids|
  authorize! :destroy, Profile
  batch_action_collection.find(ids).each do |e|
    e.delete!
  end
  redirect_to collection_path, alert: "已删除"
end

show do
  attributes_table do
    row '#' do |o|
      o.id
    end
    row '用户ID' do |o|
      o.user.try(:uid)
    end
    row :name
    row '登录手机' do |o|
      o.user.try(:mobile)
    end
    row '工资信息' do |o|
      raw("已领取工资: #{o.payed_salary}<br>未领取工资: #{o.unpayed_salary}")
    end
    row '基本信息' do |o|
      raw("身份证: #{o.idcard}<br>电话: #{o.phone}<br>性别: #{o.sex}<br>生日: #{o.birth}")
    end
    row :is_student
    row '学校/专业' do |o|
      raw("学校: #{o.college}<br>专业: #{o.specialty}")
    end
    row '账号注册时间' do |o|
      o.user.try(:created_at)
    end
    
  end

  panel "工资发放记录" do
    table_for profile.user.salaries.order('id desc') do

      # selectable_column
      column('#', :id)
      column '流水号', :uniq_id
      column '兼职项目', sortable: false do |o|
        o.project ? link_to(o.project.title, [:admin, o.project]) : '--'
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

    end
  end

end

end
